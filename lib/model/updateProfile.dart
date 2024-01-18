class UpdateProfileModel {
  bool? result;
  String? message;
  Userdetails? userdetails;

  UpdateProfileModel({this.result, this.message, this.userdetails});

  UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    userdetails = json['userdetails'] != null
        ? Userdetails.fromJson(json['userdetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
    if (userdetails != null) {
      data['userdetails'] = userdetails!.toJson();
    }
    return data;
  }
}

class Userdetails {
  int? id;
  String? name;
  String? dob;
  String? gender;
  // void? email;
  // void? emailVerifiedAt;
  String? phone;
  int? countryId;
  int? regionId;
  String? region;
  String? state;
  String? city;
  // void? profilePic;
  String? deviceId;
  String? apiToken;
  String? apiTokenExpiry;
  int? otp;
  String? otpExpiry;
  String? about;
  String? status;
  int? languageId;
  String? createdAt;
  String? updatedAt;
  String? countryName;

  Userdetails(
      {this.id,
      this.name,
      this.dob,
      this.gender,
      // this.email,
      // this.emailVerifiedAt,
      this.phone,
      this.countryId,
      this.state,
      this.region,
      this.regionId,
      this.city,
      // this.profilePic,
      this.deviceId,
      this.apiToken,
      this.apiTokenExpiry,
      this.otp,
      this.otpExpiry,
      this.about,
      this.status,
      this.languageId,
      this.createdAt,
      this.updatedAt,
      this.countryName});

  Userdetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    dob = json['dob'];
    gender = json['gender'];
    // email = json['email'];
    // emailVerifiedAt = json['email_verified_at'];
    phone = json['phone'];
    countryId = json['country_id'];
    state = json['state_name'];
    region = json['region'];
    regionId = json['region_id'];
    city = json['city_name'];
    // profilePic = json['profile_pic'];
    deviceId = json['device_id'];
    apiToken = json['api_token'];
    apiTokenExpiry = json['api_token_expiry'];
    otp = json['otp'];
    otpExpiry = json['otp_expiry'];
    about = json['about'];
    status = json['status'];
    languageId = json['language_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    countryName = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['dob'] = dob;
    data['gender'] = gender;
    // data['email'] = email;
    // data['email_verified_at'] = emailVerifiedAt;
    data['phone'] = phone;
    data['country_id'] = countryId;
    data['state_name'] = state;
    data['region'] = region;
    data['region_id'] = regionId;
    data['city_name'] = city;
    // data['profile_pic'] = profilePic;
    data['device_id'] = deviceId;
    data['api_token'] = apiToken;
    data['api_token_expiry'] = apiTokenExpiry;
    data['otp'] = otp;
    data['otp_expiry'] = otpExpiry;
    data['about'] = about;
    data['status'] = status;
    data['language_id'] = languageId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['country_name'] = countryName;
    return data;
  }
}
