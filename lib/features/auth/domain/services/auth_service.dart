import 'package:ride_sharing_user_app/features/auth/domain/models/sign_up_body.dart';
import 'package:ride_sharing_user_app/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:ride_sharing_user_app/features/auth/domain/services/auth_service_interface.dart';

class AuthService implements AuthServiceInterface{
  AuthRepositoryInterface authRepositoryInterface;
  AuthService({required this.authRepositoryInterface});

  @override
  Future changePassword(String oldPassword, String password) async{
    return await authRepositoryInterface.changePassword(oldPassword, password);
  }

  @override
  Future checkEmail(String email) async{
   return await authRepositoryInterface.checkEmail(email);
  }

  @override
  bool clearSharedAddress() {
    return authRepositoryInterface.clearSharedAddress();
  }

  @override
  bool clearSharedData() {
    return authRepositoryInterface.clearSharedData();
  }

  @override
  Future<bool> clearUserNumberAndPassword() {
   return authRepositoryInterface.clearUserNumberAndPassword();
  }

  @override
  Future forgetPassword(String? phone) async{
    return await authRepositoryInterface.forgetPassword(phone);
  }

  @override
  String getUserNumber() {
    return authRepositoryInterface.getUserNumber();
  }

  @override
  String getUserPassword() {
    return authRepositoryInterface.getUserPassword();
  }

  @override
  String getUserToken() {
    return authRepositoryInterface.getUserToken();
  }

  @override
  String getLoginCountryCode() {
    return authRepositoryInterface.getLoginCountryCode();
  }

  @override
  bool isLoggedIn() {
    return authRepositoryInterface.isLoggedIn();
  }

  @override
  Future logOut() async{
    return await authRepositoryInterface.logOut();
  }

  @override
  Future login({required String phone, required String password}) async{
    return await authRepositoryInterface.login(phone: phone, password: password);
  }

  @override
  Future otpLogin({required String phone, required String otp}) async{
    return await authRepositoryInterface.otpLogin(phone: phone, otp: otp);
  }

  @override
  Future registration({required SignUpBody signUpBody}) async{
    return await authRepositoryInterface.registration(signUpBody: signUpBody);
  }

  @override
  Future resetPassword(String phoneOrEmail, String password) async{
    return await authRepositoryInterface.resetPassword(phoneOrEmail, password);
  }

  @override
  Future<void> saveUserNumberAndPassword(String code, String number, String password) {
    return authRepositoryInterface.saveUserNumberAndPassword(code, number, password);
  }

  @override
  Future<bool?> saveUserToken(String token) {
    return authRepositoryInterface.saveUserToken(token);
  }

  @override
  Future sendOtp({required String phone}) async{
    return await authRepositoryInterface.sendOtp(phone: phone);
  }

  @override
  Future updateToken() async{
    return await authRepositoryInterface.updateToken();
  }

  @override
  Future verifyEmail(String email, String token) async{
    return await authRepositoryInterface.verifyEmail(email, token);
  }

  @override
  Future verifyOtp({required String phone, required String otp}) async{
    return await authRepositoryInterface.verifyOtp(phone: phone, otp: otp);
  }

  @override
  Future verifyPhone(String phone, String otp) async{
    return await authRepositoryInterface.verifyPhone(phone, otp);
  }

  @override
  Future verifyToken(String phone, String otp) async{
    return await authRepositoryInterface.verifyToken(phone, otp);
  }

  @override
  Future permanentlyDelete() async {
    return await authRepositoryInterface.permanentlyDelete();
  }

  @override
  Future saveRideCreatedTime(DateTime dateTime) async {
    authRepositoryInterface.saveRideCreatedTime(dateTime);
  }

  @override
  Future remainingTime() {
    return  authRepositoryInterface.remainingTime();
  }

}