import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/image_widget.dart';


class PolicyScreen extends StatelessWidget {
  final bool isPolicy;
  final bool isLegal;
  final String? image;
  const PolicyScreen({super.key, this.isPolicy = false,  this.isLegal = false, this.image});


  @override
  Widget build(BuildContext context) {
    String data = '';
     data = isPolicy ? '${Get.find<ConfigController>().config?.privacyPolicy?.shortDescription ?? ''}\n${Get.find<ConfigController>().config?.privacyPolicy?.longDescription ?? ''}':
      isLegal ?
     '${Get.find<ConfigController>().config!.legal?.shortDescription??''}\n${Get.find<ConfigController>().config!.legal?.longDescription??''}' :
     '${Get.find<ConfigController>().config?.termsAndConditions?.shortDescription ?? ''}\n${Get.find<ConfigController>().config?.termsAndConditions?.longDescription ?? ''}';

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            backgroundColor:  Theme.of(context).primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            floating: true,
            pinned: true,
            title: Text(isPolicy? 'privacy_policy'.tr  :isLegal? 'legal'.tr : 'terms_and_condition'.tr,
              style: textRegular.copyWith(color: Colors.white),),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              centerTitle: true,
              background: Stack(fit: StackFit.expand,
                children: [
                  ImageWidget(image: '${AppConstants.baseUrl}/storage/app/public/business/pages/${image ?? ''}'),
                  Container(width: Get.width,height: 120, color: Colors.black54,)
                ],
              ),
            ),
        ),


          SliverToBoxAdapter(
            child: Column(
              children: [

                SingleChildScrollView(
                    padding:  const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    physics: const BouncingScrollPhysics(),
                    child: HtmlWidget(data, key: Key(isPolicy ? 'privacy_policy' : isLegal? 'legal' : 'terms_and_condition'))),
              ],
            ),
          )
        ],
      ));
  }
}