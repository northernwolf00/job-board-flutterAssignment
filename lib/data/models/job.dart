class Job {
  final String id;
  final String title;
  final String company;
  final String shortDescription;
  final String fullDescription;
  final String location;
  final String salary;
  final JobStatus status;
  final DateTime createdAt;
  final List<String> requirements;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.shortDescription,
    required this.fullDescription,
    required this.location,
    required this.salary,
    required this.status,
    required this.createdAt,
    required this.requirements,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      shortDescription: json['shortDescription'],
      fullDescription: json['fullDescription'],
      location: json['location'],
      salary: json['salary'],
      status: JobStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => JobStatus.open,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      requirements: List<String>.from(json['requirements']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'shortDescription': shortDescription,
      'fullDescription': fullDescription,
      'location': location,
      'salary': salary,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'requirements': requirements,
    };
  }
}

enum JobStatus { open, closed }
