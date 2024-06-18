import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/message/controllers/message_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/route_widget.dart';
import 'package:ride_sharing_user_app/features/payment/screens/payment_screen.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/map/screens/map_screen.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:url_launcher/url_launcher.dart';

class ParcelItem extends StatelessWidget {
  final TripDetails rideRequest;
  final int index;
  const ParcelItem({super.key, required this.rideRequest, required this.index});

  @override
  Widget build(BuildContext context) {
    String firstRoute = '';
    String secondRoute = '';
    List<dynamic> extraRoute = [];
    if(rideRequest.intermediateAddresses != null && rideRequest.intermediateAddresses != '[[, ]]'){
      extraRoute = jsonDecode(rideRequest.intermediateAddresses!);

      if(extraRoute.isNotEmpty){
        firstRoute = extraRoute[0];
      }
      if(extraRoute.isNotEmpty && extraRoute.length>1){
        secondRoute = extraRoute[1];
      }

    }
    return GetBuilder<ParcelController>(
        builder: (parcelController){
      return GetBuilder<RideController>(
          builder: (rideController) {
            return InkWell(onTap: (){
              parcelController.setParcelLoadingActive(index);
            if(rideRequest.currentStatus == "accepted"){
              Get.find<RideController>().getRideDetails(rideRequest.id!).then((value){
                if(value.statusCode == 200){
                  parcelController.setParcelLoadingDeactive(index);
                  Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.acceptRider);
                  Get.find<RideController>().startLocationRecord();
                  Get.find<MapController>().notifyMapController();
                  Get.to(() => const MapScreen(fromScreen: MapScreenType.parcel));
                }
              });
            }else{
              if(rideRequest.paymentStatus == 'paid'){
                rideController.getFinalFare(rideRequest.id!).then((value) {
                  if(value.statusCode == 200){
                    rideController.getRideDetails(rideRequest.id!).then((value){
                      if(value.statusCode == 200){
                        Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.parcelOngoing);
                        Get.find<RideController>().startLocationRecord();
                        parcelController.setParcelLoadingDeactive(index);
                        Get.to(()=> const MapScreen(fromScreen: MapScreenType.parcel));
                      }
                    });
                  }
                });

              }else{
                if(rideRequest.parcelInformation!.payer == 'sender' && rideRequest.driver != null){
                  rideController.getFinalFare(rideRequest.id!).then((value) {
                    if(value.statusCode == 200){
                      rideController.getRideDetails(rideRequest.id!).then((value){
                        if(value.statusCode == 200){
                          Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.parcelOngoing);
                          Get.find<RideController>().startLocationRecord();
                          parcelController.setParcelLoadingDeactive(index);
                          Get.off(()=>const PaymentScreen(fromParcel: true));
                        }
                      });
                    }
                  });
                }else{
                  if(rideRequest.driver != null){
                    rideController.getRideDetails(rideRequest.id!).then((value){
                      if(value.statusCode == 200){
                        Get.find<MapController>().getPolyline();
                        Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.parcelOngoing);
                        parcelController.setParcelLoadingDeactive(index);
                        Get.offAll(() => const MapScreen(fromScreen: MapScreenType.parcel));
                      }
                    });
                  }else{
                    rideController.getRideDetails(rideRequest.id!);
                    Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.findingRider);
                    Get.find<RideController>().startLocationRecord();
                    Get.find<MapController>().notifyMapController();
                    parcelController.setParcelLoadingDeactive(index);
                    Get.offAll(() => const MapScreen(fromScreen: MapScreenType.parcel));
                  }
                }
              }
            }
            },
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
                child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(color: Theme.of(Get.context!).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                        border: Border.all(color: Theme.of(Get.context!).primaryColor,width: .35),
                        boxShadow:[BoxShadow(color: Theme.of(Get.context!).primaryColor.withOpacity(.1),
                            blurRadius: 1, spreadRadius: 1, offset: const Offset(0,0))]),
                    child:  GestureDetector(onTap: () => Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.otpSent),
                      child:  Column(children:  [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                          Text('view_details'.tr),
                          rideRequest.isLoading! ?  SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,):
                          Icon(Icons.arrow_forward_ios_rounded, color: Theme.of(context).hintColor, size: Dimensions.iconSizeMedium)],),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        RouteWidget(totalDistance: "0",
                            fromParcelOngoing: true,
                            fromAddress: rideRequest.pickupAddress!,
                            toAddress: rideRequest.destinationAddress!,
                            extraOneAddress: firstRoute,
                            extraTwoAddress: secondRoute,
                            entrance: rideRequest.entrance??''),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        if(rideRequest.driver != null)
                          Center(
                            child: Container(width: 250,
                               padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                               decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall), border: Border.all(width: .75, color: Theme.of(context).primaryColor)),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [


                                InkWell(onTap: () => Get.find<MessageController>().createChannel(rideRequest.driver?.id??"",  rideRequest.id),
                                    child: Padding(padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                                        child: SizedBox(width: Dimensions.iconSizeLarge, child: Image.asset(Images.customerMessage)))),

                                Container(width: 1,height: 25,color: Theme.of(context).primaryColor),
                                InkWell(onTap: () async  =>  await _launchUrl("tel:${rideRequest.driver!.phone}"),
                                    child: Padding(padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                                        child: SizedBox(width: Dimensions.iconSizeLarge, child: Image.asset(Images.customerCall)))),

                              ],),
                            ),
                          ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                      ]),
                    )),
              ),
            );
          }
      );
    });
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}
