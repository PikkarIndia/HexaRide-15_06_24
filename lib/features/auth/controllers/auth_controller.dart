import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_snackbar.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/auth/domain/models/sign_up_body.dart';
import 'package:ride_sharing_user_app/features/auth/domain/services/auth_service_interface.dart';
import 'package:ride_sharing_user_app/features/auth/screens/sign_in_screen.dart';
import 'package:ride_sharing_user_app/features/dashboard/controllers/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/features/auth/screens/reset_password_screen.dart';
import 'package:ride_sharing_user_app/features/auth/screens/verification_screen.dart';
import 'package:ride_sharing_user_app/features/profile/screens/edit_profile_screen.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/helper/pusher_helper.dart';

class AuthController extends GetxController implements GetxService {
  final AuthServiceInterface authServiceInterface;
  AuthController({required this.authServiceInterface});

  bool _isLoading = false;
  String _verificationCode = '';
  bool _isActiveRememberMe = false;
  bool otpVerifying = false;
  String countryDialCode = '+880';
  bool get isLoading => _isLoading;
  String get verificationCode => _verificationCode;
  bool get isActiveRememberMe => _isActiveRememberMe;

  void setCountryCode( String countryCode){
    countryDialCode  = countryDialCode;
    update();
  }

  Future<void> login(String countryCode, String phone, String password) async {
    _isLoading = true;
    update();
    Response? response = await authServiceInterface.login(phone: countryCode+phone, password: password);
    if(response!.statusCode == 200){
      _isLoading = false;
      setUserToken(response.body['data']['token']);
      PusherHelper.initilizePusher();
      updateToken();
      await Get.find<ProfileController>().getProfileInfo();
      _navigateLogin(countryCode, phone, password);
    }else if(response.statusCode == 202) {
      _isLoading = false;
      if(response.body['data']['is_phone_verified'] == 0) {
        Get.to(() =>  VerificationScreen(number: countryCode + phone, fromOtpLogin: true));
      }
    }else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }

