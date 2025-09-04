import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interviews_flutter_assignment/data/repositories/application_repository.dart';
import 'package:interviews_flutter_assignment/domain/usecases/apply_to_job_use_case.dart';
import 'package:interviews_flutter_assignment/domain/usecases/get_applications_use_case.dart';
import 'package:interviews_flutter_assignment/presentation/application/bloc/event.dart';
import 'package:interviews_flutter_assignment/presentation/application/bloc/state.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  final ApplyToJobUseCase _applyToJobUseCase;
  final GetApplicationsUseCase _getApplicationsUseCase;
  final ApplicationRepository _applicationRepository;

  ApplicationBloc(
    this._applyToJobUseCase,
    this._getApplicationsUseCase,
    this._applicationRepository,
  ) : super(ApplicationInitial()) {
    on<ApplyToJob>(_onApplyToJob);
    on<LoadApplications>(_onLoadApplications);
    on<LoadApplicationsForJob>(_onLoadApplicationsForJob);
    on<SyncApplications>(_onSyncApplications);
  }

  Future<void> _onApplyToJob(ApplyToJob event, Emitter<ApplicationState> emit) async {
    emit(ApplicationLoading());
    try {
      await _applyToJobUseCase.execute(event.jobId, event.cvFile);
      emit(ApplicationSuccess('Application submitted successfully!'));
    } catch (e) {
      emit(ApplicationError('Failed to submit application: $e'));
    }
  }

  Future<void> _onLoadApplications(LoadApplications event, Emitter<ApplicationState> emit) async {
    emit(ApplicationLoading());
    try {
      final applications = await _getApplicationsUseCase.execute();
      emit(ApplicationsLoaded(applications));
    } catch (e) {
      emit(ApplicationError('Failed to load applications: $e'));
    }
  }

  Future<void> _onLoadApplicationsForJob(LoadApplicationsForJob event, Emitter<ApplicationState> emit) async {
    emit(ApplicationLoading());
    try {
      final applications = await _getApplicationsUseCase.executeForJob(event.jobId);
      emit(ApplicationsLoaded(applications));
    } catch (e) {
      emit(ApplicationError('Failed to load applications: $e'));
    }
  }

  Future<void> _onSyncApplications(SyncApplications event, Emitter<ApplicationState> emit) async {
    try {
      await _applicationRepository.syncApplications();
    } catch (e) {
      // Sync errors are handled silently or shown as toast
    }
  }
}