class StockDetail {
  int reqId;
  int reqStatus;
  String project;
  String document;
  String desc;
  String createdAt;
  String createBy;
  String originName;
  String originCode;
  String originAddress;
  String originZip;
  String originState;
  String destinationName;
  String destinationCode;
  String destinationAddress;
  String destinationZip;
  String destinationState;
  String boqNumber;
  List<Stock> stock;

  StockDetail(
      {this.reqId,
        this.reqStatus,
        this.project,
        this.document,
        this.desc,
        this.createdAt,
        this.createBy,
        this.originName,
        this.originCode,
        this.originAddress,
        this.originZip,
        this.originState,
        this.destinationName,
        this.destinationCode,
        this.destinationAddress,
        this.destinationZip,
        this.destinationState,
        this.boqNumber,
        this.stock});

  StockDetail.fromJson(Map<String, dynamic> json) {
    reqId = json['req_id'];
    reqStatus = json['req_status'];
    project = json['project'];
    document = json['document'];
    desc = json['desc'];
    createdAt = json['created_at'];
    createBy = json['create_by'];
    originName = json['origin_name'];
    originCode = json['origin_code'];
    originAddress = json['origin_address'];
    originZip = json['origin_zip'];
    originState = json['origin_state'];
    destinationName = json['destination_name'];
    destinationCode = json['destination_code'];
    destinationAddress = json['destination_address'];
    destinationZip = json['destination_zip'];
    destinationState = json['destination_state'];
    boqNumber = json['boq_number'];
    if (json['success'] != null) {
      stock = new List<Stock>();
      json['success'].forEach((v) {
        stock.add(new Stock.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['req_id'] = this.reqId;
    data['req_status'] = this.reqStatus;
    data['project'] = this.project;
    data['document'] = this.document;
    data['desc'] = this.desc;
    data['created_at'] = this.createdAt;
    data['create_by'] = this.createBy;
    data['origin_name'] = this.originName;
    data['origin_code'] = this.originCode;
    data['origin_address'] = this.originAddress;
    data['origin_zip'] = this.originZip;
    data['origin_state'] = this.originState;
    data['destination_name'] = this.destinationName;
    data['destination_code'] = this.destinationCode;
    data['destination_address'] = this.destinationAddress;
    data['destination_zip'] = this.destinationZip;
    data['destination_state'] = this.destinationState;
    if (this.stock != null) {
      data['success'] = this.stock.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stock {
  int rid;
  int stockStatus;
  String comment;
  String qty;
  String appQty;
  String appComment;
  String iname;
  String sku;
  String category;
  String unit;
  String added;

  Stock(
      {this.rid,
        this.stockStatus,
        this.comment,
        this.qty,
        this.appQty,
        this.appComment,
        this.iname,
        this.sku,
        this.category,
        this.unit,
        this.added});

  Stock.fromJson(Map<String, dynamic> json) {
    rid = json['rid'];
    stockStatus = json['stock_status'];
    comment = json['comment'];
    qty = json['qty'];
    appQty = json['app_qty'];
    appComment = json['app_comment'];
    iname = json['iname'];
    sku = json['sku'];
    category = json['category'];
    unit = json['unit'];
    added = json['added'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rid'] = this.rid;
    data['stock_status'] = this.stockStatus;
    data['comment'] = this.comment;
    data['qty'] = this.qty;
    data['app_qty'] = this.appQty;
    data['app_comment'] = this.appComment;
    data['iname'] = this.iname;
    data['sku'] = this.sku;
    data['category'] = this.category;
    data['unit'] = this.unit;
    data['added'] = this.added;
    return data;
  }
}

