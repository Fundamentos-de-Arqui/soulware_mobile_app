class SessionModel {
  final int id;
  final String therapistName;
  final String patientName;
  final String legalResponsibleName;
  final String startAt;
  final String endsAt;
  final String status;

  SessionModel({
    required this.id,
    required this.therapistName,
    required this.patientName,
    required this.legalResponsibleName,
    required this.startAt,
    required this.endsAt,
    required this.status,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'],
      therapistName: json['therapist_name'],
      patientName: json['patient_name'],
      legalResponsibleName: json['legal_responsible_name'],
      startAt: json['start_at'],   // <-- ahora String
      endsAt: json['ends_at'],     // <-- ahora String
      status: json['status'],
    );
  }
}
