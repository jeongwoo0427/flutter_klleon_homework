import 'package:flutter_contacts_clean_architecture/core/service/local/hive/seeds/contact_seeds.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../feature/contact/data/model/contact_hive_model.dart';

/// Hive 사용을 위한 싱글톤 객체
class HiveService {
  static final HiveService _instance = HiveService._internal();

  HiveService._internal();

  factory HiveService() => _instance;

  static const int _hiveSchemaVersion = 1; // 여기에 버전 번호 설정 (필드 바뀌면 +1)
  static const String _versionBoxName = 'hive_version';
  static const String _contactsBoxName = 'contacts';

  late final Box<ContactHiveModel> contactBox;

  /// runApp 이전에 호출
  static Future<void> init({bool initSeed = false}) =>
      _instance._initialize(initSeed: initSeed);

  Future<void> _initialize({required bool initSeed}) async {
    await Hive.initFlutter();
    await _initAdapters();
    await _handleMigration();
    await _initBoxes();
    if (initSeed) {
      await _initSeeds();
    }
  }

  Future<void> _initAdapters() async {
    Hive.registerAdapter(ContactHiveModelAdapter());
  }

  Future<void> _handleMigration() async {
    final versionBox = await Hive.openBox<int>(_versionBoxName);

    final savedVersion = versionBox.get('schema_version');
    if (savedVersion != _hiveSchemaVersion) {
      // 버전이 다르면 초기화
      await Hive.deleteBoxFromDisk(_contactsBoxName);
      await versionBox.put('schema_version', _hiveSchemaVersion);
    }
  }

  Future<void> _initBoxes() async {
    contactBox = await Hive.openBox<ContactHiveModel>(_contactsBoxName);
  }

  Future<void> _initSeeds() async {
    await contactBox.clear();
    contactBox.addAll(contactSeeds);
  }
}
