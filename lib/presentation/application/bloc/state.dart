import 'package:interviews_flutter_assignment/data/models/application.dart';

abstract class ApplicationState {}

class ApplicationInitial extends ApplicationState {}

class ApplicationLoading extends ApplicationState {}

class ApplicationSuccess extends ApplicationState {
  final String message;
  ApplicationSuccess(this.message);
}

// class ApplicationsLoaded extends ApplicationState {
//   final List<Application> applications;
//   ApplicationsLoaded(this.applications);
// }

class ApplicationError extends ApplicationState {
  final String message;
  ApplicationError(this.message);
}

class ApplicationsLoaded extends ApplicationState {
  final List<Application> applications;

  ApplicationsLoaded(this.applications);

  List<String> get appliedJobIds =>
      applications.map((a) => a.jobId).toList();
}
