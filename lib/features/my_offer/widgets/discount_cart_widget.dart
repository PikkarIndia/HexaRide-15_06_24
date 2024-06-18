import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/my_offer/domain/models/best_offer_model.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class DiscountCartWidget extends StatelessWidget {
  final OfferModel offerModel;
  const DiscountCartWidget({super.key, required this.offerModel});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2,width: Get.width,
            child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusOverLarge),
                child: Image.network(offerModel.image!,fit: BoxFit.fill,))),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [SizedBox(width: Get.width *0.8,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
            Text(offerModel.title ?? '',style: textBold, overflow: TextOverflow.ellipsis,),

            const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
            Text(offerModel.shortDescription ?? '',style: textRegular.copyWith(color: Theme.of(context).hintColor),overflow: TextOverflow.ellipsis,),

            const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
            Text('${'valid'.tr}: ${DateConverter.stringToLocalDateOnly(offerModel.endDate!)}',style: textRegular.copyWith(color: Theme.of(context).hintColor),overflow: TextOverflow.ellipsis)]),
        ),

          Icon(Icons.arrow_forward_ios_outlined,color: Theme.of(context).primaryColor,)
        ],)
      ],),
    );
  }
}
