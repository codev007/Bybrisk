class mApiController {
  static String base_url = "https://bybrisk.com/apiV1/clients_module/";
  static String base_url_admin = "https://bybrisk.com/apiV1/admin_module/";
  final String logIn = base_url + "config/login.php";
  final String signup = base_url + "config/signup.php";
  final String fetchCategory = base_url + "fetch/fetchBusinessCategory.php";
  final String submitCategory = base_url + "config/chooseCategory.php";
  final String isPlanExist = base_url + "fetch/planExist.php";
  final String isDeliveryAvailable = base_url_admin + "read/pincodes.php";
  final String fetchPlansList = base_url + "fetch/allPlans.php";
  final String fetchWeightRange = base_url + "fetch/fetchRangeWeight.php";
  final String purchasePlan = base_url + "fetch/purchasePlan.php";
  final String expireCurrentPlan = base_url + "fetch/expirePlan.php";
  final String fetchDeliveryDates = base_url + "fetch/fetchDates.php";
  final String fetchDeliveries = base_url + "fetch/fetchDeliveries.php";
  final String addDelivery = base_url + "config/addDelivery.php";
  final String fetchSubscriptionPlans =
      base_url + "config/fetchSubscribedPlan.php";
  final String feedback = base_url + "config/feedback.php";
  final String fetchFaq = base_url + "fetch/fetchFaqs.php";
  final String distanceFactor = base_url + "fetch/fetchDistanceFactor.php";

}
