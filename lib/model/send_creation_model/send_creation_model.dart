import 'dart:convert';

class SendCreationModel {
  String? fee;
  String? rawTrx;
  String? reciepient;

  String? status;
  String? value;

  SendCreationModel(
      {this.fee, this.rawTrx, this.reciepient, this.status, this.value});

  @override
  String toString() {
    return 'SendCreationModel(value: $value, fee: $fee, rawTrx: $rawTrx, reciepient: $reciepient, status: $status)';
  }

  factory SendCreationModel.fromMap(Map<String, dynamic> data) =>
      SendCreationModel(
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
  factory SendCreationModel.fromJson(String data) {
    return SendCreationModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Message] to a JSON string.
  String toJson() => json.encode(toMap());

  SendCreationModel copyWith({
    String? value,
    String? fee,
    String? rawTrx,
    String? reciepient,
    String? status,
  }) {
    return SendCreationModel(
      value: value ?? this.value,
      fee: fee ?? this.fee,
      rawTrx: rawTrx ?? this.rawTrx,
      reciepient: reciepient ?? this.reciepient,
      status: status ?? this.status,
    );
  }
}
