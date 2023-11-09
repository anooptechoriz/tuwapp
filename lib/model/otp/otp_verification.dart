class OtpVerification {
  bool? result;
  String? message;
  Customerdetails? customerdetails;

  OtpVerification({this.result, this.message, this.customerdetails});

  OtpVerification.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    customerdetails = json['customerdetails'] != null
        ? Customerdetails.fromJson(json['customerdetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
    if (customerdetails != null) {
      data['customerdetails'] = customerdetails!.toJson();
    }
    return data;
  }
}

class Customerdetails {
  int? id;
  // void? name;
  // void? dob;
  // void? gender;
  // void? email;
  // void? emailVerifiedAt;
  String? phone;
  int? countryId;
  // void? stateId;
  // void? region;
  // void? profilePic;
  String? deviceId;
  String? apiToken;
  String? apiTokenExpiry;
  int? otp;
  String? otpExpiry;
  // void? about;
  String? status;
  int? languageId;
  String? createdAt;
  String? updatedAt;

  Customerdetails(
      {this.id,
      // this.name,
      // this.dob,
      // this.gender,
      // this.email,
      // this.emailVerifiedAt,
      this.phone,
      this.countryId,
      // this.stateId,
      // this.region,
      // this.profilePic,
      this.deviceId,
      this.apiToken,
      this.apiTokenExpiry,
      this.otp,
      this.otpExpiry,
      // this.about,
      this.status,
      this.languageId,
      this.createdAt,
      this.updatedAt});

  Customerdetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // name = json['name'];
    // dob = json['dob'];
    // gender = json['gender'];
    // email = json['email'];
    // emailVerifiedAt = json['email_verified_at'];
    phone = json['phone'];
    countryId = json['country_id'];
    // stateId = json['state_id'];
    // region = json['region'];
    // profilePic = json['profile_pic'];
    deviceId = json['device_id'];
    apiToken = json['api_token'];
    apiTokenExpiry = json['api_token_expiry'];
    otp = json['otp'];
    otpExpiry = json['otp_expiry'];
    // about = json['about'];
    status = json['status'];
    languageId = json['language_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    // data['name'] = name;
    // data['dob'] = dob;
    // data['gender'] = gender;
    // data['email'] = email;
    // data['email_verified_at'] = emailVerifiedAt;
    data['phone'] = phone;
    data['country_id'] = countryId;
    // data['state_id'] = stateId;
    // data['region'] = region;
    // data['profile_pic'] = profilePic;
    data['device_id'] = deviceId;
    data['api_token'] = apiToken;
    data['api_token_expiry'] = apiTokenExpiry;
    data['otp'] = otp;
    data['otp_expiry'] = otpExpiry;
    // data['about'] = about;
    data['status'] = status;
    data['language_id'] = languageId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
