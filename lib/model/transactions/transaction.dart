import 'dart:convert';

import 'package:flutter/material.dart';

class Transaction {
  String? address;
  String? amount;

  String? date;
  String? confirmations;
  String? hash;
  bool? isSend;

  Transaction({
    this.address,
    this.amount,
    this.confirmations,
    this.date,
    this.hash,
    this.isSend,
  });

  factory Transaction.fromMap(Map<String, dynamic> data) => Transaction(
        address: data['address'] as String?,
        amount: data['amount'] as String?,
        date: data['date'] as String?,
        confirmations: (data['confirmations'] as String?) ?? '',
        hash: data['hash'] as String?,
        isSend: data['isSend'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'address': address,
        'confirmations': confirmations,
        'amount': amount,
        'date': date,
        'hash': hash,
        'isSend': isSend,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Transaction].
  factory Transaction.fromJson(String data) {
    return Transaction.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Transaction] to a JSON string.
  String toJson() => json.encode(toMap());

  ///  get the transaction details as a string with its color and other informations
  Map<String, dynamic> getTransactionTypeDetails() {
    Map<String, dynamic> details = {};

    if ((isSend ?? false)) {
      details = {
        'name': 'Send',
        'address': address,
        'icon': Icons.call_made_rounded,
        'color': Colors.blue,
        'identification': 'To' // To or From
      };
    } else {
      details = {
        'name': 'Receive',
        'address': address,
        'icon': Icons.call_received_rounded,
        'color': const Color.fromARGB(255, 0, 0, 0),
        'identification': 'From' // i.e Sending or Recieving
      };
    }

    return details;
  }
}
