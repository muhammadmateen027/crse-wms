class Stocks {
  List<StockInfo> stockList;

  Stocks({this.stockList});

  Stocks.fromJson(Map<String, dynamic> json) {
    if (json['success'] != null) {
      stockList = new List<StockInfo>();
      json['success'].forEach((v) {
        stockList.add(new StockInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stockList != null) {
      data['success'] = this.stockList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StockInfo {
  int isid;
  String iname;
  String skuno;
  String total;
  String crsePn;

  StockInfo({this.isid, this.iname, this.skuno, this.total, this.crsePn});

  StockInfo.fromJson(Map<String, dynamic> json) {
    isid = json['isid'];
    iname = json['iname'];
    skuno = json['skuno'];
    total = json['total'];
    crsePn = json['crse_pn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isid'] = this.isid;
    data['iname'] = this.iname;
    data['skuno'] = this.skuno;
    data['total'] = this.total;
    data['crse_pn'] = this.crsePn;
    return data;
  }
}

