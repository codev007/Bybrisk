class Plans {
  String plansId;
  String name;
  String pricePerDelivery;
  String totalAmount;
  String totalDeliveries;
  String freeReturn;

  Plans(
      {this.plansId,
        this.name,
        this.pricePerDelivery,
        this.totalAmount,
        this.totalDeliveries,
        this.freeReturn});

  Plans.fromJson(Map<String, dynamic> json) {
    plansId = json['plans_id'];
    name = json['name'];
    pricePerDelivery = json['price_per_delivery'];
    totalAmount = json['total_amount'];
    totalDeliveries = json['total_deliveries'];
    freeReturn = json['free_return'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plans_id'] = this.plansId;
    data['name'] = this.name;
    data['price_per_delivery'] = this.pricePerDelivery;
    data['total_amount'] = this.totalAmount;
    data['total_deliveries'] = this.totalDeliveries;
    data['free_return'] = this.freeReturn;
    return data;
  }
}