import 'package:okidoki/model/user.dart';

abstract class AuthBase {
  Future<User> currentUser();
  Future<User> singInAnonymously();
  Future<bool> signOut();

  Future<User> signInWithEmailandPassword(String email, String sifre);
  Future<User> createUserWithEmailandPassword(String email, String sifre);
}
