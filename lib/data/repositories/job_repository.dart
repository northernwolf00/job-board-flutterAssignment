import 'dart:convert';
import 'package:interviews_flutter_assignment/data/jobs_data.dart';
import 'package:interviews_flutter_assignment/data/models/job.dart';


abstract class JobRepository {
  Future<List<Job>> getJobs();
  Future<Job?> getJobById(String id);
  Future<List<Job>> searchJobs(String query);
}

class JobRepositoryImpl implements JobRepository {
  @override
  Future<List<Job>> getJobs() async {
  
    await Future.delayed(const Duration(milliseconds: 500));
    
    final List<dynamic> jsonList = json.decode(mockJobsJson);
    return jsonList.map((json) => Job.fromJson(json)).toList();
  }

  @override
  Future<Job?> getJobById(String id) async {
    final jobs = await getJobs();
    try {
      return jobs.firstWhere((job) => job.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Job>> searchJobs(String query) async {
    final jobs = await getJobs();
    if (query.isEmpty) return jobs;
    
    return jobs.where((job) =>
      job.title.toLowerCase().contains(query.toLowerCase()) ||
      job.company.toLowerCase().contains(query.toLowerCase()) ||
      job.shortDescription.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
