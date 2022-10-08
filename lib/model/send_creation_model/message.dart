import 'dart:convert';

class Message {
  String? fee;
  String? rawTrx;
  String? reciepient;
  String? status;
  String? value;

  Message({
    this.fee,
    this.rawTrx,
    this.reciepient,
    this.status,
    this.value
  });


  @override
  String toString() {
    return 'Message(value: $value, fee: $fee, rawTrx: $rawTrx, reciepient: $reciepient, status: $status)';
  }

  factory Message.fromMap(Map<String, dynamic> data) => Message(
        fee: data['fee'] as String?,
        rawTrx: data['rawTrx'] as String?,
        reciepient: data['reciepient'] as String?,
        status: data['status'] as String?,
        value: data['value'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'fee': fee,
        'rawTrx': rawTrx,
        'reciepient': reciepient,
        'status': status,
        'value': value,
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
    String? value,
    String? fee,
    String? rawTrx,
    String? reciepient,
    String? status,
  }) {
    return Message(
      value: value ?? this.value,
      fee: fee ?? this.fee,
      rawTrx: rawTrx ?? this.rawTrx,
      reciepient: reciepient ?? this.reciepient,
      status: status ?? this.status,
    );
  }
}
