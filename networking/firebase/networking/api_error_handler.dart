import 'package:fashion/core/util/util.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'networking.dart';

class ErrorHandler implements Exception {
  late ApiErrorModel apiErrorModel;

  ErrorHandler.handle(dynamic error, {bool isLocal = false}) {
    ePrint(error.toString());
    if (error is FirebaseAuthException) {
      apiErrorModel = _handleFirebaseAuthError(error);
    } else if (error is FirebaseException) {
      apiErrorModel = DataSourceStatus.undefinedFirebase
          .getFailure(errorMessage: error.message);
    } else if (isLocal) {
      apiErrorModel = DataSourceStatus.localStorage
          .getFailure(errorMessage: error.toString());
    } else {
      apiErrorModel = DataSourceStatus.undefined.getFailure();
    }
  }
}

ApiErrorModel _handleFirebaseAuthError(FirebaseAuthException error) {
  ePrint("error: $error");
  ePrint("error.code: ${error.code}");
  switch (error.code) {
    case FirebaseErrors.invalidLoginCredential:
    case FirebaseErrors.invalidCredential:
      return DataSourceStatus.invalidCredential.getFailure();
    case FirebaseErrors.wrongPassword:
      return DataSourceStatus.wrongPassword.getFailure();
    case FirebaseErrors.userNotFound:
      return DataSourceStatus.userNotFound.getFailure();
    case FirebaseErrors.weakPassword:
      return DataSourceStatus.weakPassword.getFailure();
    case FirebaseErrors.invalidEmail:
      return DataSourceStatus.invalidEmail.getFailure();
    case FirebaseErrors.emailAlreadyInUse:
      return DataSourceStatus.emailAlreadyInUse.getFailure();
    case FirebaseErrors.requiresRecentLogin:
      return DataSourceStatus.requiresRecentLogin.getFailure();
    default:
      return DataSourceStatus.undefinedFirebase
          .getFailure(errorMessage: error.message);
  }
}
