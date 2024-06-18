import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/my_offer/controller/offer_controller.dart';
import 'package:ride_sharing_user_app/features/my_offer/screens/discount_screen.dart';
import 'package:ride_sharing_user_app/features/my_offer/screens/my_offer_screen.dart';
import 'package:ride_sharing_user_app/features/my_offer/widgets/best_offer_shimmer_widget.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class BestOfferWidget extends StatelessWidget {
  const BestOfferWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OfferController>(builder: (offerController){
      return offerController.bestOfferModel != null ?
      (offerController.bestOfferModel!.data != null && offerController.bestOfferModel!.data!.isNotEmpty) ?
      Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSize,bottom: Dimensions.paddingSizeSmall,top: Dimensions.paddingSizeExtraSmall),

        child: Column(children: [
          Padding( padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('best_offer'.tr,style: textBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),),

                InkWell(onTap: () => Get.to(() => MyOfferWidget()),
                    child: Text('see_all'.tr,style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.75)),))])),

          const SizedBox(height: Dimensions.paddingSizeDefault,),
          SizedBox(width: Get.width,height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: offerController.bestOfferModel!.data!.length,itemBuilder: (context,index){
              return InkWell( onTap: () => Get.to(() => DiscountScreen(offerModel: offerController.bestOfferModel!.data![index])),
                child: Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                  child: SizedBox(height: MediaQuery.of(context).size.height * 0.12,width: MediaQuery.of(context).size.width * 0.65,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusLarge ),
                          child: Image.network(offerController.bestOfferModel!.data![index].image!,fit: BoxFit.fill,height:MediaQuery.of(context).size.height * 0.12,width: MediaQuery.of(context).size.width * 0.65)),

                      const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                      Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault                 ),
                        child: Text(offerController.bestOfferModel!.data![index].title ?? '',style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall),overflow: TextOverflow.ellipsis,),
                      ),

                      const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                      Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                        child: Text(offerController.bestOfferModel!.data![index].shortDescription ?? '',style: textRegular.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeSmall),overflow: TextOverflow.ellipsis ,),
                      )
                    ],),
                  ),
                ),
              );
            },),
          )


        ]),
      ) :
      const SizedBox() : const MyOfferShimmerWidget();
    });
  }
}

