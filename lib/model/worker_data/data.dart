import 'dart:convert';

import 'package:collection/collection.dart';

import 'sub_worker.dart';

class Data {
  double? cumEarnings;
  double? earningsPaid;
  double? estEarnings;
  double? hash10min;
  double? hash1day;
  double? hash1hr;
  int? minersActive;
  int? minersAll;
  double? sharesInvalid;
  double? sharesStale;
  double? sharesValid;
  List? hashList;
  List<SubWorker>? subWorkers;

  Data({
    this.cumEarnings,
    this.earningsPaid,
    this.estEarnings,
    this.hash10min,
    this.hash1day,
    this.hash1hr,
    this.minersActive,
    this.minersAll,
    this.sharesInvalid,
    this.sharesStale,
    this.sharesValid,
    this.hashList,
    this.subWorkers,
  });

  @override
  String toString() {
    return 'Data(cumEarnings: $cumEarnings, earningsPaid: $earningsPaid, estEarnings: $estEarnings, hash10min: $hash10min, hash1day: $hash1day, hash1hr: $hash1hr, minersActive: $minersActive,'
        ' minersAll: $minersAll, sharesInvalid: $sharesInvalid, sharesStale: $sharesStale, sharesValid: $sharesValid, hashList: $hashList, subWorkers: $subWorkers)';
  }

  factory Data.fromMap(Map<String, dynamic> data) => Data(
        cumEarnings: (data['cum_earnings'] as num?)?.toDouble(),
        earningsPaid: (data['earnings_paid'] as num?)?.toDouble(),
        estEarnings: (data['est_earnings'] as num?)?.toDouble(),
        hash10min: (data['hash_10min'] as num?)?.toDouble(),
        hash1day: (data['hash_1day'] as num?)?.toDouble(),
        hash1hr: (data['hash_1hr'] as num?)?.toDouble(),
        minersActive: (data['miners_active'] as int?),
        minersAll: (data['miners_all'] as int?),
        sharesInvalid: (data['shares_invalid'] as num?)?.toDouble(),
        sharesStale: (data['shares_stale'] as num?)?.toDouble(),
        sharesValid: (data['shares_valid'] as num?)?.toDouble(),
        hashList: (data['hash_list'] as List?)?.toList(),
        subWorkers: (data['sub_workers'] as List<dynamic>?)
            ?.map((e) => SubWorker.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'cum_earnings': cumEarnings,
        'earnings_paid': earningsPaid,
        'est_earnings': estEarnings,
        'hash_10min': hash10min,
        'hash_1day': hash1day,
        'hash_1hr': hash1hr,
        'miners_active': minersActive,
        'miners_all': minersAll,
        'shares_invalid': sharesInvalid,
        'shares_stale': sharesStale,
        'shares_valid': sharesValid,
        'hash_list': hashList,
        'sub_workers': subWorkers?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory Data.fromJson(String data) {
    return Data.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
  String toJson() => json.encode(toMap());

  Data copyWith({
    double? cumEarnings,
    double? earningsPaid,
    double? estEarnings,
    double? hash10min,
    double? hash1day,
    double? hash1hr,
    int? minersActive,
    int? minersAll,
    double? sharesInvalid,
    double? sharesStale,
    double? sharesValid,
    List? hashList,
    List<SubWorker>? subWorkers,
  }) {
    return Data(
      cumEarnings: cumEarnings ?? this.cumEarnings,
      earningsPaid: earningsPaid ?? this.earningsPaid,
      estEarnings: estEarnings ?? this.estEarnings,
      hash10min: hash10min ?? this.hash10min,
      hash1day: hash1day ?? this.hash1day,
      hash1hr: hash1hr ?? this.hash1hr,
      minersActive: minersActive ?? this.minersActive,
      minersAll: minersAll ?? this.minersAll,
      sharesInvalid: sharesInvalid ?? this.sharesInvalid,
      sharesStale: sharesStale ?? this.sharesStale,
      sharesValid: sharesValid ?? this.sharesValid,
      hashList: hashList ?? this.hashList,
      subWorkers: subWorkers ?? this.subWorkers,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Data) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toMap(), toMap());
  }

  @override
  int get hashCode =>
      cumEarnings.hashCode ^
      earningsPaid.hashCode ^
      estEarnings.hashCode ^
      hash10min.hashCode ^
      hash1day.hashCode ^
      hash1hr.hashCode ^
      minersActive.hashCode ^
      minersAll.hashCode ^
      sharesInvalid.hashCode ^
      sharesStale.hashCode ^
      sharesValid.hashCode ^
      hashList.hashCode ^
      subWorkers.hashCode;
}
