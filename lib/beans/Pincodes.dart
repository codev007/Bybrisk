class Pincodes {
  int id;
  String pincode;

  Pincodes({this.id, this.pincode});

  Pincodes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pincode'] = this.pincode;
    return data;
  }
}