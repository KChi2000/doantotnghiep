import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Candidates {
  String candidate;
  int sdpMLineIndex;
  String sdpMid;
  Candidates({
    required this.candidate,
    required this.sdpMLineIndex,
    required this.sdpMid,
  });
  

  Candidates copyWith({
    String? candidate,
    int? sdpMLineIndex,
    String? sdpMid,
  }) {
    return Candidates(
      candidate: candidate ?? this.candidate,
      sdpMLineIndex: sdpMLineIndex ?? this.sdpMLineIndex,
      sdpMid: sdpMid ?? this.sdpMid,
    );
  }

  @override
  String toString() => 'Candidates(candidate: $candidate, sdpMLineIndex: $sdpMLineIndex, sdpMid: $sdpMid)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'candidate': candidate,
      'sdpMLineIndex': sdpMLineIndex,
      'sdpMid': sdpMid,
    };
  }

  factory Candidates.fromMap(Map<String, dynamic> map) {
    return Candidates(
      candidate: map['candidate'] as String,
      sdpMLineIndex: map['sdpMLineIndex'] as int,
      sdpMid: map['sdpMid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Candidates.fromJson(String source) => Candidates.fromMap(json.decode(source) as Map<String, dynamic>);
}
