
import 'package:flutter_test/flutter_test.dart';
import 'package:interviews_flutter_assignment/data/models/job.dart';
import 'package:interviews_flutter_assignment/data/repositories/job_repository.dart';

void main() {
  late JobRepositoryImpl repository;

  setUp(() {
    repository = JobRepositoryImpl();
  });

  test('getJobs returns list of jobs', () async {
    final jobs = await repository.getJobs();
    expect(jobs, isA<List<Job>>());
    expect(jobs.isNotEmpty, true);
  });

  test('getJobById returns correct job', () async {
    final jobs = await repository.getJobs();
    final firstJob = jobs.first;

    final job = await repository.getJobById(firstJob.id);
    expect(job?.id, firstJob.id);
  });

  test('searchJobs returns jobs matching query', () async {
    final jobs = await repository.searchJobs('developer');
    expect(jobs.every((job) => job.title.toLowerCase().contains('developer') || job.company.toLowerCase().contains('developer') || job.shortDescription.toLowerCase().contains('developer')), true);
  });

  test('searchJobs returns all jobs when query is empty', () async {
    final jobs = await repository.getJobs();
    final result = await repository.searchJobs('');
    expect(result.length, jobs.length);
  });
}
