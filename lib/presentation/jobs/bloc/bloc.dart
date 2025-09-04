import 'package:bloc/bloc.dart';
import 'package:interviews_flutter_assignment/domain/usecases/get_jobs_use_case.dart';
import 'package:interviews_flutter_assignment/domain/usecases/search_jobs_use_case.dart';
import 'package:interviews_flutter_assignment/presentation/jobs/bloc/event.dart';
import 'package:interviews_flutter_assignment/presentation/jobs/bloc/state.dart';

class JobsBloc extends Bloc<JobsEvent, JobsState> {
  final GetJobsUseCase _getJobsUseCase;
  final SearchJobsUseCase _searchJobsUseCase;

  JobsBloc(this._getJobsUseCase, this._searchJobsUseCase) : super(JobsInitial()) {
    on<LoadJobs>(_onLoadJobs);
    on<SearchJobs>(_onSearchJobs);
    on<RefreshJobs>(_onRefreshJobs);
  }

  Future<void> _onLoadJobs(LoadJobs event, Emitter<JobsState> emit) async {
    emit(JobsLoading());
    try {
      final jobs = await _getJobsUseCase.execute();
      emit(JobsLoaded(jobs));
    } catch (e) {
      emit(JobsError('Failed to load jobs: $e'));
    }
  }

  Future<void> _onSearchJobs(SearchJobs event, Emitter<JobsState> emit) async {
    emit(JobsLoading());
    try {
      final jobs = await _searchJobsUseCase.execute(event.query);
      emit(JobsLoaded(jobs, searchQuery: event.query));
    } catch (e) {
      emit(JobsError('Failed to search jobs: $e'));
    }
  }

  Future<void> _onRefreshJobs(RefreshJobs event, Emitter<JobsState> emit) async {
    try {
      final jobs = await _getJobsUseCase.execute();
      emit(JobsLoaded(jobs));
    } catch (e) {
      emit(JobsError('Failed to refresh jobs: $e'));
    }
  }
}
