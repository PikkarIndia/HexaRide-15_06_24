abstract class TripServiceInterface{
  Future<dynamic> getTripList(String tripType, int offset, String from, String to, String status);
  Future<dynamic> getTripOngoingandAceptedCancelationCauseList();
}