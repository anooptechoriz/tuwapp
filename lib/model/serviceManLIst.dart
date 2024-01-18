class ServiceManListModel {
  bool? result;
  String? message;
  Serviceman? serviceman;

  ServiceManListModel({this.result, this.message, this.serviceman});

  ServiceManListModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    serviceman = json['serviceman'] != null
        ? new Serviceman.fromJson(json['serviceman'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.serviceman != null) {
      data['serviceman'] = this.serviceman!.toJson();
    }
    return data;
  }
}

class Serviceman {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  Null? nextPageUrl;
  String? path;
  int? perPage;
  Null? prevPageUrl;
  int? to;
  int? total;

  Serviceman(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Serviceman.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Data {
  int? id;
  String? firstname;
  String? lastname;
  String? state;
  String? region;
  String? dob;
  String? gender;
  int? countryId;
  String? countryName;
  String? phone;
  String? about;
  String? onlineStatus;
  var profilePic;
  double? distance;
  int? featured;
  String? cityName;
  String? stateName;

  Data(
      {this.id,
      this.firstname,
      this.lastname,
      this.state,
      this.region,
      this.dob,
      this.gender,
      this.countryId,
      this.countryName,
      this.phone,
      this.about,
      this.onlineStatus,
      this.profilePic,
      this.distance,
      this.featured,
      this.cityName,
      this.stateName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    state = json['state'];
    region = json['region'];
    dob = json['dob'];
    gender = json['gender'];
    countryId = json['country_id'];
    countryName = json['country_name'];
    phone = json['phone'];
    about = json['about'];
    onlineStatus = json['online_status'];
    profilePic = json['profile_pic'];
    distance = json['distance'];
    featured = json['featured'];
    cityName = json['city_name'];
    stateName = json['state_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['state'] = this.state;
    data['region'] = this.region;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['country_id'] = this.countryId;
    data['country_name'] = this.countryName;
    data['phone'] = this.phone;
    data['about'] = this.about;
    data['online_status'] = this.onlineStatus;
    data['profile_pic'] = this.profilePic;
    data['distance'] = this.distance;
    data['featured'] = this.featured;
    data['city_name'] = this.cityName;
    data['state_name'] = this.stateName;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
