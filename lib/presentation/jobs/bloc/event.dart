


abstract class JobsEvent {}

class LoadJobs extends JobsEvent {}

class SearchJobs extends JobsEvent {
  final String query;
  SearchJobs(this.query);
}

class RefreshJobs extends JobsEvent {}
