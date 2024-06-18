import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dar.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/parcel_info_widget.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/parcel/controllers/parcel_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';

class SenderReceiverInfoWidget extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const SenderReceiverInfoWidget({super.key, required this.expandableKey});

  @override
  State<SenderReceiverInfoWidget> createState() => _SenderReceiverInfoWidgetState();
}
class _SenderReceiverInfoWidgetState extends State<SenderReceiverInfoWidget> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: GetBuilder<ParcelController>(builder: (parcelController) {
        return Column(mainAxisSize: MainAxisSize.min, children: [

          Container(width: MediaQuery.of(context).size.width * 0.7, height: 45,
            decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault + 2),),
            child: TabBar(padding: EdgeInsets.zero,
              dividerHeight: 0,
              indicatorSize: TabBarIndicatorSize.tab,
              controller: parcelController.tabController,
              unselectedLabelColor: Colors.grey,
              labelColor:  Colors.white,
              labelStyle: textMedium.copyWith(),
              indicatorColor: Theme.of(context).primaryColor,
              indicator:  BoxDecoration(color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
              tabs:  [
                SizedBox(height: 30, child: Tab(text: 'sender_info'.tr,)),
                SizedBox(height: 30, child: Tab(text: 'receiver_info'.tr)),
              ],
              onTap: (index) {
                parcelController.updateTabControllerIndex(index);
              },
            ),
          ),

          ParcelInfoWidget(isSender: parcelController.tabController.index == 0, expandableKey: widget.expandableKey),

          ButtonWidget(buttonText: "next".tr,
            onPressed: () {
              if(parcelController.tabController.index == 0) {
                if(parcelController.senderContactController.text.isEmpty){
                  showCustomSnackBar('enter_sender_contact_number'.tr);
                }else if(parcelController.senderNameController.text.isEmpty){
                  showCustomSnackBar('enter_sender_name'.tr);
                } else if(parcelController.senderAddressController.text.isEmpty){
                  showCustomSnackBar('enter_sender_address'.tr);
                }else {
                  parcelController.updateTabControllerIndex(1);
                }
              }
              else {
                if(parcelController.receiverContactController.text.isEmpty){
                  showCustomSnackBar('enter_receiver_contact_number'.tr);
                }else if(parcelController.receiverNameController.text.isEmpty){
                  showCustomSnackBar('enter_receiver_name'.tr);
                } else if(parcelController.receiverAddressController.text.isEmpty){
                  showCustomSnackBar('enter_receiver_address'.tr);
                }else if(parcelController.senderContactController.text.isEmpty){
                  showCustomSnackBar('enter_sender_contact_number'.tr);
                }else if(parcelController.senderNameController.text.isEmpty){
                  showCustomSnackBar('enter_sender_name'.tr);
                } else if(parcelController.senderAddressController.text.isEmpty){
                  showCustomSnackBar('enter_sender_address'.tr);
                }else {
                  Get.find<MapController>().notifyMapController();
                  parcelController.updateParcelState(ParcelDeliveryState.addOtherParcelDetails);
                }
              }
            },
          ),

        ]);
      }),
    );
  }

}
