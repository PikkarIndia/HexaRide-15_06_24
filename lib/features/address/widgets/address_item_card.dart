import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/home/widgets/home_my_address.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/features/address/domain/models/address_model.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/set_destination/screens/set_destination_screen.dart';


class AddressItemCard extends StatelessWidget {
  final Address address;
  final AddressPage? addressPage;
  const AddressItemCard({super.key, required this.address, this.addressPage});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: () {
        if(addressPage == AddressPage.home) {
          Get.to(() => SetDestinationScreen(address: address));
        }else if(addressPage == AddressPage.sender) {
          Get.find<LocationController>().setSenderAddress(address);
        }else if(addressPage == AddressPage.receiver) {
          Get.find<LocationController>().setReceiverAddress(address);
        }
      },
      child: Container(margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSize,),
        decoration: BoxDecoration(
          color: Get.isDarkMode? Theme.of(context).canvasColor:Theme.of(context).primaryColor.withOpacity(0.03),
          border: Border.all(color:Get.isDarkMode? Theme.of(context).hintColor : Theme.of(context).primaryColor.withOpacity(0.4),width:0.5),
          borderRadius: BorderRadius.circular(Dimensions.radiusOverLarge)),
        child: Row(children: [

          Image.asset(address.addressLabel == 'home' ? Images.homeIcon : address.addressLabel == 'office' ? Images.workIcon : Images.otherIcon,
            color: Get.find<ThemeController>().darkTheme ? Theme.of(context).primaryColor : Theme.of(context).hintColor,height: 16,width: 16,),
          const SizedBox(width: 5),

          Text(address.addressLabel!.tr),

        ]),
      ),
    );
  }
}
