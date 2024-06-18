abstract class ConfigServiceInterface{
  Future<dynamic> getConfigData();
  Future<bool> initSharedData();
  Future<bool> removeSharedData();
  bool? showIntro();
  void disableIntro();
}