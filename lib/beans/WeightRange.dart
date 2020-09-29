class WeightRange {
  String id;
  String ranze;
  List<Weight> weight;

  WeightRange({this.id, this.ranze, this.weight});

  WeightRange.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ranze = json['ranze'];
    if (json['weight'] != null) {
      weight = new List<Weight>();
      json['weight'].forEach((v) {
        weight.add(new Weight.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ranze'] = this.ranze;
    if (this.weight != null) {
      data['weight'] = this.weight.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Weight {
  String weightId;
  String weight;

  Weight({this.weightId, this.weight});

  Weight.fromJson(Map<String, dynamic> json) {
    weightId = json['weight_id'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weight_id'] = this.weightId;
    data['weight'] = this.weight;
    return data;
  }
}