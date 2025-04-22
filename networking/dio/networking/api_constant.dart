class ApiConstant {
  ApiConstant._();
  static const String baseUrl = "https://app.sanadrewards.com/public/api/";
  static String usersPagination(int page) => 'getUser?page=$page';
  static String users = 'getUser';
}
