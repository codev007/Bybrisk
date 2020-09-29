class FaqsPojo {
  int id;
  String question;
  String answer;
  String createdAt;
  String ago;

  FaqsPojo({this.id, this.question, this.answer, this.createdAt, this.ago});

  FaqsPojo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    createdAt = json['created_at'];
    ago = json['ago'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['created_at'] = this.createdAt;
    data['ago'] = this.ago;
    return data;
  }
}