import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/models/loyalty_point_model.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/models/transaction_model.dart';
import 'package:ride_sharing_user_app/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';


class WalletController extends GetxController implements GetxService{
  final WalletRepository walletRepo;

  WalletController({required this.walletRepo});

  TextEditingController inputController = TextEditingController();
  FocusNode inputNode = FocusNode();

  bool isLoading = false;

  List<String> walletType = ['wallet_money','loyalty_point'];

  TransactionModel? transactionModel;
  Future<Response> getTransactionList(int offset) async {
    isLoading = true;
    update();
    Response? response = await walletRepo.getTransactionList(offset);
    if (response!.statusCode == 200) {
      isLoading = false;
      if(offset == 1){
        transactionModel = TransactionModel.fromJson(response.body);
      }else{
        transactionModel!.data!.addAll(TransactionModel.fromJson(response.body).data!);
        transactionModel!.offset = TransactionModel.fromJson(response.body).offset;
        transactionModel!.totalSize = TransactionModel.fromJson(response.body).totalSize;
      }

    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }


  LoyaltyPointModel? loyaltyPointModel;
  Future<Response> getLoyaltyPointList(int offset) async {
    isLoading = true;
    update();
    Response? response = await walletRepo.getLoyaltyPointList(offset);
    if (response!.statusCode == 200) {
      isLoading = false;
      if(offset == 1){
        loyaltyPointModel = LoyaltyPointModel.fromJson(response.body);
      }else{
        loyaltyPointModel!.data!.addAll(LoyaltyPointModel.fromJson(response.body).data!);
        loyaltyPointModel!.offset = LoyaltyPointModel.fromJson(response.body).offset;
        loyaltyPointModel!.totalSize = LoyaltyPointModel.fromJson(response.body).totalSize;
      }
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }



  Future<Response> convertPoint(String point) async {
    isLoading = true;
    update();
    Response? response = await walletRepo.convertPoint(point);
    if (response!.statusCode == 200) {
     Get.find<ProfileController>().getProfileInfo();
     getTransactionList(1);
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  int currentTabIndex = 0;

  void updateCurrentTabIndex(int index){
    currentTabIndex = index;
    update();
  }

}