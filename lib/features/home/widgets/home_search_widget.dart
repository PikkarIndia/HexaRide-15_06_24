import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/set_destination/screens/set_destination_screen.dart';

class HomeSearchWidget extends StatelessWidget {
  const HomeSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: Dimensions.searchBarSize,
      child: InkWell(onTap: () => Get.to(() => const SetDestinationScreen()),
        child: Container(decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.03),
          borderRadius: BorderRadius.circular(20)
        ),
          child: TextField(style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8)),
            cursorColor: Theme.of(context).hintColor,
            autofocus: false,
            textAlignVertical: TextAlignVertical.center,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal :Dimensions.paddingSizeDefault, vertical:Dimensions.paddingSizeExtraSmall),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide:  BorderSide(width:  0.5, color: Theme.of(context).primaryColor.withOpacity(0.5))),

              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),
                borderSide:  BorderSide(width: 0.5, color: Theme.of(context).primaryColor)),

              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide:  BorderSide(width: 0.5, color: Theme.of(context).primaryColor),
              ),
              fillColor: Get.isDarkMode? Theme.of(context).canvasColor : Theme.of(context).hintColor.withOpacity(0.07),
              isDense: true,
              enabled: false,
              hintText: 'where_to_go'.tr,
              hintStyle:  textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.3)),
              filled: true,
              prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 20),
              suffixIcon:  IconButton(
                color: Theme.of(context).hintColor,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                },
                icon:Image.asset(Images.homeSearchIcon,color: Get.isDarkMode? Theme.of(context).hintColor : null , height: 20, width: 20),
              ) ,

            ),
          ),
        ),
      ),
    );
  }
}
