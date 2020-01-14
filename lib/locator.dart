import 'package:okidoki/repository/user_repository.dart';
import 'package:okidoki/services/bildirim_gonderme_servis.dart';
import 'package:okidoki/services/fake_auth_service.dart';
import 'package:okidoki/services/firebase_auth_service.dart';
import 'package:okidoki/services/firebase_storage_service.dart';
import 'package:okidoki/services/firestore_db_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthenticationService());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => BildirimGondermeServis());
}
