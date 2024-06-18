
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/coupon/controllers/coupon_controller.dart';
import 'package:ride_sharing_user_app/features/coupon/domain/models/coupon_model.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class OfferCouponCardWidget extends StatelessWidget {
  final bool fromCouponScree;
  final Coupon coupon;
  final int index;
  const OfferCouponCardWidget({
    super.key, required this.fromCouponScree,
    required this.coupon,required this.index
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CouponController>(builder: (couponController){
      return Stack(children: [
        Container(
          width: Get.width,
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeExtraSmall,
            horizontal: Dimensions.paddingSizeLarge,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.25)),
            color: Theme.of(context).hintColor.withOpacity(0.08),
          ),
          child:Row(children: [
            fromCouponScree ?
            Stack(children: [
              Container(width: 65,height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.50),
                ),
                child: Image.asset(Images.car),
              ),

              Image.asset(Images.discountCouponIcon, height: 20, width: 20)
            ]) :
            const SizedBox(),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('Code: ',style: textRegular.copyWith(color: Theme.of(context).hintColor)),

                Text('${coupon.couponCode}',style: textBold),
              ]),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text(
                coupon.description ?? '',
                style: textRegular.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),
                  fontSize: Dimensions.fontSizeSmall ,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSeven),

              Text(
                '${'minimum_trip_amount'.tr} ${PriceConverter.convertPrice(double.parse(coupon.minTripAmount ?? '0'))}',
                style: textRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).hintColor
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSeven),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  Text(
                    '${'valid'.tr}: ',
                    style: textRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5),
                      fontSize: Dimensions.fontSizeExtraSmall,
                    ),
                  ),

                  Text(
                    DateConverter.isoDateTimeStringToDateOnly(coupon.endDate!),
                    style: textRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5),
                      fontSize: Dimensions.fontSizeExtraSmall,
                    ),
                  ),
                ]),

                InkWell(
                  onTap: () {
                    Get.find<CouponController>().customerAppliedCoupon(coupon.id!, index);
                  },
                  child: couponController.couponModel!.data![index].isLoading ?
                  SpinKitCircle(color: Theme.of(context).primaryColor.withOpacity(0.50), size: 30.0) :
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeExtraSmall,
                      horizontal: Dimensions.paddingSizeSmall,
                    ),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                      color: couponController.couponModel!.data![index].isApplied! ?
                      Theme.of(context).primaryColor.withOpacity(0.15) :
                      Theme.of(context).primaryColor,
                    ),
                    child: Text(
                      couponController.couponModel!.data![index].isApplied! ?
                      'applied'.tr : 'apply'.tr,
                      style: textRegular.copyWith(
                        color: couponController.couponModel!.data![index].isApplied! ?
                        Theme.of(context).primaryColor : Theme.of(context).cardColor,
                      ),
                    ),
                  ) ,
                ),
              ]),
            ])),
          ],
          ),
        ),

        Positioned(top: 40,left: -18,
          child: Container(width: 30, height : 35,
            decoration: BoxDecoration(color: Theme.of(context).cardColor,
              border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.25)),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        Positioned(top: 40,right: -18,
          child: Container(width: 30, height : 35,
            decoration: BoxDecoration(color: Theme.of(context).cardColor,
              border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.25)),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      ]);
    });
  }
}
