import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/loader_widget.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/rider_info.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/trip_details.dart';
import 'package:ride_sharing_user_app/features/trip/widgets/trip_item_view.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/trip/controllers/trip_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';

class TripDetailsScreen extends StatefulWidget {
  final String tripId;
  final bool fromNotification;
  const TripDetailsScreen({super.key, required this.tripId,this.fromNotification = false});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {

  @override
  void initState() {
    if(!widget.fromNotification){
      Get.find<RideController>().getRideDetails(widget.tripId);
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RideController>(builder: (rideController){
        return BodyWidget(
          appBar: AppBarWidget(title: 'trip_details'.tr,subTitle: rideController.tripDetails?.refId, showBackButton: true, centerTitle: true),
          body: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: GetBuilder<TripController>(builder: (activityController) {

              return rideController.tripDetails != null?
              SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  TripItemView(tripDetails: rideController.tripDetails!,isDetailsScreen: true,),
                  const SizedBox(height: Dimensions.paddingSizeSmall,),


                  TripDetailWidget(tripDetails: rideController.tripDetails!),

                  if(rideController.tripDetails?.driver != null)
                    RiderInfo(tripDetails: rideController.tripDetails!),
                  const SizedBox(height: Dimensions.paddingSizeDefault,),

                ]),
              ): const LoaderWidget();

            }),
          ),
        );
      },),
     /* bottomNavigationBar: GetBuilder<RideController>(builder: (rideController){
        return (rideController.tripDetails != null && rideController.tripDetails!.type == 'parcel' *//*&& rideController.tripDetails!.currentStatus == 'ongoing'*//*) ?
        Container(color: Theme.of(context).cardColor,
          child: Container(height: 110,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.paddingSizeExtraLarge), topRight: Radius.circular(Dimensions.paddingSizeExtraLarge)),
              border: Border(top: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.5)))
            ),
            child: Column(children: [
              Text('9  5  9  9',style: textBold.copyWith(fontSize: 20),),

              Text.rich(TextSpan(style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8)), children:  [

                TextSpan(text: 'please_share_the'.tr,
                    style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),
                        fontSize: Dimensions.fontSizeDefault)),

                TextSpan(text: ' OTP '.tr,
                    style: textSemiBold.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeDefault)),

                TextSpan(text: 'with_the_driver'.tr, style: textRegular.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),
                    fontSize: Dimensions.fontSizeDefault)),]), textAlign: TextAlign.center),

              const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: Center(child: SliderButton(
                    action: (){
                      ///TODO
                    },
                    label: Text('parcel_received'.tr,style: TextStyle(color: Theme.of(context).cardColor),),
                    dismissThresholds: 0.5, dismissible: false, shimmer: false,
                    width: 1170, height: 40, buttonSize: 40, radius: 20,
                    icon: Center(child: Container(width: 36, height: 36,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).cardColor),
                        child: Center(child: Icon(
                            Get.find<LocalizationController>().isLtr ? Icons.arrow_forward_ios_rounded : Icons.keyboard_arrow_left,
                            color: Colors.grey, size: 20.0)))),

                    isLtr: Get.find<LocalizationController>().isLtr,
                    boxShadow: const BoxShadow(blurRadius: 0),
                    buttonColor: Colors.transparent,
                    backgroundColor: Theme.of(context).primaryColor,
                    baseColor: Theme.of(context).primaryColor)),
              )
            ],),
          ),
        ) : const SizedBox();
      },),*/
    );
  }
}