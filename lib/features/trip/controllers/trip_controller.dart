import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/features/trip/domain/models/trip_cancelation_cause_list_model.dart';
import 'package:ride_sharing_user_app/features/trip/domain/models/trip_model.dart';
import 'package:ride_sharing_user_app/features/trip/domain/services/service_interface.dart';

class TripController extends GetxController implements GetxService {
  final TripServiceInterface tripServiceInterface;
  TripController({required this.tripServiceInterface});

  final List<String> _filterList = ['all_time', 'today', 'previous_day', 'custom_date'];
  int filterIndex = 0;
  bool _showCustomDate = false;
  String _filterStartDate = '';
  String _filterEndDate = '';
  TripModel? tripModel;

  List<String> get filterList => _filterList;
  bool get showCustomDate => _showCustomDate;
  String get filterStartDate => _filterStartDate;
  String get filterEndDate => _filterEndDate;

  void initData() {
    filterIndex = 0;
    _showCustomDate = false;
    _filterStartDate = '';
    _filterEndDate = '';
  }

  void setFilterTypeName(int index) {
    filterIndex = index;
    getTripList(1, reload: true);
    update();
  }

  Future<void> getTripList(int offset, {bool reload = false}) async {
    if(reload) {
      tripModel = null;
      update();
    }
    Response response = await tripServiceInterface.getTripList('ride_request', offset, _filterStartDate, _filterEndDate, _filterList[filterIndex]);
    if (response.statusCode == 200 && response.body['date'] != []) {
      if(offset == 1) {
        tripModel = TripModel.fromJson(response.body);
      }else {
        tripModel?.data!.addAll(TripModel.fromJson(response.body).data!);
        tripModel?.offset = TripModel.fromJson(response.body).offset;
        tripModel?.totalSize = TripModel.fromJson(response.body).totalSize;
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void updateShowCustomDateState(bool state){
    _showCustomDate = state;
    update();
  }

  void setFilterDateRangeValue({String? start, String? end}) {
    filterIndex = _filterList.length - 1;
    _filterStartDate = start ?? '';
    _filterEndDate = end ?? '';
    getTripList(1);
    update();
  }


  TripCancellationCauseList? tripCancellationCauseList;

  int tripCancellationCauseCurrentIndex = 0;


  void getOngoingAndAcceptedCancellationCauseList() async{
    Response response = await tripServiceInterface.getTripOngoingandAceptedCancelationCauseList();

    if(response.statusCode == 200){
      tripCancellationCauseList = TripCancellationCauseList.fromJson(response.body);
    }else{
      ApiChecker.checkApi(response);
    }
  }

  void setCancellationCurrentIndex(int index){
    tripCancellationCauseCurrentIndex = index;
  }

}