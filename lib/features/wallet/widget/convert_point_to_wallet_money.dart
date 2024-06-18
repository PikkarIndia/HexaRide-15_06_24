import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/wallet/controllers/wallet_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class ConvertPointToWalletMoney extends StatefulWidget {
  const ConvertPointToWalletMoney({super.key});

  @override
  State<ConvertPointToWalletMoney> createState() => _ConvertPointToWalletMoneyState();
}

class _ConvertPointToWalletMoneyState extends State<ConvertPointToWalletMoney> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      builder: (walletController) {
        return Column(crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min, children: [

          Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
              boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.15), blurRadius: 1, spreadRadius: 1, offset: const Offset(0,0))]),
              child: Column(children: [Text('convert_point_to_wallet_money'.tr, style: textMedium.copyWith(color: Theme.of(context).primaryColor),),

                Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: SizedBox(height: 50,
                    child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: walletController.inputController,
                    focusNode: walletController.inputNode,
                    textInputAction: TextInputAction.go,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'enter_point'.tr,
                      hintStyle: textRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(.5)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:  BorderSide(width: 0.5,
                            color: Theme.of(context).hintColor.withOpacity(0.5))))))),
              ],
            ),),
          )
        ],);
      }
    );
  }
}
