import 'dart:convert';

import 'transaction.dart';

class WalletTransactions {
  List<Transaction>? transactions;

  WalletTransactions({this.transactions});

  @override
  String toString() => 'WalletTransactions(transactions: $transactions)';

  factory WalletTransactions.fromMap(Map<String, dynamic> data, bool isKeyTrx) {
    return WalletTransactions(
      transactions: ((data['trxs'] ?? data['transactions']) as List<dynamic>?)
          ?.map((e) => Transaction.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'transactions': transactions?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [WalletTransactions].
  factory WalletTransactions.fromJson(String data, bool isKeyTrx) {
    return WalletTransactions.fromMap(
        json.decode(data) as Map<String, dynamic>, isKeyTrx);
  }

  /// `dart:convert`
  ///
  /// Converts [WalletTransactions] to a JSON string.
  String toJson() => json.encode(toMap());

  WalletTransactions copyWith({
    List<Transaction>? transactions,
  }) {
    return WalletTransactions(
      transactions: transactions ?? this.transactions,
    );
  }
}
