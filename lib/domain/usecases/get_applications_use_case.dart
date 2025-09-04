import 'package:interviews_flutter_assignment/data/models/application.dart';
import 'package:interviews_flutter_assignment/data/repositories/application_repository.dart';

class GetApplicationsUseCase {
  final ApplicationRepository _repository;

  GetApplicationsUseCase(this._repository);

  Future<List<Application>> execute() async {
    return await _repository.getApplications();
  }

  Future<List<Application>> executeForJob(String jobId) async {
    return await _repository.getApplicationsByJobId(jobId);
  }
}