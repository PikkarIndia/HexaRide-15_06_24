import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dar.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/route_widget.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/tolltip_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/estimated_fare_and_distance.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/rider_details.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ParcelOngoingBottomSheetWidget extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const ParcelOngoingBottomSheetWidget({super.key, required this.expandableKey});

  @override
  State<ParcelOngoingBottomSheetWidget> createState() => _ParcelOngoingBottomSheetWidgetState();
}

class _ParcelOngoingBottomSheetWidgetState extends State<ParcelOngoingBottomSheetWidget> {
   int currentState = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParcelController>(builder: (parcelController){
      return GetBuilder<RideController>(builder: (rideController){
        return currentState == 0 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          TollTipWidget(title: '${'drop_off'.tr} ${DateConverter.dateToTimeOnly(DateTime.now().add(Duration(seconds: rideController.remainingDistanceModel![0].durationSec!)))}'),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          const EstimatedFareAndDistance(isParcel: true),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          const ActivityScreenRiderDetails(),
          Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Text('trip_details'.tr,style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).primaryColor),),),

          if(rideController.tripDetails != null)
            RouteWidget(totalDistance: rideController.estimatedDistance,
                fromAddress: rideController.tripDetails?.pickupAddress??'',
                toAddress: rideController.tripDetails?.destinationAddress??'',
                extraOneAddress: '',
                extraTwoAddress: '',
                entrance:  rideController.tripDetails?.entrance??''),
          const SizedBox(height: Dimensions.paddingSizeDefault),

         /* Center(child: SliderButton(
              action: (){
                currentState = 1;
                widget.expandableKey.currentState?.expand();
                setState(() {});
              },
              label: Text('cancel_ride'.tr,style: TextStyle(color: Theme.of(context).cardColor),),
              dismissThresholds: 0.5, dismissible: false, shimmer: false,
              width: 1170, height: 40, buttonSize: 40, radius: 20,
              icon: Center(child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).cardColor),
                child: Center(
                  child: Icon(
                    Get.find<LocalizationController>().isLtr ? Icons.arrow_forward_ios_rounded : Icons.keyboard_arrow_left,
                    color: Colors.grey, size: 20.0,
                  ),
                ),
              )),
              isLtr: Get.find<LocalizationController>().isLtr,
              boxShadow: const BoxShadow(blurRadius: 0),
              buttonColor: Colors.transparent,
              backgroundColor: Theme.of(context).primaryColor,
              baseColor: Theme.of(context).primaryColor,
            ))*/

        ]) : const SizedBox();
        /*Column( children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
            child: Text('if_you_cancel_your_parcel_will_be_back_to_your'.tr,style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
          ),

          const SizedBox(height: Dimensions.paddingSizeSmall,),
          Text('\$50'.tr,style: textBold.copyWith(fontSize: 20),),

          const SizedBox(height: Dimensions.paddingSizeSmall,),
          Text('return_fee'.tr,style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),

          const SizedBox(height: Dimensions.paddingSizeLarge,),
          Row(children: [
            Expanded(child: ButtonWidget(buttonText: 'no_continue'.tr,
                showBorder: true,
                transparent: true,
                backgroundColor: Theme.of(context).primaryColor,
                borderColor: Theme.of(context).primaryColor,
                textColor: Theme.of(context).cardColor,
                radius: Dimensions.paddingSizeSmall,
                onPressed: (){
                  currentState = 0;
                  setState(() {});
                })),

            const SizedBox(width: Dimensions.paddingSizeSmall,),
            Expanded(child: ButtonWidget(buttonText: 'yes_cancel'.tr,
                showBorder: true,
                transparent: true,
                textColor: Get.isDarkMode ? Colors.white : Colors.black,
                borderColor: Theme.of(context).hintColor,
                radius: Dimensions.paddingSizeSmall,
                onPressed: (){
                  ///TODO
                })),
          ],)
        ],)*/
      });
    });
  }
}
