class Subscription {
  String renewalDate;
  String expiryDate;
  String name;
  String pricePerDelivery;
  String totalAmount;
  String totalDeliveries;
  String freeReturn;
  String status;

  Subscription(
      {this.renewalDate,
        this.expiryDate,
        this.name,
        this.pricePerDelivery,
        this.totalAmount,
        this.totalDeliveries,
        this.freeReturn,
        this.status});

  Subscription.fromJson(Map<String, dynamic> json) {
    renewalDate = json['renewal_date'];
    expiryDate = json['expiry_date'];
    name = json['name'];
    pricePerDelivery = json['price_per_delivery'];
    totalAmount = json['total_amount'];
    totalDeliveries = json['total_deliveries'];
    freeReturn = json['free_return'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['renewal_date'] = this.renewalDate;
    data['expiry_date'] = this.expiryDate;
    data['name'] = this.name;
    data['price_per_delivery'] = this.pricePerDelivery;
    data['total_amount'] = this.totalAmount;
    data['total_deliveries'] = this.totalDeliveries;
    data['free_return'] = this.freeReturn;
    data['status'] = this.status;
    return data;
  }
}