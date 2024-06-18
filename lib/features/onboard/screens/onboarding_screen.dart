import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/onboard/controllers/on_board_page_controller.dart';
import 'package:ride_sharing_user_app/features/onboard/widget/pager_content.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/features/auth/screens/sign_in_screen.dart';
import 'package:ride_sharing_user_app/features/splash/controllers/config_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(decoration: BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Theme.of(context).colorScheme.onPrimary, Theme.of(context).primaryColor],)),
          child: GetBuilder<OnBoardController>(builder: (onBoardController) {
            return Column(children: [

              Expanded(child: PageView.builder(
                onPageChanged: (value) {
                  if(value == 4) {
                    Get.find<ConfigController>().disableIntro();
                    Get.offAll(() => const SignInScreen());
                  }else{
                    onBoardController.onPageChanged(value);
                  }
                },
                itemCount: AppConstants.onBoardPagerData.length,
                itemBuilder: (context, index) => PagerContent(
                  image: AppConstants.onBoardPagerData[onBoardController.pageIndex].image,
                  text: AppConstants.onBoardPagerData[onBoardController.pageIndex].title,
                  index: onBoardController.pageIndex,
                ),
              )),

              GetBuilder<OnBoardController>(builder: (onBoardController) {
                return Column(children: [
                  onBoardController.pageIndex == 3?
                      SizedBox(width: 180,
                        child: ButtonWidget(transparent: true,
                          textColor: Theme.of(context).cardColor,
                          showBorder: true,
                          radius: 100,
                          borderColor: Theme.of(context).cardColor.withOpacity(.5),
                          buttonText : 'get_started'.tr,
                          onPressed: (){
                            Get.find<ConfigController>().disableIntro();
                            Get.offAll(() => const SignInScreen());
                          },
                        ),
                      )
                    :
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    IconButton(onPressed: () {if(AppConstants.onBoardPagerData.length-1 == onBoardController.pageIndex) {
                      Get.find<ConfigController>().disableIntro();
                      Get.offAll(() => const SignInScreen());
                    }else{
                      onBoardController.onPageIncrement();
                    }
                    },
                      icon: const Icon(Icons.arrow_forward,color: Colors.white60,),
                    ),
                    SizedBox(width: Get.width * 0.2),

                    TextButton(onPressed:() {
                      Get.find<ConfigController>().disableIntro();
                      Get.offAll(() => const SignInScreen());},
                      child: Text('skip'.tr, style: textRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge, color: Colors.white60,
                      )),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                ]);
              }),
            ]);
          }),
        )],
      ),
    );
  }
}
