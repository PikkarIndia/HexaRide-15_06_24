import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/divider_widget.dart';
import 'package:ride_sharing_user_app/features/map/screens/map_screen.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/payment/screens/payment_screen.dart';
import 'package:ride_sharing_user_app/features/payment/screens/review_screen.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/features/trip/screens/trip_details_screen.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';

class TripItemView extends StatelessWidget {
  final TripDetails tripDetails;
  final bool isDetailsScreen;
  const TripItemView({super.key, required this.tripDetails, this.isDetailsScreen = false});

  @override
  Widget build(BuildContext context) {

    return InkWell(onTap: (){
      if(tripDetails.currentStatus == 'accepted' || tripDetails.currentStatus == 'ongoing'|| tripDetails.currentStatus == 'pending'){
        if(tripDetails.type == 'parcel'){
          Get.find<RideController>().getRideDetails(tripDetails.id!).then((value) {
          if(tripDetails.currentStatus == 'accepted'){
              Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.acceptRider);
              Get.to(()=> const MapScreen(fromScreen: MapScreenType.parcel));
        }else if (tripDetails.currentStatus == 'ongoing'){
            Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.parcelOngoing);
            if(value.body['data']['parcel_information']['payer'] == 'sender' && value.body['data']['payment_status'] == 'unpaid'){
              Get.off(()=>const PaymentScreen(fromParcel: true));
            }else{
              Get.to(()=> const MapScreen(fromScreen: MapScreenType.parcel));
            }
        }else{
          Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.findingRider);
          Get.to(()=> const MapScreen(fromScreen: MapScreenType.parcel));
        }
          });

        }else{
          Get.find<RideController>().getRideDetails(tripDetails.id!);
          if(tripDetails.currentStatus == 'accepted'){
            Get.find<RideController>().updateRideCurrentState(RideState.acceptingRider);
          }else if (tripDetails.currentStatus == 'ongoing'){
            Get.find<RideController>().updateRideCurrentState(RideState.ongoingRide);
          }else{
            Get.find<RideController>().updateRideCurrentState(RideState.findingRider);
          }
          Get.to(()=> const MapScreen(fromScreen: MapScreenType.ride));
        }
      }else{
        Get.to(()=> TripDetailsScreen(tripId: tripDetails.id!));
      }
    },
      child: Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [

          Container(width: 80, height: 100,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              color:tripDetails.vehicle != null ? Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.02) : Theme.of(context).cardColor,),
            child: Center(child: Column(children: [
              ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                child: tripDetails.type != 'parcel' ?
                ImageWidget(width: 80, height: 60,
                  image : tripDetails.vehicle != null ? '${Get.find<ConfigController>().config!.imageBaseUrl!.vehicleModel!}/${tripDetails.vehicle!.model!.image!}' :
                  '${Get.find<ConfigController>().config!.imageBaseUrl!.vehicleCategory!}/${tripDetails.vehicleCategory?.image!}',
                  fit: BoxFit.cover) : Image.asset(Images.parcel,height: 60,width: 80)
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text(tripDetails.type != 'parcel' ? tripDetails.vehicleCategory != null ? tripDetails.vehicleCategory!.name! : '' : 'parcel'.tr,
                style: textMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall,color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.4)),
              ),
            ])),
          ),
          const SizedBox(width: Dimensions.paddingSizeExtraLarge),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
                  child: Column(children:  [
                    SizedBox(width: Dimensions.iconSizeMedium,child: Image.asset(Images.currentLocation)),
                    SizedBox(height: 15 ,width: 10,child: CustomDivider(height: 1,dashWidth: 1,axis: Axis.vertical,color: Theme.of(context).primaryColor,)),
                    SizedBox(width: Dimensions.iconSizeMedium,child: Image.asset(Images.customerDestinationIcon)),
                  ])),


                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(tripDetails.pickupAddress ?? '', style: textRegular.copyWith(),overflow: TextOverflow.ellipsis,),

                    const SizedBox(height: Dimensions.paddingSizeSmall),
                  Text(tripDetails.destinationAddress ?? '',  style: textRegular.copyWith(),overflow: TextOverflow.ellipsis,),

                ]))]),

            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Text(DateConverter.localToIsoString(DateTime.parse(tripDetails.createdAt!)),
              style: textRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.4),),),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

             !isDetailsScreen ? SizedBox(width: Get.width*0.6,
               child: Row( children: [
                 tripDetails.estimatedFare!=null ? Text(PriceConverter.convertPrice(tripDetails.paidFare!),
                   style: textMedium.copyWith(
                       fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8)),
                   maxLines: 1,
                   overflow: TextOverflow.ellipsis,
                 ) : const SizedBox(),

                 const Spacer(),

                 Container(decoration: BoxDecoration(
                   color: tripDetails.currentStatus == 'ongoing' ? Colors.blue.withOpacity(0.10) : tripDetails.currentStatus == 'cancelled' ? Colors.red.withOpacity(0.10) :
                          tripDetails.currentStatus == 'completed' ? Colors.green.withOpacity(0.10) : null,
                   borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                   padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeThree ),
                   child: Text(tripDetails.currentStatus!.tr,
                     style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: tripDetails.currentStatus == 'ongoing' ? Colors.blue :
                     tripDetails.currentStatus == 'cancelled' ? Colors.red : tripDetails.currentStatus == 'completed' ? Colors.green : Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8)),
                     maxLines: 1,
                     overflow: TextOverflow.ellipsis),
                 )])) :

             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
               tripDetails.estimatedFare!=null ? Text(PriceConverter.convertPrice(tripDetails.paidFare!),
                 style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8)),
                 maxLines: 1,
                 overflow: TextOverflow.ellipsis,
               ) : const SizedBox(),

               Text(tripDetails.currentStatus!.tr,
                 style: textMedium.copyWith(
                   fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),),
                 maxLines: 1,
                 overflow: TextOverflow.ellipsis)],),

             isDetailsScreen ? (Get.find<ConfigController>().config!.reviewStatus! &&!tripDetails.isReviewed! && tripDetails.driver != null && tripDetails.paymentStatus == 'paid')? InkWell( onTap: (){
               Get.to(() => ReviewScreen(tripId: tripDetails.id!,));
               },
               child: Container(
                   padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall,horizontal: Dimensions.paddingSizeDefault),
                   decoration: BoxDecoration(
                       color: Colors.orange,
                       borderRadius: BorderRadius.circular(5)),

                   child: Row(mainAxisSize: MainAxisSize.min, children: [
                     Image.asset(Images.reviewIcon,height: 16,width: 16,),

                     const SizedBox(width: 8,),
                     Text('give_review'.tr,style: textRegular.copyWith(color: Theme.of(context).cardColor),)
                   ])),
             ): const SizedBox() : const SizedBox()

           ],)
          ])),
        ]),
      ),
    );
  }
}
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
