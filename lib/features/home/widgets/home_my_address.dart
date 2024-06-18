import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/address/widgets/address_item_card.dart';
import 'package:ride_sharing_user_app/features/home/widgets/address_shimmer.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/address/controllers/address_controller.dart';
import 'package:ride_sharing_user_app/features/address/screens/add_new_address.dart';
import 'package:ride_sharing_user_app/features/wallet/widget/custom_title.dart';

enum AddressPage{home, sender, receiver}

class HomeMyAddress extends StatefulWidget {
  final String? title;
  final AddressPage? addressPage;
  const HomeMyAddress({super.key, this.title, this.addressPage});

  @override
  State<HomeMyAddress> createState() => _HomeMyAddressState();
}

class _HomeMyAddressState extends State<HomeMyAddress> {
  @override
  Widget build(BuildContext context) {

    return GetBuilder<AddressController>(builder: (addressController) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomTitle(title: widget.title ?? 'my_address'.tr, color: Theme.of(context).textTheme.bodyLarge!.color,fontSize: Dimensions.fontSizeDefault,),

          if(addressController.addressList != null && addressController.addressList!.isNotEmpty) ...[
            Text('saved_address_for_your_trip'.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
            const SizedBox(height: Dimensions.paddingSizeSmall,),
          ],

          addressController.addressList != null ? addressController.addressList!.isNotEmpty ? SizedBox(
            height: Get.width *0.075,
            child: ListView.builder(
              itemCount: addressController.addressList?.length,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context,index) {
                return AddressItemCard(address: addressController.addressList![index], addressPage: widget.addressPage);
              },
            ),
          ) : InkWell(onTap: ()=> Get.to(() =>   const AddNewAddress(address: null)),
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                color : Get.isDarkMode? Theme.of(context).canvasColor : Theme.of(context).colorScheme.onSecondary.withOpacity(.03)),
              child: Row(children: [

                Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Container(width: Dimensions.buttonSize,
                    height: Dimensions.buttonSize,
                    decoration: BoxDecoration(color: Get.isDarkMode? Theme.of(context).cardColor :Theme.of(context).primaryColor.withOpacity(.07),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    ),child: Center(child: Icon(Icons.add, color: Theme.of(context).primaryColor)))),

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('add_address'.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  Text('save_your_address_for_quick_trip'.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                ])),
                Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: SizedBox(width: 100, child: Image.asset(Images.addNewAddress))),
              ])),
          ) : const AddressShimmer(),
        ]);
      }
    );
  }
}
