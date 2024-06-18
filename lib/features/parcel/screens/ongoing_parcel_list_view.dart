import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/features/parcel/domain/models/parcel_list_model.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/parcel_item.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';

class OngoingParcelListView extends StatefulWidget {
  final String title;
  final ParcelListModel parcelListModel;
  const OngoingParcelListView({super.key, required this.title, required this.parcelListModel});

  @override
  State<OngoingParcelListView> createState() => _OngoingParcelListViewState();
}

class _OngoingParcelListViewState extends State<OngoingParcelListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyWidget(
        appBar: AppBarWidget(title: widget.title.tr,),
        body: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: widget.parcelListModel.data!.length,
            itemBuilder: (context, index){
            return ParcelItem(rideRequest: widget.parcelListModel.data![index],index: index,);
        }),
      ),
    );
  }
}
