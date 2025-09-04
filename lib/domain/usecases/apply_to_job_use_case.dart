import 'dart:io';

import 'package:interviews_flutter_assignment/core/services/cv_parser_service.dart';
import 'package:interviews_flutter_assignment/data/models/application.dart';
import 'package:interviews_flutter_assignment/data/repositories/application_repository.dart';

class ApplyToJobUseCase {
  final ApplicationRepository _repository;
  final CVParserService _cvParserService;

  ApplyToJobUseCase(this._repository, this._cvParserService);

  Future<void> execute(String jobId, File cvFile) async {
    final cvInfo = await _cvParserService.parseCVFromFile(cvFile);

    final application = Application(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      jobId: jobId,
      candidateName: cvInfo['name'] ?? 'Unknown',
      candidateEmail: cvInfo['email'] ?? '',
      candidatePhone: cvInfo['phone'] ?? '',
      cvPath: cvFile.path,
      appliedAt: DateTime.now(),
    );

    await _repository.saveApplication(application);
  }
}
