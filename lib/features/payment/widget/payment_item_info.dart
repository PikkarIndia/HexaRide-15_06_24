
import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class PaymentItemInfo extends StatelessWidget {
  final String? icon;
  final String title;
  final double amount;
  final bool isSubTotal;
  final bool isFromTripDetails;
  final String? paymentType;
  final bool discount;

  const PaymentItemInfo({super.key, required this.title,  this.icon, required this.amount,  this.isSubTotal = false,
    this.isFromTripDetails = false, this.paymentType, this.discount = false});

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: Row(children: [
        if(icon != null)
          SizedBox(width:Dimensions.iconSizeSmall, child: Image.asset(icon!, color: Theme.of(context).primaryColor)),
        if(icon != null)
          const SizedBox(width: Dimensions.paddingSizeSmall),
        Expanded(child: icon != null?
           Text(title, style: textMedium.copyWith(color: Theme.of(context).primaryColor)):
           Text(title, style: textBold.copyWith(color: Theme.of(context).primaryColor))),
        isSubTotal || isFromTripDetails ?
        Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(.15),
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
            child: Text(PriceConverter.convertPrice(amount), style: textSemiBold.copyWith(color: Theme.of(context).primaryColorDark))) :
        paymentType!=null ?
            Text(paymentType!,style: textRegular.copyWith(color: Theme.of(context).primaryColor)):
            discount ?
            Text('- ${PriceConverter.convertPrice(amount)}', style: textRegular.copyWith(color: Theme.of(context).primaryColor)):
            Text(PriceConverter.convertPrice(amount), style: textRegular.copyWith(color: Theme.of(context).primaryColor))

      ],),
    );
  }
}