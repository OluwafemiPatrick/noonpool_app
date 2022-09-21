import 'dart:convert';

class Message {
  String? amount;
  String? fee;
  String? rawTrx;
  String? reciepient;
  String? status;

  Message({
    this.amount,
    this.fee,
    this.rawTrx,
    this.reciepient,
    this.status,
  });

  @override
  String toString() {
    return 'Message(amount: $amount, fee: $fee, rawTrx: $rawTrx, reciepient: $reciepient, status: $status)';
  }

  factory Message.fromMap(Map<String, dynamic> data) => Message(
        amount: data['amount'] as String?,
        fee: data['fee'] as String?,
        rawTrx: data['rawTrx'] as String?,
        reciepient: data['reciepient'] as String?,
        status: data['status'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'amount': amount,
        'fee': fee,
        'rawTrx': rawTrx,
        'reciepient': reciepient,
        'status': status,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Message].
  factory Message.fromJson(String data) {
    return Message.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Message] to a JSON string.
  String toJson() => json.encode(toMap());

  Message copyWith({
    String? amount,
    String? fee,
    String? rawTrx,
    String? reciepient,
    String? status,
  }) {
    return Message(
      amount: amount ?? this.amount,
      fee: fee ?? this.fee,
      rawTrx: rawTrx ?? this.rawTrx,
      reciepient: reciepient ?? this.reciepient,
      status: status ?? this.status,
    );
  }
}
