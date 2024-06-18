import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_text_field.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dar.dart';
import 'package:ride_sharing_user_app/features/auth/controllers/auth_controller.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/fare_input_widget.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/route_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/ride_category.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/trip_fare_summery.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class InitialWidget extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const InitialWidget({super.key, required this.expandableKey});

  @override
  State<InitialWidget> createState() => _InitialWidgetState();
}

class _InitialWidgetState extends State<InitialWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController){
      return GetBuilder<LocationController>(builder: (locationController){
        return Column(mainAxisSize: MainAxisSize.min, children:  [

          const RideCategoryWidget(),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          RouteWidget(
            totalDistance: rideController.fareList[rideController.rideCategoryIndex].estimatedDistance ?? '0',
            fromAddress: locationController.fromAddress?.address??'',
            extraOneAddress: locationController.extraRouteAddress?.address ?? '',
            extraTwoAddress: locationController.extraRouteTwoAddress?.address ?? '',
            toAddress: locationController.toAddress?.address??'',
            entrance: locationController.entranceController.text,
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          TripFareSummery(tripFare: rideController.estimatedFare, fromParcel: false,discountFare: rideController.discountFare,
          discountAmount: rideController.discountAmount,),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          if(rideController.isCouponApplicable)...[
            Align(alignment: Alignment.centerRight,
              child: Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.15), borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                child: Text('coupon_applied'.tr,style: textBold.copyWith(color: Theme.of(context).primaryColor))
              ),
            ),

            const SizedBox(height: Dimensions.paddingSizeDefault),
          ],

          CustomTextField(
            prefix: false,
            borderRadius: Dimensions.radiusSmall,
            hintText: "add_note".tr,
            controller: rideController.noteController,
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          rideController.isLoading || rideController.isSubmit ?
          Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)) :
          (Get.find<ConfigController>().config!.bidOnFare! ) ?
          FareInputWidget(expandableKey: widget.expandableKey,
            fromRide: true, fare: rideController.discountAmount.toDouble() > 0 ? rideController.discountFare.toString() : rideController.estimatedFare.toString(),
          ) :
          ButtonWidget(buttonText: "find_rider".tr, onPressed: () {
            rideController.submitRideRequest(rideController.noteController.text, false).then((value) {
              if(value.statusCode == 200) {
                Get.find<AuthController>().saveFindingRideCreatedTime();
                rideController.updateRideCurrentState(RideState.findingRider);
                Get.find<MapController>().initializeData();
                Get.find<MapController>().setOwnCurrentLocation();
                Get.find<MapController>().notifyMapController();
              }
            });
          }),
        ]);
      });
    });
  }
}
