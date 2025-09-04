
import 'package:interviews_flutter_assignment/data/models/job.dart';

abstract class JobsState {}

class JobsInitial extends JobsState {}

class JobsLoading extends JobsState {}

class JobsLoaded extends JobsState {
  final List<Job> jobs;
  final String searchQuery;

  JobsLoaded(this.jobs, {this.searchQuery = ''});
}

class JobsError extends JobsState {
  final String message;
  JobsError(this.message);
}