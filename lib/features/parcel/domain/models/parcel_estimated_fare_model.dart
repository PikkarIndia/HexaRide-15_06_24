class ParcelEstimatedFare {
  String? responseCode;
  ParcelFare? data;


  ParcelEstimatedFare(
      {this.responseCode,
        this.data});

  ParcelEstimatedFare.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    data = json['data'] != null ? ParcelFare.fromJson(json['data']) : null;

  }

}

class ParcelFare {
  String? id;
  String? zoneId;
  double? baseFare;
  double? baseFarePerKm;
  List<Fare>? fare;
  double? estimatedDistance;
  String? estimatedDuration;
  double? estimatedFare;
  double? discountFare;
  double? discountAmount;
  String? requestType;
  String? encodedPolyline;
  bool? couponApplicable;

  ParcelFare(
      {this.id,
        this.zoneId,
        this.baseFare,
        this.baseFarePerKm,
        this.fare,
        this.estimatedDistance,
        this.estimatedDuration,
        this.estimatedFare,
        this.discountAmount,
        this.discountFare,
        this.requestType,
        this.couponApplicable,
        this.encodedPolyline});

  ParcelFare.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    zoneId = json['zone_id'];
    baseFare = json['base_fare'].toDouble();
    baseFarePerKm = json['base_fare_per_km'].toDouble();
    if (json['fare'] != null) {
      fare = <Fare>[];
      json['fare'].forEach((v) {
        fare!.add(Fare.fromJson(v));
      });
    }
    if(json['estimated_distance'] != null){
      try{
        estimatedDistance = json['estimated_distance'].toDouble();

      }catch(e){
        estimatedDistance = double.parse(json['estimated_distance'].toString());

      }
    }
    estimatedDuration = json['estimated_duration'].toString();
    estimatedFare = json['estimated_fare'].toDouble();
    discountFare = json['discount_fare'].toDouble();
    discountAmount = json['discount_amount'].toDouble();
    couponApplicable = json['coupon_applicable'];
    requestType = json['request type'];
    encodedPolyline = json['encoded_polyline'];
  }

}

class Fare {
  int? id;
  String? parcelFareId;
  String? parcelWeightId;
  String? parcelCategoryId;
  double? fare;
  String? zoneId;
  String? createdAt;
  String? updatedAt;

  Fare(
      {this.id,
        this.parcelFareId,
        this.parcelWeightId,
        this.parcelCategoryId,
        this.fare,
        this.zoneId,
        this.createdAt,
        this.updatedAt});

  Fare.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parcelFareId = json['parcel_fare_id'];
    parcelWeightId = json['parcel_weight_id'];
    parcelCategoryId = json['parcel_category_id'];
    fare = double.parse(json['fare_per_km'].toString());
    zoneId = json['zone_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}
