import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class CustomAddButton extends StatelessWidget {
  final String buttonText;
  final Color? backgroundColor;
  final Function()? onTap;
  const CustomAddButton({super.key, required this.buttonText, this.backgroundColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(margin: const EdgeInsets.fromLTRB( Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,0),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusOverLarge),
          color: backgroundColor??Theme.of(context).primaryColor.withOpacity(0.05),
          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.4),width: 0.5)),
        child: Row(mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children:[Icon(Icons.add,color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.6),size: 16,),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
            Text(buttonText.tr,style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.6)))]
        ),
      ),
    );
  }
}
