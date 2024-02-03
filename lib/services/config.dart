class Config {
  // static const apiUrl = "onlineshopprovider-production-79b3.up.railway.app";
  // static const apiUrl = "localhost:3005";
  static const apiUrl = "10.0.2.2:3005";
  static const String loginUrl = "/api/login";
  static const String paymentUrl = "/stripe/create-checkout-session";
  static const String signupUrl = "/api/register";
  static const String getCartUrl = "/api/cart/find";
  static const String addCartUrl = "/api/cart";
  static const String getUserUrl = "/api/users/";
  static const String sneakers = "/api/products";
  static const String orders = "/api/orders";
  static const String search = "/api/products/search/";
  static const String profile = "/api/products/search/";
}
