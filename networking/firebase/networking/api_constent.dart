import 'networking.dart';

class FirebaseErrors {
  FirebaseErrors._();

  static const String invalidLoginCredential = "INVALID_LOGIN_CREDENTIALS";
  static const String invalidCredential = "invalid-credential";
  static const String weakPassword = 'weak-password';
  static const String emailAlreadyInUse = "email-already-in-use";
  static const String userNotFound = "user-not-found";
  static const String wrongPassword = "wrong-password";
  static const String invalidEmail = "invalid-email";
  static const String requiresRecentLogin = "requires-recent-login";
}

class ResponseMessage {
  ResponseMessage._();

  static const String invalidCredential =
      "Your email or Password is incorrect.";
  static const String weakPassword =
      "Your password is too weak, Password should be at least 6 characters";
  static const String emailAlreadyInUse =
      "The account already exists for that email.";
  static const String userNotFound = "User with this email doesn't exist.";
  static const String wrongPassword = "Your password is wrong.";
  static const String invalidEmail = "The email address is badly formatted.";
  static const String requiresRecentLogin = "Requires Recent Login";
  static const String localStorage = "Failed to load data from local storage";

  static String defaultFirebaseError(String error) => error;
  static const String noContent = "";
  static const String defaultError = "An undefined Error happened.";
}

enum DataSourceStatus {
  successful,
  invalidLoginCredential,
  invalidCredential,
  invalidEmail,
  weakPassword,
  emailAlreadyInUse,
  userNotFound,
  wrongPassword,
  undefinedFirebase,
  requiresRecentLogin,
  undefined,
  localStorage,
}

extension DataSourceExtension on DataSourceStatus {
  ApiErrorModel getFailure({String? errorMessage}) {
    switch (this) {
      case DataSourceStatus.successful:
        return ApiErrorModel(message: ResponseMessage.noContent);
      case DataSourceStatus.invalidLoginCredential:
      case DataSourceStatus.invalidCredential:
        return ApiErrorModel(message: ResponseMessage.invalidCredential);
      case DataSourceStatus.invalidEmail:
        return ApiErrorModel(message: ResponseMessage.invalidEmail);
      case DataSourceStatus.emailAlreadyInUse:
        return ApiErrorModel(message: ResponseMessage.emailAlreadyInUse);
      case DataSourceStatus.wrongPassword:
        return ApiErrorModel(message: ResponseMessage.wrongPassword);
      case DataSourceStatus.weakPassword:
        return ApiErrorModel(message: ResponseMessage.weakPassword);
      case DataSourceStatus.userNotFound:
        return ApiErrorModel(message: ResponseMessage.userNotFound);
      case DataSourceStatus.undefinedFirebase:
        return ApiErrorModel(
          message: ResponseMessage.defaultFirebaseError(errorMessage!),
        );
      case DataSourceStatus.undefined:
        return ApiErrorModel(message: ResponseMessage.defaultError);
      case DataSourceStatus.requiresRecentLogin:
        return ApiErrorModel(message: ResponseMessage.requiresRecentLogin);
      case DataSourceStatus.localStorage:
        return ApiErrorModel(
            message:
                ResponseMessage.localStorage + (errorMessage ?? ""));
    }
  }
}
