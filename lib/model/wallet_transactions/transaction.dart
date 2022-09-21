import 'dart:convert';

import 'package:flutter/material.dart';

class Transaction {
  String? address;
  String? network;
  String? amount;
  String? date;
  String? url;
  String? hash;
  bool? isSend;

  Transaction({
    this.address,
    this.amount,
    this.network,
    this.date,
    this.url,
    this.hash,
    this.isSend,
  });
  Map<String, dynamic> getTransactionTypeDetails() {
    Map<String, dynamic> details = {};

    if (isSend == true) {
      details = {
        'name': 'Send',
        'address': address,
        'icon': Icons.call_made_rounded,
        'color': Colors.blue,
        'identification': 'To' // To or From
      };
    } else if (isSend == false) {
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

  @override
  String toString() {
    return 'Transaction(address: $address, amount: $amount, date: $date, hash: $hash, isSend: $isSend, network: $network,  url: $url)';
  }

  factory Transaction.fromMap(Map<String, dynamic> data) => Transaction(
        address: data['address'] as String?,
        amount: data['amount'] as String?,
        date: data['date'] as String?,
        hash: data['hash'] as String?,
        network: data['network'] as String?,
        url: data['trx_url'] as String?,
        isSend: data['isSend'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'address': address,
        'amount': amount,
        'date': date,
        'network': network,
        'hash': hash,
        'isSend': isSend,
        'trx_url': url,
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

  Transaction copyWith({
    String? address,
    String? amount,
    String? date,
    String? network,
    String? hash,
    bool? isSend,
  }) {
    return Transaction(
      address: address ?? this.address,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      network: network ?? this.network,
      hash: hash ?? this.hash,
      isSend: isSend ?? this.isSend,
    );
  }
}