    update();

  }

  Future<void> logOut() async {
    _isLoading = true;
    update();
    Response? response = await authServiceInterface.logOut();
    if(response!.statusCode == 200){
      Get.back();
      Get.offAll(const SignInScreen());
      showCustomSnackBar('successfully_logout'.tr, isError: false);
      clearSharedData();
    }else{
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> register(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    Response? response = await authServiceInterface.registration(signUpBody: signUpBody);
    if(response!.statusCode == 200){
      login('',signUpBody.phone!, signUpBody.password!);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();

  }

  void _navigateLogin(String code, String phone, String password){
    if (_isActiveRememberMe) {
      saveUserNumberAndPassword(code,phone, password);
    } else {
      clearUserNumberAndPassword();
    }
    Get.find<BottomMenuController>().resetNavBar();
    Get.find<BottomMenuController>().navigateToDashboard();
  }

  Future<Response> sendOtp(String phone) async{
    _isLoading = true;
    update();
    Response? response = await authServiceInterface.sendOtp(phone: phone);
    if(response!.statusCode == 200){
      _isLoading = false;
      showCustomSnackBar('otp_sent_successfully'.tr, isError: false);
    }else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }

    update();
    return response;
  }

  Future<Response> otpVerification(String phone, String otp, {bool accountVerification = false}) async{
    otpVerifying = true;
    update();
    Response? response = await authServiceInterface.verifyOtp(phone: phone, otp: otp);
    if(response!.statusCode == 200) {
      otpVerifying = false;
      if(response.body['response_code'] == 'otp_mismatch_404') {
        ApiChecker.checkApi(response);
      } else {
        _verificationCode = '';
        updateVerificationCode('');
        if(accountVerification) {
          setUserToken(response.body['data']['token']);
          updateToken();
          await Get.find<ProfileController>().getProfileInfo();
          if(response.body['data']['is_profile_verified'] == 0) {
            Get.offAll(() => const EditProfileScreen(fromLogin: true));
          }else {
            Get.find<BottomMenuController>().navigateToDashboard();
          }
        }else{
          otpVerifying = false;
          Get.to(() =>  ResetPasswordScreen(phoneNumber: phone));
        }
      }
    }else{
      otpVerifying = false;
      ApiChecker.checkApi(response);
    }
    otpVerifying = false;
    update();
    return response;
  }

  Future<Response> otpLogin(String phone, String otp, {bool fromOtpLogin = false}) async{
    _isLoading = true;
    update();
    Response? response = await authServiceInterface.otpLogin(phone: phone, otp: otp);
    if(response!.statusCode == 200){
      updateToken();
      Map map = response.body;
      String token = '';
      token = map['data']['token'];
      setUserToken(token);
      _isLoading = false;
      if(fromOtpLogin) {
        Get.find<BottomMenuController>().navigateToDashboard();
      }else{
        Get.to(() =>  ResetPasswordScreen(phoneNumber: phone));
      }

    }else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<void> forgetPassword(String phone) async {
    _isLoading = true;
    update();
    Response? response = await authServiceInterface.forgetPassword(phone);
    if (response!.statusCode  == 200) {
      _isLoading = false;
      customSnackBar('successfully_sent_otp'.tr, isError: false);
    }else{
      _isLoading = false;
      customSnackBar('invalid_number'.tr);
    }
    update();
  }

  Future<void> updateToken() async {
    await authServiceInterface.updateToken();
  }

  Future<void> resetPassword(String phone, String password) async {
    _isLoading = true;
    update();
    Response? response = await authServiceInterface.resetPassword(phone, password);
    if (response!.statusCode == 200) {

      customSnackBar('password_change_successfully'.tr, isError: false);
      Get.offAll(()=> const SignInScreen());
    }else{
      customSnackBar(response.body['message']);
    }
    _isLoading = false;
    update();
  }

  Future<void> changePassword(String password, String newPassword) async {
    _isLoading = true;
    update();
    Response? response = await authServiceInterface.changePassword(password, newPassword);
    if (response!.statusCode == 200) {
      Get.back();
      customSnackBar('password_change_successfully'.tr, isError: false);
    }else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }

    update();
  }

  void updateVerificationCode(String query) {
    _verificationCode = query;
    update();
  }

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  void setRememberMe() {
    _isActiveRememberMe = true;
  }

  bool isLoggedIn() {
    return authServiceInterface.isLoggedIn();
  }

  Future <bool> clearSharedData() async {
    return authServiceInterface.clearSharedData();
  }

  void saveUserNumberAndPassword(String code,String number, String password) {
    authServiceInterface.saveUserNumberAndPassword(code, number, password);
  }

  String getUserNumber() {
    return authServiceInterface.getUserNumber();
  }

  String getLoginCountryCode() {
    return authServiceInterface.getLoginCountryCode();
  }
  String getUserPassword() {
    return authServiceInterface.getUserPassword();
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authServiceInterface.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authServiceInterface.getUserToken();
  }

  Future <void> setUserToken(String token) async{
    authServiceInterface.saveUserToken(token);
  }

  Future<void> permanentlyDelete() async {
    _isLoading = true;
    update();
    Response? response = await authServiceInterface.permanentlyDelete();
    if(response!.statusCode == 200){
      Get.back();
      Get.offAll(const SignInScreen());
      showCustomSnackBar('successfully_delete_account'.tr, isError: false);
      clearSharedData();
    }else{
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }


  void saveFindingRideCreatedTime(){
    authServiceInterface.saveRideCreatedTime(DateTime.now());
  }

  void remainingFindingRideTime() async{
    String time = await authServiceInterface.remainingTime();
    if(time.isNotEmpty){
      DateTime oldTime = DateTime.parse(time);
      DateTime newTime = DateTime.now();
      int diff =  newTime.difference(oldTime).inSeconds;
      Get.find<RideController>().resumeCountingTimeState(diff);
    }
  }
}
