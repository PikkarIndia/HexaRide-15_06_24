class CouponModel {
  String? responseCode;
  String? message;
  int? totalSize;
  String? limit;
  String? offset;
  List<Coupon>? data;


  CouponModel(
      {this.responseCode,
        this.message,
        this.totalSize,
        this.limit,
        this.offset,
        this.data,
        });

  CouponModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <Coupon>[];
      json['data'].forEach((v) {
        data!.add(Coupon.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['message'] = message;
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Coupon {
  String? id;
  String? name;
  String? description;
  String? minTripAmount;
  String? maxCouponAmount;
  String? coupon;
  String? amountType;
  String? couponType;
  String? couponCode;
  int? limit;
  String? startDate;
  String? endDate;
  String? rules;
  int? isActive;
  String? createdAt;
  bool? isApplied;
  bool isLoading = false;

  Coupon(
      {this.id,
        this.name,
        this.description,
        this.minTripAmount,
        this.maxCouponAmount,
        this.coupon,
        this.amountType,
        this.couponType,
        this.couponCode,
        this.limit,
        this.startDate,
        this.endDate,
        this.rules,
        this.isActive,
        this.createdAt,
        this.isApplied,
        this.isLoading = false});

  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    minTripAmount = json['min_trip_amount'];
    maxCouponAmount = json['max_coupon_amount'];
    coupon = json['coupon'];
    amountType = json['amount_type'];
    couponType = json['coupon_type'];
    couponCode = json['coupon_code'];
    limit = json['limit'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    rules = json['rules'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    isApplied = json['is_applied'];
    isLoading = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['min_trip_amount'] = minTripAmount;
    data['max_coupon_amount'] = maxCouponAmount;
    data['coupon'] = coupon;
    data['amount_type'] = amountType;
    data['coupon_type'] = couponType;
    data['coupon_code'] = couponCode;
    data['limit'] = limit;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['rules'] = rules;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['is_applied'] = isApplied;
    return data;
  }
}
