import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

//custom imports
import 'package:pedidos_luna/src/models/user.dart';

class UserRepository with ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookLogin _facebookLogin;
  FirebaseUser _firebaseUser;
  User _userModel;
  String _errorLogin;

  UserRepository({
    FirebaseAuth firebaseAuth,
    GoogleSignIn googleSignIn,
    FacebookLogin facebookLogin,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _facebookLogin = facebookLogin ?? FacebookLogin() {
    _userModel = User();
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw PlatformException(code: 'CANCEL_FOR_USER');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      AuthResult  user = await _linkUsers(credential);
      _firebaseUser = user.user;

      notifyListeners();

    } on PlatformException catch (ex) {
      _errorLogin = _processErrorLogin(ex);
      notifyListeners();
      throw ex;
    } catch (ex) {
      throw ex;
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      final FacebookLoginResult facebookUser = await _facebookLogin.logIn(['email']);

      if (facebookUser.status != FacebookLoginStatus.loggedIn) {
        if (facebookUser.status == FacebookLoginStatus.cancelledByUser) {
          throw PlatformException(code: 'CANCEL_FOR_USER');
        }

        throw PlatformException(code: 'Facebook' + facebookUser.status.toString());
      }

      final token = facebookUser.accessToken.token;

      final AuthCredential credential = FacebookAuthProvider.getCredential(
        accessToken: token,
      );

      final AuthResult user = await _linkUsers(credential);
      _firebaseUser = user.user;

      notifyListeners();

    } on PlatformException catch (ex) {
      _errorLogin = _processErrorLogin(ex);
      notifyListeners();
      throw ex;
    } catch (ex) {
      throw ex;
    }
  }

//  Future<void> singUp({String email, String password}) async {
//    return await Future.delayed(Duration(seconds: 5));
//  }

  Future<void> signOut() async {
    _userModel = new User();
    return Future.wait([
      _googleSignIn.signOut(),
      _facebookLogin.logOut(),
      _firebaseAuth.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    _firebaseUser = await _firebaseAuth.currentUser();
    return _firebaseUser != null;
  }

  Future<String> getUserName() async {
    return (await _firebaseAuth.currentUser()).displayName ?? 'Sin nombre.';
  }

  String getDisplayName() {
    return _firebaseUser.displayName ?? 'Sin nombre para mostrar.';
  }

  FirebaseUser get firebaseUser => _firebaseUser;


  String get ErrorMessage => _errorLogin;

  Future<void> signInWithCredentials(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      _firebaseUser = result.user;
    } on PlatformException catch (e) {
      _errorLogin = _processErrorLogin(e);
      throw e;
    }
  }

  Future<void> signUpWithCredentials(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      _firebaseUser = result.user;
    } on PlatformException catch (e) {
      _errorLogin = _processErrorLogin(e);
      throw e;
    }
  }

  Future<AuthResult> _linkUsers(AuthCredential credential, {List<String> signInMethods}) async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    AuthResult authResult;

    try {
      if (firebaseUser == null) {
        authResult = await _firebaseAuth.signInWithCredential(credential);
        return authResult;
      }

      authResult = await firebaseUser.linkWithCredential(credential);
      return authResult;

    } on PlatformException catch (error) {
      // si el primer login fue con google, se linkea el inicio con facebook a la cuenta de google
      print(error);
      await signInWithGoogle();
      authResult = await (await _firebaseAuth.currentUser())
          .linkWithCredential(credential);
      return authResult;
    } catch (ex) {
      print(ex);
      throw ex;
    }
  }

  String _processErrorLogin(PlatformException exception) {
    String message;

    switch (exception.code) {
      case 'ERROR_INVALID_EMAIL':
        message = 'Error en el correo.';
        break;
      case 'ERROR_WRONG_PASSWORD':
        message = 'La contraseña es incorrecta.';
        break;
      case 'ERROR_USER_NOT_FOUND':
        message = 'Usuario no encontrado.';
        break;
      case 'ERROR_USER_DISABLED':
        message = 'Usuario deshabilitado.';
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        message = 'Favor de esperar para hacer otro intento.';
        break;
      case 'ERROR_OPERATION_NOT_ALLOWED':
        message = 'Operacion no valida.';
        break;
      case 'CANCEL_FOR_USER':
        message = 'Inicio cancelado por el usuario';
        break;
      default:
        message = 'Favor de contactar al adimistrador' + exception.message;
    }

    return message;
  }

}
