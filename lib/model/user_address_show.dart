class UserAddressShow {
  bool? result;
  String? message;
  List<UserAddress>? userAddress;

  UserAddressShow({this.result, this.message, this.userAddress});

  UserAddressShow.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['user_address'] != null) {
      userAddress = <UserAddress>[];
      json['user_address'].forEach((v) {
        userAddress!.add(UserAddress.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
    if (userAddress != null) {
      data['user_address'] = userAddress!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserAddress {
  int? id;
  int? userId;
  String? addressName;
  String? address;
  int? countryId;
  String? region;
  String? city;
  int? regionId;
  String? state;
  String? stateid;
  String? homeNo;
  String? createdAt;
  String? updatedAt;
  String? country;
  String? image;
  var latitude;
  var longitude;

  UserAddress(
      {this.id,
      this.userId,
      this.addressName,
      this.address,
      this.countryId,
      this.region,
      this.city,
      this.regionId,
      this.state,
      this.stateid,
      this.homeNo,
      this.createdAt,
      this.updatedAt,
      this.country,
      this.image,
      this.latitude,
      this.longitude});

  UserAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    addressName = json['address_name'];
    address = json['address'];
    countryId = json['country_id'];
    region = json['region'];
    city = json['city_name'];
    regionId = json['region_id'];
    state = json['state_name'];
    stateid = json['state'];
    homeNo = json['home_no'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    country = json['country'];
    image = json['image'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['address_name'] = addressName;
    data['address'] = address;
    data['country_id'] = countryId;
    data['region'] = region;
    data['city_name'] = city;
    data['region_id'] = regionId;
    data['state_name'] = state;
    data['state'] = stateid;
    data['home_no'] = homeNo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['country'] = country;
    data['image'] = image;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
