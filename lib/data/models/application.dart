class Application {
  final String id;
  final String jobId;
  final String candidateName;
  final String candidateEmail;
  final String candidatePhone;
  final String cvPath;
  final DateTime appliedAt;
  final bool synced;

  Application({
    required this.id,
    required this.jobId,
    required this.candidateName,
    required this.candidateEmail,
    required this.candidatePhone,
    required this.cvPath,
    required this.appliedAt,
    this.synced = false,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'],
      jobId: json['jobId'],
      candidateName: json['candidateName'],
      candidateEmail: json['candidateEmail'],
      candidatePhone: json['candidatePhone'],
      cvPath: json['cvPath'],
      appliedAt: DateTime.parse(json['appliedAt']),
      synced: json['synced'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'candidateName': candidateName,
      'candidateEmail': candidateEmail,
      'candidatePhone': candidatePhone,
      'cvPath': cvPath,
      'appliedAt': appliedAt.toIso8601String(),
      'synced': synced ? 1 : 0,
    };
  }

  Application copyWith({
    String? id,
    String? jobId,
    String? candidateName,
    String? candidateEmail,
    String? candidatePhone,
    String? cvPath,
    DateTime? appliedAt,
    bool? synced,
  }) {
    return Application(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      candidateName: candidateName ?? this.candidateName,
      candidateEmail: candidateEmail ?? this.candidateEmail,
      candidatePhone: candidatePhone ?? this.candidatePhone,
      cvPath: cvPath ?? this.cvPath,
      appliedAt: appliedAt ?? this.appliedAt,
      synced: synced ?? this.synced,
    );
  }
}