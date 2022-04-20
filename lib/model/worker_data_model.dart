class WorkerDataModel {
  String? workerId;
  String? hashrate;
  String? sharesValid;
  String? sharesInvalid;
  String? sharesStale;
  String? payBalance;
  String? payGenerate;
  String? payImmature;
  String? payPaid;
  String? work;

  WorkerDataModel({
    this.workerId,
    this.hashrate,
    this.sharesValid,
    this.sharesInvalid,
    this.sharesStale,
    this.payBalance,
    this.payGenerate,
    this.payImmature,
    this.payPaid,
    this.work
  });

  WorkerDataModel.fromJson(Map<String, dynamic> json) {
    workerId = json['hashrate']['shared'].toString();
    hashrate = json['hashrate']['shared'].toString();
    sharesValid = json['shares']['shared']['valid'].toString();
    sharesInvalid = json['shares']['shared']['invalid'].toString();
    sharesStale = json['shares']['shared']['stale'].toString();
    payBalance = json['payments']['balances'].toString();
    payGenerate = json['payments']['generate'].toString();
    payImmature = json['payments']['immature'].toString();
    payPaid = json['payments']['paid'].toString();
    work = json['work']['shared'].toString();
  }
}