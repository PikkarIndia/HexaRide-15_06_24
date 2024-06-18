import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/location/view/access_location_screen.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showActionButton;
  final Function()? onBackPressed;
  final bool centerTitle;
  final double? fontSize;
  final bool isHome;
  final String? subTitle;
  const AppBarWidget({
    super.key,
    required this.title,
    this.subTitle,
    this.showBackButton = true,
    this.onBackPressed,
    this.centerTitle= false,
    this.showActionButton= true,  
    this.isHome = false,
    this.fontSize});

  @override
  Widget build(BuildContext context) {

    return PreferredSize(
      preferredSize: const Size.fromHeight(150.0),
      child: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: isHome ? () => Get.to(() => const AccessLocationScreen()) : null,
          child: Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [


              Text(title.tr, style: textRegular.copyWith(
                fontSize: fontSize ??   Dimensions.fontSizeLarge ,
                color: Colors.white), maxLines: 1,textAlign: TextAlign.start, overflow: TextOverflow.ellipsis),


              subTitle != null ?
              Text('${'trip'.tr} #$subTitle', style: textRegular.copyWith(
                  fontSize: fontSize ?? (isHome ?  Dimensions.fontSizeLarge : Dimensions.fontSizeLarge),
                  color: Colors.white), maxLines: 1,textAlign: TextAlign.start, overflow: TextOverflow.ellipsis) : const SizedBox(),


              isHome ? GetBuilder<LocationController>(builder: (locationController) {
                return Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                  child: Row(children:  [const Icon(Icons.place_outlined,color: Colors.white, size: 16),
                    const SizedBox(width: Dimensions.paddingSizeSeven),
                    Expanded(child: Text(locationController.getUserAddress()?.address ?? '', maxLines: 1,overflow: TextOverflow.ellipsis,
                      style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeExtraSmall)))]));}) : const SizedBox.shrink()
            ]),
          ),
        ),

        centerTitle: centerTitle,
        excludeHeaderSemantics: true,
        titleSpacing: 0,
        leading: showBackButton ? IconButton(icon: const Icon(Icons.arrow_back),
          color: Colors.white, onPressed: () => onBackPressed != null ? onBackPressed!() : Get.back(),) :


        Padding(padding: const EdgeInsets.all(Dimensions.paddingSize),
          child: Image.asset(Images.icon,height: Get.height*0.01,width: Get.width*0.01,)),
        elevation: 0));
  }

  @override
  Size get preferredSize => const Size(Dimensions.webMaxWidth, 150);
}