import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/ride/domain/models/trip_details_model.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';

class RiderInfo extends StatelessWidget {
  final TripDetails tripDetails;
  const RiderInfo({super.key, required this.tripDetails});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Text('rider_details'.tr,style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).primaryColor),),
      ),

      Row(children: [
        Expanded(
          child: Row(children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusOverLarge),
                child: ImageWidget(height: 50, width: 50,
                  image: tripDetails.driver != null ? '${Get.find<ConfigController>().config!.imageBaseUrl!.profileImageDriver}'
                      '/${tripDetails.driver!.profileImage}' : '',
                )),
            const SizedBox(width: Dimensions.paddingSizeSmall,),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  tripDetails.driver != null ? Text('${tripDetails.driver!.firstName!} ${tripDetails.driver!.lastName!}',
                    style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).primaryColorDark),
                    overflow: TextOverflow.ellipsis,
                  ) : const SizedBox(),
                  Text.rich(TextSpan(
                    style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),
                    ),
                    children:  [
                      WidgetSpan(child: Icon(Icons.star,color: Theme.of(context).colorScheme.primaryContainer,size: 15,),
                          alignment: PlaceholderAlignment.middle),
                      TextSpan(text: double.parse(tripDetails.driverAvgRating != null ?tripDetails.driverAvgRating.toString(): '0').toStringAsFixed(1),
                          style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                    ],
                  )),
                ],
              ),
            )
          ],
          ),
        ),

        tripDetails.vehicle != null ? Expanded(child: Row(children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusOverLarge),
            child: ImageWidget(
              height: 50, width: 50,
              image:tripDetails.vehicle != null?
              '${Get.find<ConfigController>().config!.imageBaseUrl!.vehicleModel!}/${tripDetails.vehicle!.model!.image!}' : '',
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(
              tripDetails.vehicle != null ? tripDetails.vehicle!.model!.name! : '',
              style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).primaryColorDark),
              overflow: TextOverflow.ellipsis,
            ),
            Text.rich(TextSpan(
              style: textRegular.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),
              ),
              children:  [
                TextSpan(
                  text: tripDetails.vehicle!.licencePlateNumber,
                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                ),
              ],
            ), overflow: TextOverflow.ellipsis),
          ])),

        ])) : const SizedBox(),

      ]),
    ]);
  }
}
