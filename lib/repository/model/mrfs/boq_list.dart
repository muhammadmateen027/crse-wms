class BoqList {
  List<BOQ> boqs;

  BoqList({this.boqs});

  BoqList.fromJson(Map<String, dynamic> json) {
    if (json['success'] != null) {
      boqs = new List<BOQ>();
      json['success'].forEach((v) {
        boqs.add(new BOQ.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.boqs != null) {
      data['success'] = this.boqs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BOQ {
  int id;
  String docNum;

  BOQ({this.id, this.docNum});

  BOQ.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    docNum = json['doc_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doc_num'] = this.docNum;
    return data;
  }
}

