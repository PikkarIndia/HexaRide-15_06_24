import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dar.dart';
import 'package:ride_sharing_user_app/helper/route_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/features/auth/widgets/test_field_title.dart';
import 'package:ride_sharing_user_app/features/home/widgets/home_my_address.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/location/view/pick_map_screen.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/features/profile/controllers/profile_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/custom_text_field.dart';
import 'package:flutter/services.dart';


class ParcelInfoWidget extends StatefulWidget {
  final bool isSender;
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const ParcelInfoWidget({super.key, required this.isSender, required this.expandableKey});

  @override
  State<ParcelInfoWidget> createState() => _ParcelInfoWidgetState();
}

class _ParcelInfoWidgetState extends State<ParcelInfoWidget> {


  @override
  void initState() {
    super.initState();

    if(widget.isSender) {
      Get.find<ParcelController>().senderContactController.text = Get.find<ProfileController>().profileModel!.data!.phone!;
      Get.find<ParcelController>().senderNameController.text = Get.find<ProfileController>().customerName();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParcelController>(builder: (parcelController) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

        TextFieldTitle(title: 'contact'.tr, textOpacity: 0.8),
        CustomTextField(
          prefix: false,
          borderRadius: 10,
          showBorder: false,
          hintText: 'contact_number'.tr,
          fillColor:  Get.isDarkMode? Theme.of(context).cardColor : Theme.of(context).primaryColor.withOpacity(0.04),
          controller: widget.isSender ? parcelController.senderContactController : parcelController.receiverContactController,
          focusNode: widget.isSender ? parcelController.senderContactNode : parcelController.receiverContactNode,
          nextFocus: widget.isSender ? parcelController.senderNameNode : parcelController.receiverNameNode,
          inputType: TextInputType.phone,
          onTap: () => parcelController.focusOnBottomSheet(widget.expandableKey)),

        TextFieldTitle(title: 'name'.tr, textOpacity: 0.8),
        CustomTextField(
          prefixIcon: Images.editProfilePhone,
          borderRadius: 10,
          showBorder: false,
          prefix: false,
          capitalization: TextCapitalization.words,
          hintText: 'name'.tr,
          fillColor: Get.isDarkMode? Theme.of(context).cardColor : Theme.of(context).primaryColor.withOpacity(0.04),
          controller: widget.isSender ? parcelController.senderNameController : parcelController.receiverNameController,
          focusNode: widget.isSender ? parcelController.senderNameNode : parcelController.receiverNameNode,
          nextFocus: widget.isSender ? parcelController.senderAddressNode : parcelController.receiverAddressNode,
          inputType: TextInputType.text,
          onTap: () => parcelController.focusOnBottomSheet(widget.expandableKey)),

        TextFieldTitle(title: 'address'.tr, textOpacity: 0.8),

        InkWell(
          onTap: () => RouteHelper.goPageAndHideTextField(context, PickMapScreen(
            type: widget.isSender? LocationType.senderLocation : LocationType.receiverLocation,
          )),
          child: CustomTextField(
            prefix: false,
            suffixIcon: Images.location,
            borderRadius: 10,
            isEnabled: false,
            showBorder: false,
            textColor: Theme.of(context).textTheme.bodyLarge!.color,
            hintText: 'location'.tr,
            fillColor:  Get.isDarkMode? Theme.of(context).cardColor : Theme.of(context).primaryColor.withOpacity(0.04),
            controller: widget.isSender ? parcelController.senderAddressController : parcelController.receiverAddressController,
            focusNode: widget.isSender ? parcelController.senderAddressNode : parcelController.receiverAddressNode,
            inputType: TextInputType.text,
            inputAction: TextInputAction.done,
            onTap: () => parcelController.focusOnBottomSheet(widget.expandableKey),
          ),
        ),

        HomeMyAddress(title: 'saved_address'.tr, addressPage: widget.isSender ? AddressPage.sender : AddressPage.receiver),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

      ]);
    });
  }
}
