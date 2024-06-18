import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/payment/widget/payment_item_info_widget.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/coupon/controllers/coupon_controller.dart';
import 'package:ride_sharing_user_app/features/payment/controllers/payment_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';

class TripFareSummery extends StatelessWidget {
  final bool fromPayment;
  final bool fromParcel;
  final double? tripFare;
  final double? discountFare;
  final double? discountAmount;
  const TripFareSummery({super.key, this.fromPayment = false,  this.tripFare, required this.fromParcel,this.discountFare,this.discountAmount});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController) {
      return GetBuilder<CouponController>(
        builder: (couponController) {
          return GetBuilder<PaymentController>(
            builder: (tipsController) {
              double total = 0;
              if(fromPayment) {
                 total = rideController.finalFare!.paidFare!+double.parse(tipsController.tipAmount);
              }else{
                total = rideController.tripDetails?.paidFare??0;
              }
              return Container(decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                  color: fromPayment? null : Theme.of(context).primaryColor.withOpacity(0.15)),
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(children: [
                  if(!fromPayment)
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(children: [
                      Image.asset(Images.profileMyWallet,height: 15,width: 15,),
                      const SizedBox(width: Dimensions.paddingSizeSmall,),
                      Text('fare_price'.tr,style: textRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault)),
                    ]),

                    Row(children: [
                      if(discountAmount != null && discountAmount!.toDouble() > 0)
                      Text(PriceConverter.convertPrice(tripFare!),
                          style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).hintColor,
                              decoration: TextDecoration.lineThrough,decorationColor: Theme.of(context).hintColor)),

                      Text(' ${PriceConverter.convertPrice(discountAmount != null && discountAmount !.toDouble() > 0 ? discountFare! : tripFare!)}',
                          style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).primaryColor)),
                      ])
                  ]),


                  if(fromPayment)...[
                    rideController.finalFare!.discountAmount!.toDouble() > 0 ?
                    Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall), child: Row(children: [
                      SizedBox(width:Dimensions.iconSizeSmall, child: Image.asset(Images.farePrice, color: Theme.of(context).primaryColor)),

                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(child: Row(children: [
                        Text('fare_price'.tr, style: textMedium.copyWith(color: Theme.of(context).primaryColor)),

                        Container(
                            decoration: BoxDecoration(color: Theme.of(context).colorScheme.error.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                            margin: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                            child: Text(
                              rideController.finalFare!.discount!.discountAmountType == 'percentage' ?
                              '${rideController.finalFare!.discount!.discountAmount}% ${'off'.tr}' :
                              '${PriceConverter.convertPrice(rideController.finalFare!.discount!.discountAmount!.toDouble())} ${'off'.tr}',
                              style: textRegular.copyWith(color: Theme.of(context).colorScheme.error),
                            )
                        )
                      ])),

                      Text(PriceConverter.convertPrice(rideController.finalFare?.distanceWiseFare ?? 0),
                          style: textRegular.copyWith(color: Theme.of(context).hintColor,
                              decorationColor: Theme.of(context).hintColor,decoration: TextDecoration.lineThrough)),
                      Text(' ${PriceConverter.convertPrice(rideController.finalFare!.distanceWiseFare! - rideController.finalFare!.discountAmount!)}',
                          style: textRegular.copyWith(color: Theme.of(context).primaryColor)),

                    ])) :

                    PaymentItemInfoWidget(icon: Images.farePrice,title: 'fare_price'.tr,amount: rideController.finalFare?.distanceWiseFare??0),
                  ],

                  if(fromPayment && !fromParcel && rideController.finalFare!.cancellationFee!.toDouble() > 0)
                    PaymentItemInfoWidget(icon: Images.idleHourIcon,title: 'cancellation_price'.tr,amount: rideController.finalFare?.cancellationFee??0),

                  if(fromPayment && !fromParcel && rideController.finalFare!.idleFee!.toDouble() > 0)
                    PaymentItemInfoWidget(icon: Images.idleHourIcon,title: 'idle_price'.tr,amount: rideController.finalFare?.idleFee??0),

                  if(fromPayment && !fromParcel && rideController.finalFare!.delayFee!.toDouble() > 0)
                    PaymentItemInfoWidget(icon: Images.waitingPrice,title: 'delay_price'.tr,amount: rideController.finalFare?.delayFee??0),

                  if(fromPayment && rideController.finalFare!.couponAmount!.toDouble() > 0)
                  PaymentItemInfoWidget(icon: Images.profileMyWallet,title: 'coupon_discount'.tr,amount: rideController.finalFare?.couponAmount??0, discount: true,),

                 if(fromPayment && rideController.finalFare!.vatTax!.toDouble() > 0)
                  PaymentItemInfoWidget(icon: Images.farePrice,title: 'vat_tax'.tr,amount: rideController.finalFare?.vatTax??0),

                  if(fromPayment  && double.parse(tipsController.tipAmount) > 0)
                    PaymentItemInfoWidget(icon: Images.farePrice,title: 'tips'.tr,amount: double.parse(tipsController.tipAmount)
                    ,toolTipText: 'tips_tooltip',),

                  if(fromPayment)
                  PaymentItemInfoWidget(title: 'sub_total'.tr, amount: total, isSubTotal: true,),

                  if(!fromPayment)
                    const SizedBox(height: Dimensions.paddingSizeSmall),


                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  if(!fromPayment)
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Expanded(
                      child: Row(children: [
                        Image.asset(Images.profileMyWallet,height: 15,width: 15,),
                        const SizedBox(width: Dimensions.paddingSizeSmall,),
                        Text('payment'.tr,style: textRegular.copyWith(color: Theme.of(context).primaryColor,fontSize: Dimensions.fontSizeDefault),),
                      ]),
                    ),
                    GetBuilder<PaymentController>(
                      builder: (paymentController) {
                        return SizedBox(width: 120, child: Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                          child: DropdownButton<String>(
                            value: paymentController.paymentTypeIndex == 0 ? 'cash' :paymentController.paymentTypeIndex == 1 ? 'digital':'wallet',
                            items: paymentController.paymentTypeList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),textAlign: TextAlign.right,),
                              );
                            }).toList(),
                            onChanged: (value) {
                              paymentController.setPaymentType(value == 'cash' ? 0 :value == 'digital' ? 1:2);
                            },
                            isExpanded: true,
                            underline: const SizedBox(),
                          ),
                        ));
                      }
                    )],
                  ),
                ]),
              );
            }
          );
        }
      );
    });
  }
}
