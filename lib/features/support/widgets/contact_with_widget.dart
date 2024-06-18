import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ContactWithWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String message;
  final String data;
  const ContactWithWidget({super.key, required this.title, required this.subTitle, required this.message, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [

      Text(
        title,
        style: textSemiBold.copyWith(
          fontSize: Dimensions.fontSizeLarge,
          color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),
        ),
      ),
      const SizedBox(height: Dimensions.paddingSizeLarge),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Text(subTitle, style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.6))),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Text(data,style: textMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!)),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text(message,style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.6))),

        ]),
      ),

    ]);
  }
}
