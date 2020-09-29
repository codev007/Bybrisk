class DeliveryPojo {
  String id;
  String orderId;
  String pincode;
  String address;
  String cOD;
  String mobile;
  String date;
  String time;
  String status;
  String name;
  String ago;

  DeliveryPojo(
      {this.id,
        this.orderId,
        this.pincode,
        this.address,
        this.cOD,
        this.mobile,
        this.date,
        this.time,
        this.status,
        this.name,
        this.ago});

  DeliveryPojo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    pincode = json['pincode'];
    address = json['address'];
    cOD = json['COD'];
    mobile = json['mobile'];
    date = json['date'];
    time = json['time'];
    status = json['status'];
    name = json['name'];
    ago = json['ago'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['pincode'] = this.pincode;
    data['address'] = this.address;
    data['COD'] = this.cOD;
    data['mobile'] = this.mobile;
    data['date'] = this.date;
    data['time'] = this.time;
    data['status'] = this.status;
    data['name'] = this.name;
    data['ago'] = this.ago;
    return data;
  }
}