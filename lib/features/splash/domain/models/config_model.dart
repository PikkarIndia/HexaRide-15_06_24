class ConfigModel {
  String? businessName;
  String? logo;
  bool? bidOnFare;
  String? countryCode;
  String? businessAddress;
  String? businessContactPhone;
  String? businessContactEmail;
  String? businessSupportPhone;
  String? businessSupportEmail;
  String? baseUrl;
  ImageBaseUrl? imageBaseUrl;
  String? currencyDecimalPoint;
  String? currencyCode;
  String? currencySymbolPosition;
  AboutUs? aboutUs;
  AboutUs? privacyPolicy;
  AboutUs? termsAndConditions;
  AboutUs? legal;
  bool? smsVerification;
  bool? emailVerification;
  String? mapApiKey;
  int? paginationLimit;
  String? facebookLogin;
  String? googleLogin;
  List<String>? timeZones;
  bool? verification;
  List<PaymentGateways>? paymentGateways;
  bool? conversionStatus;
  int? conversionRate;
  bool? addIntermediatePoint;
  int? otpResendTime;
  String? currencySymbol;
  int? tripActiveTime;
  bool? reviewStatus;
  bool? maintenanceMode;
  String? webSocketUrl;
  String? webSocketPort;
  String? webSocketKey;
  double? searchRadius;
  double? completionRadius;
  bool? isDemo;
  bool? levelStatus;
  int? popularTips;

  ConfigModel(
      {this.businessName,
        this.logo,
        this.bidOnFare,
        this.countryCode,
        this.businessAddress,
        this.businessContactPhone,
        this.businessContactEmail,
        this.businessSupportPhone,
        this.businessSupportEmail,
        this.baseUrl,
        this.imageBaseUrl,
        this.currencyDecimalPoint,
        this.currencyCode,
        this.currencySymbolPosition,
        this.aboutUs,
        this.privacyPolicy,
        this.termsAndConditions,
        this.legal,
        this.smsVerification,
        this.emailVerification,
        this.mapApiKey,
        this.paginationLimit,
        this.facebookLogin,
        this.googleLogin,
        this.timeZones,
        this.verification,
        this.paymentGateways,
        this.conversionStatus,
        this.conversionRate,
        this.addIntermediatePoint,
        this.otpResendTime,
        this.currencySymbol,
        this.tripActiveTime,
        this.reviewStatus,
        this.maintenanceMode,
        this.webSocketUrl,
        this.webSocketPort,
        this.webSocketKey,
        this.searchRadius,
        this.completionRadius,
        this.isDemo,
        this.levelStatus,
        this.popularTips
      });

  ConfigModel.fromJson(Map<String, dynamic> json) {
    businessName = json['business_name'];
    logo = json['logo'];
    bidOnFare = json['bid_on_fare'];
    if(json['country_code'] != null && json['country_code'] != ""){
      countryCode = json['country_code']??'BD';
    }else{
      countryCode = 'BD';
    }

    businessAddress = json['business_address'];
    businessContactPhone = json['business_contact_phone'];
    businessContactEmail = json['business_contact_email'];
    businessSupportPhone = json['business_support_phone'];
    businessSupportEmail = json['business_support_email'];
    baseUrl = json['base_url'];
    webSocketUrl = json['websocket_url'];
    webSocketPort = json['websocket_port'];
    webSocketKey = json['websocket_key'];
    imageBaseUrl = json['image_base_url'] != null
        ? ImageBaseUrl.fromJson(json['image_base_url'])
        : null;
    currencyDecimalPoint = json['currency_decimal_point'];
    currencyCode = json['currency_code'];
    currencySymbolPosition = json['currency_symbol_position'];
    aboutUs = json['about_us'] != null
        ? AboutUs.fromJson(json['about_us'])
        : null;
    privacyPolicy = json['privacy_policy'] != null
        ? AboutUs.fromJson(json['privacy_policy'])
        : null;
    termsAndConditions = json['terms_and_conditions'] != null
        ? AboutUs.fromJson(json['terms_and_conditions'])
        : null;
    legal = json['legal'] != null
        ? AboutUs.fromJson(json['legal'])
        : null;
    smsVerification = json['sms_verification'];
    emailVerification = json['email_verification'];
    mapApiKey = json['map_api_key'];
    paginationLimit = json['pagination_limit'];
    facebookLogin = json['facebook_login'].toString();
    googleLogin = json['google_login'].toString();
    verification = '${json['verification']}'.contains('true');
    conversionStatus = json['conversion_status'];
    conversionRate = json['conversion_rate'];
    addIntermediatePoint = json['add_intermediate_points'];
    otpResendTime = int.parse(json['otp_resend_time'].toString());
    currencySymbol = json['currency_symbol'];
    tripActiveTime = json['trip_request_active_time'];
    reviewStatus = json['review_status'];
    maintenanceMode = json['maintenance_mode'];
    isDemo = json['is_demo'];
    levelStatus = json['level_status'];
    popularTips = json['popular_tips'];
    if (json['payment_gateways'] != null) {
      paymentGateways = <PaymentGateways>[];
      json['payment_gateways'].forEach((v) {
        paymentGateways!.add(PaymentGateways.fromJson(v));
      });
    }
    if(json['driver_completion_radius'] != null){
      try{
        completionRadius = json['driver_completion_radius'].toDouble();
      }catch(e){
        completionRadius = double.parse(json['driver_completion_radius'].toString());
      }
    }
    if(json['search_radius'] != null){
      try{
        searchRadius = json['search_radius'].toDouble();
      }catch(e){
        searchRadius = double.parse(json['search_radius'].toString());
      }
    }
  }

}


class ImageBaseUrl {
  String? profileImageDriver;
  String? banner;
  String? vehicleCategory;
  String? vehicleModel;
  String? vehicleBrand;
  String? profileImage;
  String? identityImage;
  String? documents;
  String? level;
  String? pages;
  String? conversation;
  String? parcel;

  ImageBaseUrl(
      {this.profileImageDriver,
        this.banner,
        this.vehicleCategory,
        this.vehicleModel,
        this.vehicleBrand,
        this.profileImage,
        this.identityImage,
        this.documents,
        this.level,
        this.pages,
        this.conversation,
        this.parcel
      });

  ImageBaseUrl.fromJson(Map<String, dynamic> json) {
    profileImageDriver = json['profile_image_driver'];
    banner = json['banner'];
    vehicleCategory = json['vehicle_category'];
    vehicleModel = json['vehicle_model'];
    vehicleBrand = json['vehicle_brand'];
    profileImage = json['profile_image'];
    identityImage = json['identity_image'];
    documents = json['documents'];
    level = json['level'];
    pages = json['pages'];
    conversation = json['conversation'];
    parcel =  json['parcel'];
  }


}
class AboutUs {
  String? image;
  String? name;
  String? shortDescription;
  String? longDescription;

  AboutUs({this.image, this.name, this.shortDescription, this.longDescription});

  AboutUs.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    shortDescription = json['short_description'];
    longDescription = json['long_description'];
  }

}
class PaymentGateways {
  String? gateway;
  String? gatewayTitle;
  String? gatewayImage;

  PaymentGateways({this.gateway, this.gatewayTitle, this.gatewayImage});

  PaymentGateways.fromJson(Map<String, dynamic> json) {
    gateway = json['gateway'];
    gatewayTitle = json['gateway_title'];
    gatewayImage = json['gateway_image'];
  }

}