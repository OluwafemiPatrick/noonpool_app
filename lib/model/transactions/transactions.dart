import 'dart:convert';

import 'transaction.dart';

class Transactions {
  List<Transaction>? transactions;

  Transactions({this.transactions});

  factory Transactions.fromMap(Map<String, dynamic> data) => Transactions(
        transactions: (data['transactions'] as List<dynamic>?)
            ?.map((e) => Transaction.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'transactions': transactions?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Transactions].
  factory Transactions.fromJson(String data) {
    return Transactions.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Transactions] to a JSON string.
  String toJson() => json.encode(toMap());
}
