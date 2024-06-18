import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/common_widgets/expandable_bottom_sheet.dar.dart';
import 'package:ride_sharing_user_app/features/map/widget/custom_icon_card.dart';
import 'package:ride_sharing_user_app/features/map/widget/discount_coupon_bottomsheet.dart';
import 'package:ride_sharing_user_app/features/parcel/widgets/parcel_expendable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/features/ride/widgets/ride_expendable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:ride_sharing_user_app/features/location/controllers/location_controller.dart';
import 'package:ride_sharing_user_app/features/map/controllers/map_controller.dart';
import 'package:ride_sharing_user_app/features/ride/controllers/ride_controller.dart';
import 'package:ride_sharing_user_app/common_widgets/app_bar_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/body_widget.dart';
import 'package:ride_sharing_user_app/common_widgets/button_widget.dart';


enum MapScreenType{ride, splash, parcel, location}

class MapScreen extends StatefulWidget {
  final MapScreenType fromScreen;
  final bool isShowCurrentPosition;
  const MapScreen({super.key, required this.fromScreen, this.isShowCurrentPosition = true});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey<ExpandableBottomSheetState>();


  @override
  void initState() {
    super.initState();
    Get.find<MapController>().setContainerHeight((widget.fromScreen == MapScreenType.parcel) ? 200 : 260, false);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    Get.find<MapController>().mapController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        BodyWidget(
          appBar: AppBarWidget(
            title: 'the_deliveryman_need_you'.tr, centerTitle: true,
            onBackPressed: () {
              if(Navigator.canPop(context)) {
                Get.back();
              }else {
                Get.offAll(()=> const DashboardScreen());
              }
            },
          ),
          topMargin: 0,
          body: GetBuilder<MapController>(builder: (mapController) {
            return ExpandableBottomSheet(
              key: key,
              background: GetBuilder<RideController>(builder: (rideController) {
                return Stack(children: [

                  Padding(padding: EdgeInsets.only(bottom: mapController.sheetHeight - 20), child: GoogleMap(
                   // mapType: MapType.terrain,
                    style: Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
                    initialCameraPosition:  CameraPosition(
                      target:  rideController.tripDetails?.pickupCoordinates != null ? LatLng(
                        rideController.tripDetails!.pickupCoordinates!.coordinates![1],
                        rideController.tripDetails!.pickupCoordinates!.coordinates![0],
                      ): Get.find<LocationController>().initialPosition,
                      zoom: 16,),
                    onMapCreated: (GoogleMapController controller) {
                      mapController.mapController = controller;
                      if(Get.find<RideController>().currentRideState.name == 'findingRider' || Get.find<RideController>().currentRideState.name == 'riseFare'){
                        Get.find<MapController>().initializeData();
                        Get.find<MapController>().setOwnCurrentLocation();
                      }else if(Get.find<RideController>().currentRideState.name == 'initial'){
                        mapController.getPolyline();
                      }else if(Get.find<RideController>().currentRideState.name == 'completeRide'){
                        Get.find<MapController>().initializeData();
                      }else{
                        Get.find<MapController>().initializeData();
                        Get.find<MapController>().setMarkersInitialPosition();
                        Get.find<RideController>().startLocationRecord();
                      }
                      _mapController = controller;
                    },
                    minMaxZoomPreference: const MinMaxZoomPreference(0, AppConstants.mapZoom),
                    markers: Set<Marker>.of(mapController.markers),
                    polylines: Set<Polyline>.of(mapController.polylines.values),
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                    indoorViewEnabled: true,
                    mapToolbarEnabled: true)),

                  if(widget.isShowCurrentPosition)
                  Positioned(bottom: 300,right: 0,
                    child: Align(alignment: Alignment.bottomRight,
                      child: GetBuilder<LocationController>(
                          builder: (locationController) {
                            return CustomIconCard(index: 5,icon: Images.currentLocation,
                                onTap: () async {
                                  await locationController.getCurrentLocation(mapController: _mapController);
                                  await _mapController?.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: Get.find<LocationController>().initialPosition, zoom: 16)));
                                });
                          }
                      ),
                    ),
                  ),

                  Positioned(bottom: 370,right: 15,
                    child: InkWell(onTap: (){
                      Get.bottomSheet(const DiscountAndCouponBottomSheet(),backgroundColor: Theme.of(context).cardColor,isDismissible: false,
                      );},
                      child: Align(alignment: Alignment.bottomRight,
                        child: Container(height: 40, width: 40,decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.orange.withOpacity(0.5)),
                          child: Center(
                              child: Image.asset(Images.offerMapIcon,height: 20,width: 20,)))))),
                ]);
              }),
              persistentContentHeight: mapController.sheetHeight,

              expandableContent: Column(mainAxisSize: MainAxisSize.min, children: [

                widget.fromScreen == MapScreenType.parcel ?
                GetBuilder<RideController>(
                  builder: (parcelController) {
                    return ParcelExpendableBottomSheet(expandableKey: key);
                  }
                ) : (widget.fromScreen == MapScreenType.ride || widget.fromScreen == MapScreenType.splash) ?

                GetBuilder<RideController>(
                    builder: (rideController) {
                      return RideExpendableBottomSheet(expandableKey: key);
                    }) : const SizedBox(),

                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),

              ]),
            );
          }),
        ),



        widget.fromScreen == MapScreenType.location ? Positioned(
          child: Align(alignment: Alignment.bottomCenter,
            child: SizedBox(height: 70, child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: ButtonWidget(buttonText: 'set_location'.tr, onPressed: () => Get.back()),
            )),
          ),
        ) : const SizedBox(),

      ]),
    );
  }
}
