import 'dart:io';

abstract class ApplicationEvent {}

class ApplyToJob extends ApplicationEvent {
  final String jobId;
  final File cvFile;

  ApplyToJob(this.jobId, this.cvFile);
}

class LoadApplications extends ApplicationEvent {}

class LoadApplicationsForJob extends ApplicationEvent {
  final String jobId;
  LoadApplicationsForJob(this.jobId);
}

class SyncApplications extends ApplicationEvent {}