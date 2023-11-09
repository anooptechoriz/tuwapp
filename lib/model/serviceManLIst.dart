class ServiceManListModel {
  bool? result;
  String? message;
  List<Serviceman>? serviceman;

  ServiceManListModel({this.result, this.message, this.serviceman});

  ServiceManListModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['serviceman'] != null) {
      serviceman = <Serviceman>[];
      json['serviceman'].forEach((v) {
        serviceman!.add(Serviceman.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
    if (serviceman != null) {
      data['serviceman'] = serviceman!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Serviceman {
  int? id;
  String? firstname;
  String? lastname;
  String? dob;
  String? gender;
  String? phone;
  String? about;
  String? profilePic;
  String? countryname;
  String? onlineStatus;
  var distance;
  int? featured;

  Serviceman(
      {this.id,
      this.firstname,
      this.lastname,
      this.dob,
      this.gender,
      this.phone,
      this.about,
      this.profilePic,
      this.distance,
      this.countryname,
      this.onlineStatus,
      this.featured});

  Serviceman.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    dob = json['dob'];
    gender = json['gender'];
    phone = json['phone'];
    about = json['about'];
    profilePic = json['profile_pic'];
    distance = json['distance'];
    countryname = json['country_name'];
    onlineStatus = json['online_status'];
    featured = json['featured'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['dob'] = dob;
    data['gender'] = gender;
    data['phone'] = phone;
    data['about'] = about;
    data['profile_pic'] = profilePic;
    data['distance'] = distance;
    data['country_name'] = countryname;
    data['online_status'] = onlineStatus;
    data['featured'] = featured;
    return data;
  }
}
