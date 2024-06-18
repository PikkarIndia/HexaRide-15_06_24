import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';


class PagerContent extends StatefulWidget {
  const PagerContent({super.key, required this.image, required this.text, required this.index});
  final String image;
  final String text;
  final int index;

  @override
  State<PagerContent> createState() => _PagerContentState();
}

class _PagerContentState extends State<PagerContent> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose()
  {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   if(widget.index!=3){
     return Stack(
       clipBehavior: Clip.none,
       children: [
         Positioned(
           bottom: 100,right: 0,left: -100,
           child: SizedBox(
             width: 1200,height: 300+(300 * double.tryParse(_animation.value.toString())!),
             child: Image.asset(Images.splashBackgroundOne,
               fit: BoxFit.fitHeight,
               alignment: widget.index==0?Alignment.centerLeft:widget.index==1?Alignment.centerRight:Alignment.center,
             ),
           ),
         ),
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             const Spacer(),
             SizedBox(
               width: MediaQuery.of(context).size.width*0.7,
               height: MediaQuery.of(context).size.height*0.25,
               child: Center(
                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                   child: Text(widget.text,style: textMedium.copyWith(
                       color: Colors.white,fontSize: 30
                   ),),
                 ),
               ),
             ),
             const Spacer(),
             Padding(
               padding:  EdgeInsets.symmetric(horizontal: widget.index!=0? Dimensions.paddingSizeLarge:0),
               child: SizedBox( child: Image.asset(widget.image,height: MediaQuery.of(context).size.height*0.5,)),
             ),
             SizedBox(height: MediaQuery.of(context).size.height*0.05,)
           ],
         ),
       ],
     );
   }else{
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         SizedBox( child: Image.asset(widget.image,height: MediaQuery.of(context).size.height*0.5,)),
         const SizedBox(height: Dimensions.paddingSizeExtraLarge,),
         SizedBox(
           width: MediaQuery.of(context).size.width*0.7,
           child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
             child: Text(widget.text,style: textMedium.copyWith(
                 color: Colors.white,fontSize: 30
             ),),
           ),
         ),

       ],
     );
   }
  }
}