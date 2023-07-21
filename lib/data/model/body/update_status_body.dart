class UpdateStatusBody {
  String? token;
  int? orderId;
  String? status;
  String? otp;
  String? processingTime;
  String method = 'put';
  String? reason;

  UpdateStatusBody({this.token, this.orderId, this.status, this.otp, this.processingTime, this.reason});

  UpdateStatusBody.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    orderId = json['order_id'];
    status = json['status'];
    otp = json['otp'];
    processingTime = json['processing_time'];
    status = json['_method'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['order_id'] = orderId;
    data['status'] = status;
    data['otp'] = otp;
    data['processing_time'] = processingTime;
    data['_method'] = method;
    if(reason != '') {
      data['reason'] = reason;
    }
    return data;
  }
}