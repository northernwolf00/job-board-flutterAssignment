

import 'package:interviews_flutter_assignment/data/models/job.dart';
import 'package:interviews_flutter_assignment/data/repositories/job_repository.dart';

class GetJobsUseCase {
  final JobRepository _repository;

  GetJobsUseCase(this._repository);

  Future<List<Job>> execute() async {
    return await _repository.getJobs();
  }
}