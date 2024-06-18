import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/support/widgets/contact_us_view.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> with SingleTickerProviderStateMixin{
  late TabController tabController;
  late int currentPage;
  String data = '';

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);
    data = '${Get.find<ConfigController>().config!.termsAndConditions?.shortDescription ?? ''}'
        '\n${Get.find<ConfigController>().config!.termsAndConditions?.longDescription ?? ''}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyWidget(
        appBar: AppBarWidget(title: 'do_you_need_help'.tr,centerTitle: true,showBackButton: true,),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault),
          child: Column(children: [

            TabBar(
              controller: tabController,
              unselectedLabelColor: Colors.grey,
              labelColor: Get.isDarkMode ? Colors.white : Theme.of(context).primaryColor,
              labelStyle: textSemiBold.copyWith(),
              isScrollable: true,
              indicatorPadding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
              indicator: UnderlineTabIndicator(borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2)),
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              tabs:  [
                Tab(text: 'help_support'.tr),
                Tab(text: 'terms_and_conditions'.tr)
              ],
            ),

            Expanded(child: TabBarView(controller: tabController,
              children:  [

                const ContactUsView(),

                SingleChildScrollView(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall).copyWith(top: Dimensions.paddingSizeExtraLarge),
                  physics: const BouncingScrollPhysics(),
                  child: HtmlWidget(data, key: const Key('terms_and_condition')),
                ),

              ],
            )),

          ]),
        ),
      ),
    );
  }
}
