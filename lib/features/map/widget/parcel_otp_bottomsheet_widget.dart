
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/confirmation_dialog_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dar.dart';
import 'package:ride_sharing_user_app/common_widgets/swipable_button_widget/slider_button_widget.dart';
import 'package:ride_sharing_user_app/features/dashboard/controllers/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/otp_widget.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/route_widget.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/tolltip_widget.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/confirmation_trip_dialog.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/estimated_fare_and_distance.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/rider_details.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ParcelOtpBottomSheetWidget extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const ParcelOtpBottomSheetWidget({super.key, required this.expandableKey});

  @override
  State<ParcelOtpBottomSheetWidget> createState() => _ParcelOtpBottomSheetWidgetState();
}

class _ParcelOtpBottomSheetWidgetState extends State<ParcelOtpBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParcelController>(builder: (parcelController){
      return GetBuilder<RideController>(builder: (rideController){
        return  GestureDetector(
          onTap: () async {
            Get.dialog(const ConfirmationTripDialog(isStartedTrip: true), barrierDismissible: false);
            await Future.delayed( const Duration(seconds: 5));
            parcelController.updateParcelState(ParcelDeliveryState.parcelOngoing);
            Get.find<MapController>().notifyMapController();
            Get.back();
          },
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,children: [
            TollTipWidget(title: '${ (rideController.remainingDistanceModel != null && rideController.remainingDistanceModel!.isNotEmpty)
                ?  (rideController.remainingDistanceModel![0].duration)?? '0' : '0'} ${'away'.tr}'),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            const Center(child: OtpWidget(fromPage: true)),

            const ActivityScreenRiderDetails(),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Text('trip_details'.tr,style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).primaryColor),),),

            if(rideController.tripDetails != null)
              RouteWidget(totalDistance: rideController.estimatedDistance,
                  fromAddress: rideController.tripDetails?.pickupAddress??'',
                  toAddress: rideController.tripDetails?.destinationAddress??'',
                  extraOneAddress: "",
                  extraTwoAddress: "",
                  entrance:  rideController.tripDetails?.entrance??''),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            const EstimatedFareAndDistance(),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            const SizedBox(height: Dimensions.paddingSizeDefault),
            Center(
                child: SliderButton(
                  action: (){
                    Get.dialog(ConfirmationDialogWidget(
                      isLoading: parcelController.isLoading,
                      icon: Images.cancelIcon,
                      description: 'are_you_sure'.tr,
                      onYesPressed: () {
                        Get.find<RideController>().stopLocationRecord();
                        rideController.tripStatusUpdate(rideController.tripDetails!.id!, 'cancelled', 'parcel_request_cancelled_successfully','');
                        Get.find<MapController>().notifyMapController();
                        Get.find<BottomMenuController>().navigateToDashboard();
                      },
                    ), barrierDismissible: false);
                  },
                  label: Text('cancel_ride'.tr,style: TextStyle(color: Theme.of(context).primaryColor),),
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
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.15),
                  baseColor: Theme.of(context).primaryColor,
                )),


          ]),
        );
      });
    });
  }
}
