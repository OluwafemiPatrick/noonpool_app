import 'dart:convert';

import 'package:collection/collection.dart';

class SubWorker {
  double? estEarning;
  double? hashrate;
  String? stat;
  String? workerId;

  SubWorker({this.estEarning, this.hashrate, this.stat, this.workerId});

  @override
  String toString() {
    return 'SubWorker(estEarning: $estEarning, hashrate: $hashrate, stat: $stat, workerId: $workerId)';
  }

  factory SubWorker.fromMap(Map<String, dynamic> data) => SubWorker(
        estEarning: (data['est_earnings'] as num?)?.toDouble(),
        hashrate: (data['hashrate'] as num?)?.toDouble(),
        stat: data['stat'] as String?,
        workerId: data['worker_id'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'est_earning': estEarning,
        'hashrate': hashrate,
        'stat': stat,
        'worker_id': workerId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SubWorker].
  factory SubWorker.fromJson(String data) {
    return SubWorker.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SubWorker] to a JSON string.
  String toJson() => json.encode(toMap());

  SubWorker copyWith({
    double? estEarning,
    double? hashrate,
    String? stat,
    String? workerId,
  }) {
    return SubWorker(
      estEarning: estEarning ?? this.estEarning,
      hashrate: hashrate ?? this.hashrate,
      stat: stat ?? this.stat,
      workerId: workerId ?? this.workerId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! SubWorker) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      estEarning.hashCode ^
      hashrate.hashCode ^
      stat.hashCode ^
      workerId.hashCode;
}
