import 'package:intl/intl.dart';

class OrderDetail {
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
  List<Stock> stocks;

  OrderDetail(
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
        this.stocks});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    json = null == json ? {} : json;
    reqId = json.putIfAbsent('req_id', () => null);
    reqStatus = json.putIfAbsent('req_status', () => null);
    project = json.putIfAbsent('project', () => null);
    document = json.putIfAbsent('document', () => null);
    desc = json.putIfAbsent('desc', () => null);
    createdAt = json.putIfAbsent('created_at', () => null);
    createBy = json.putIfAbsent('create_by', () => null);
    originName = json.putIfAbsent('origin_name', () => null);
    originCode = json.putIfAbsent('origin_code', () => null);
    originAddress = json.putIfAbsent('origin_address', () => null);
    originZip = json.putIfAbsent('origin_zip', () => null);
    originState = json.putIfAbsent('origin_state', () => null);
    destinationName = json.putIfAbsent('destination_name', () => null);
    destinationCode = json.putIfAbsent('destination_code', () => null);
    destinationAddress = json.putIfAbsent('destination_address', () => null);
    destinationZip = json.putIfAbsent('destination_zip', () => null);
    destinationState = json.putIfAbsent('destination_state', () => null);
    if (json.putIfAbsent('success', () => null) != null) {
      stocks = new List<Stock>();
      json.putIfAbsent('success', () => null).forEach((v) {
        stocks.add(new Stock.fromJson(v));
      });
    }
  }

  String formatDateTime() {
    if (this.createdAt?.isEmpty ?? true) {
      return '';
    }

    return new DateFormat('yyyy-MM-dd HH:mm').format(
      DateTime.parse(this.createdAt).toLocal(),
    );
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
    if (this.stocks != null) {
      data['success'] = this.stocks.map((v) => v.toJson()).toList();
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
    json = null == json ? {} : json;
    rid = json.putIfAbsent('rid', () => null);
    stockStatus = json.putIfAbsent('stock_status', () => null);
    comment = json.putIfAbsent('comment', () => null);
    qty = json.putIfAbsent('qty', () => null);
    appQty = json.putIfAbsent('app_qty', () => null);
    appComment = json.putIfAbsent('app_comment', () => null);
    iname = json.putIfAbsent('iname', () => null);
    sku = json.putIfAbsent('sku', () => null);
    category = json.putIfAbsent('category', () => null);
    unit = json.putIfAbsent('unit', () => null);
    added = json.putIfAbsent('added', () => null);
  }

  String formatDateTime() {
    if (this.added?.isEmpty ?? true) {
      return '';
    }

    return new DateFormat('yyyy-MM-dd HH:mm').format(
      DateTime.parse(this.added).toLocal(),
    );
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
