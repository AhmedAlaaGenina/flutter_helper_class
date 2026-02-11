class ApiConstant {
  ApiConstant._();
  // Base paths
  static const String apiVersion = '/api/v1';

  // Auth endpoints (Logged-in users)
  static const String register = '/user/auth/register';
  static const String login = '/user/auth/login';
  static const String userProfile = '/user/profile';

  // Guest auth endpoints
  static const String guestLogin = '/guest/invitations/check';
  static const String guestVerify = '/guest/auth/verify';

  // Shared auth endpoints
  static const String revokeAllTokens = '/auth/token/revoke-all';
  static const String refreshToken = '/auth/token/refresh';

  // Document endpoints (Guest)
  static const String guestDocuments = '/guest/documents';
  static String guestDocumentDownload(String id) =>
      '/guest/documents/$id/download';
  static String guestDocumentApproved(String id) =>
      '/guest/documents/$id/approved';
  static String guestDocumentRejected(String id) =>
      '/guest/documents/$id/rejected';
  static String guestDocumentViewed(String id) => '/guest/documents/$id/viewed';
  static String guestDocumentSignVisual(String id) =>
      '/guest/documents/$id/sign/visual';

  // Document endpoints (User)
  static const String userDocuments = '/user/documents';
  static String userDocumentById(String id) => '/user/documents/$id';
  static String userDocumentDownload(String id) =>
      '/user/documents/$id/download';
  static String userDocumentViewed(String id) => '/user/documents/$id/viewed';
  static String userDocumentApproved(String id) =>
      '/user/documents/$id/approved';
  static String userDocumentRejected(String id) =>
      '/user/documents/$id/rejected';
  static String userDocumentSignVisual(String id) =>
      '/user/documents/$id/sign/visual';
  static String userDocumentSignDigital(String id) =>
      '/user/documents/$id/sign/digital';
  static String getDocument(String id, {bool isGuest = false}) =>
      '/${isGuest ? 'guest' : 'user'}/documents/$id';

  // User Signatures endpoints
  static const String userSignatures = '/user/signatures';
  static const String userDashboard = '/user/dashboard';

  // Apple Sign-In Configuration (Required for Android)
  // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup

  static const String appleServiceId = 'com.idara.esign';
  static const String appleRedirectUri =
      'https://esign.idara.app/api/v1/auth/apple/callback';
}
