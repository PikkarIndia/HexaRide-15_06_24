import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dar.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';

enum RiseFare{ride, parcel}

class RiseFareWidget extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  final RiseFare fromPage;
  const RiseFareWidget({super.key, required this.fromPage, required this.expandableKey});

  @override
  State<RiseFareWidget> createState() => _RiseFareWidgetState();
}



class _RiseFareWidgetState extends State<RiseFareWidget> {
  TextEditingController riseFareController = TextEditingController();

  @override
  void initState() {
    if(widget.fromPage == RiseFare.ride){
      riseFareController.text = Get.find<RideController>().estimatedFare.toStringAsFixed(2);
    }else{
      riseFareController.text = Get.find<RideController>().parcelEstimatedFare!.data!.estimatedFare!.toStringAsFixed(2);
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (riderController){
      return GetBuilder<RideController>(
        builder: (rideController) {
          bool inRight = Get.find<ConfigController>().config!.currencySymbolPosition == 'right';
          String symbol = Get.find<ConfigController>().config!.currencySymbol?? '\$';
          return GetBuilder<ParcelController>(
            builder: (parcelController) {
              return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                    child: Text('current_fare'.tr,style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).primaryColor.withOpacity(0.6)),),),

                  Container(decoration: BoxDecoration(border: Border.all(color: Theme.of(context).hintColor, width: .75),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      if(!inRight)
                        Text(symbol, style: textBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor)),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      IntrinsicWidth(
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            onTap: () => parcelController.focusOnBottomSheet(widget.expandableKey),
                            controller: riseFareController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'enter_amount'.tr,
                              hintStyle: textRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(.5)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:  BorderSide(width: 0.5, color: Theme.of(context).hintColor.withOpacity(0.0))),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:  BorderSide(width: 0.5,
                                    color: Theme.of(context).hintColor.withOpacity(0.0))),
                            ),

                          ),
                        ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      if(inRight)
                        Text(symbol, style: textBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor)),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  rideController.isSubmit ?  Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)) : ButtonWidget(
                    buttonText: 'rise_fare'.tr,onPressed: () {
                      if(widget.fromPage == RiseFare.ride) {
                        if(riseFareController.text.trim().isEmpty){
                          showCustomSnackBar('fare_amount_is_required'.tr);
                        }else{
                          rideController.setBidingAmount(riseFareController.text).then((value) {
                            rideController.submitRideRequest(rideController.noteController.text, false).then((value) {
                              if(value.statusCode == 200){
                                rideController.updateRideCurrentState(RideState.findingRider);
                                Get.find<MapController>().notifyMapController();
                              }
                            });
                          });

                        }

                      }else {
                        rideController.setBidingAmount(riseFareController.text).then((value) {
                          Get.find<ParcelController>().getSuggestedCategoryList().then((value) {
                            if(value.statusCode == 200){
                              Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.suggestVehicle);
                            }
                          });
                        });

                      }
                      Get.find<MapController>().notifyMapController();
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  ButtonWidget(
                    buttonText: 'cancel'.tr,
                    transparent: true,
                    borderWidth: 1,
                    showBorder: true,
                    radius: Dimensions.paddingSizeSmall,
                    borderColor: Theme.of(Get.context!).primaryColor,
                    onPressed: () {
                      if(widget.fromPage == RiseFare.ride) {
                        Get.find<RideController>().updateRideCurrentState(RideState.initial);
                      }else{
                        Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.parcelInfoDetails);
                      }
                      Get.find<MapController>().notifyMapController();
                    },
                  )
                ],
              );
            }
          );
        }
      );
    });
  }
}
