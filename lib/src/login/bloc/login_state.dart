import 'package:meta/meta.dart';

@immutable
class LoginState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool isNameValid;
  final bool isPhoneValid;

  LoginState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.isNameValid,
    @required this.isPhoneValid,
  });

  LoginState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    bool isNameValid,
    bool isPhoneValid,
  }) {
    return LoginState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      isNameValid: isNameValid ?? this.isNameValid,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
    );
  }

  bool get isFormValid => isEmailValid && isPasswordValid;

  factory LoginState.empty() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isNameValid: true,
      isPhoneValid: true,
    );
  }

  factory LoginState.loading() {
    return LoginState(
      isEmailValid: false,
      isPasswordValid: false,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      isNameValid: true,
      isPhoneValid: true,
    );
  }

  factory LoginState.failure() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      isNameValid: true,
      isPhoneValid: true,
    );
  }

  factory LoginState.success() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      isNameValid: true,
      isPhoneValid: true,
    );
  }

  LoginState update({
    bool isEmailValid,
    bool isPasswordValid,
    bool isNameValid,
    bool isPhoneValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isNameValid: isNameValid ?? this.isNameValid,
      isPhoneValid: isPhoneValid ?? this.isPhoneValid,
    );
  }

  @override
  String toString() {
    return '''LoginState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      isNameValid: $isNameValid,
      isPhoneValid: $isPhoneValid,
    }''';
  }
}
