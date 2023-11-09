class ViewProfileModel {
  bool? result;
  String? message;
  Userdetails? userdetails;

  ViewProfileModel({this.result, this.message, this.userdetails});

  ViewProfileModel.fromJson(Map<String, dynamic> json) {
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
  String? firstname;
  String? lastname;
  String? dob;
  String? gender;
  // void? email;
  // void? emailVerifiedAt;
  String? phone;
  int? countryId;
  String? state;
  String? region;
  String? profilePic;
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
  String? homeLocation;
  String? userType;
  String? coverPic;
  String? latitude;
  String? longitude;
  String? coverImage;
  String? civilCardNo;
  String? email;

  Userdetails(
      {this.id,
      this.firstname,
      this.lastname,
      this.dob,
      this.gender,
      // this.email,
      // this.emailVerifiedAt,
      this.phone,
      this.countryId,
      this.state,
      this.region,
      this.profilePic,
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
      this.countryName,
      this.homeLocation,
      this.userType,
      this.coverPic,
      this.latitude,
      this.longitude,
      this.coverImage,
      this.civilCardNo,
      this.email});

  Userdetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    dob = json['dob'];
    gender = json['gender'];
    // email = json['email'];
    // emailVerifiedAt = json['email_verified_at'];
    phone = json['phone'];
    countryId = json['country_id'];
    state = json['state'];
    region = json['region'];
    profilePic = json['profile_pic'];
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
    homeLocation = json['home_location'];
    userType = json['user_type'];
    coverPic = json['cover_pic'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    coverImage = json['cover_image'];
    civilCardNo = json['civil_card_no'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['dob'] = dob;
    data['gender'] = gender;
    // data['email'] = email;
    // data['email_verified_at'] = emailVerifiedAt;
    data['phone'] = phone;
    data['country_id'] = countryId;
    data['state'] = state;
    data['region'] = region;
    data['profile_pic'] = profilePic;
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
    data['home_location'] = homeLocation;
    data['cover_pic'] = coverPic;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['cover_image'] = coverImage;
    data['civil_card_no'] = civilCardNo;
    data['email'] = email;
    return data;
  }
}
