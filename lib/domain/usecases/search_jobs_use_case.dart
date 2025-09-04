import 'package:interviews_flutter_assignment/data/models/job.dart';
import 'package:interviews_flutter_assignment/data/repositories/job_repository.dart';

class SearchJobsUseCase {
  final JobRepository _repository;

  SearchJobsUseCase(this._repository);

  Future<List<Job>> execute(String query) async {
    return await _repository.searchJobs(query);
  }
}