import 'package:ride_sharing_user_app/features/trip/domain/repositories/trip_repository_interface.dart';
import 'package:ride_sharing_user_app/features/trip/domain/services/service_interface.dart';

class TripService implements TripServiceInterface{
  TripRepositoryInterface tripRepositoryInterface;
  TripService({required this.tripRepositoryInterface});

  @override
  Future getTripList(String tripType, int offset, String from, String to, String status) async{
   return await tripRepositoryInterface.getTripList(tripType, offset, from, to, status);
  }

  @override
  Future getTripOngoingandAceptedCancelationCauseList() async{
    return await tripRepositoryInterface.getTripOngoingandAceptedCancelationCauseList();
  }

}