class Stateinfo {
  bool? result;
  String? message;
  List<States>? states;

  Stateinfo({this.result, this.message, this.states});

  Stateinfo.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['states'] != null) {
      states = <States>[];
      json['states'].forEach((v) {
        states!.add(new States.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.states != null) {
      data['states'] = this.states!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class States {
  int? id;
  int? cityId;
  String? stateName;
  String? createdAt;
  String? updatedAt;

  States(
      {this.id, this.cityId, this.stateName, this.createdAt, this.updatedAt});

  States.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cityId = json['city_id'];
    stateName = json['state_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city_id'] = this.cityId;
    data['state_name'] = this.stateName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
