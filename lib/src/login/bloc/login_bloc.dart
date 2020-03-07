import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import './bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:pedidos_luna/src/login/bloc/validators.dart';
import 'package:pedidos_luna/src/repositories/user_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  LoginState get initialState => LoginState.empty();

//  @override
//  Stream<LoginState> transformEvents(
//      Stream<LoginEvent> events,
//      Stream<LoginState> Function(LoginEvent event) next,
//      ) {
//    final nonDebounceStream = events.where((event) {
//      return (event is! EmailChanged && event is! PasswordChanged);
//    });
//    final debounceStream = events.where((event) {
//      return (event is EmailChanged || event is PasswordChanged);
//    }).debounceTime(Duration(milliseconds: 100));
//    return super.transformEvents(
//      nonDebounceStream.mergeWith([debounceStream]),
//      next,
//    );
//  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    }

    if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    }

    if (event is LoginWithFacebookPressed) {
      yield* _mapLoginWithFacebookPressedToState();
    }

    if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    try {
      yield LoginState.loading();
      await Future.delayed(Duration(seconds: 1));
      await _userRepository.signInWithGoogle();
      yield LoginState.success();
    } catch (ex) {
      yield LoginState.failure();
    }
  }

  Stream<LoginState> _mapLoginWithFacebookPressedToState() async* {
    try {
      yield LoginState.loading();
      await Future.delayed(Duration(seconds: 1));
      await _userRepository.signInWithFacebook();
      yield LoginState.success();
    } catch (e) {
      yield LoginState.failure();
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield LoginState.loading();
    try {
      await _userRepository.signUpWithCredentials(email, password);
      yield LoginState.success();
    } catch (e) {
      yield LoginState.failure();
    }
  }
}
