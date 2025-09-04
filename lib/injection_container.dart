import 'package:get_it/get_it.dart';
import 'package:interviews_flutter_assignment/core/services/connectivity_service.dart';
import 'package:interviews_flutter_assignment/core/services/cv_parser_service.dart';
import 'package:interviews_flutter_assignment/core/services/python_cv_service.dart';
import 'package:interviews_flutter_assignment/core/utils/auth_preferences.dart';
import 'package:interviews_flutter_assignment/data/datasources/database_helper.dart';
import 'package:interviews_flutter_assignment/data/repositories/application_repository.dart';
import 'package:interviews_flutter_assignment/data/repositories/job_repository.dart';
import 'package:interviews_flutter_assignment/domain/usecases/apply_to_job_use_case.dart';
import 'package:interviews_flutter_assignment/domain/usecases/get_applications_use_case.dart';
import 'package:interviews_flutter_assignment/domain/usecases/get_jobs_use_case.dart';
import 'package:interviews_flutter_assignment/domain/usecases/search_jobs_use_case.dart';
import 'package:interviews_flutter_assignment/presentation/application/bloc/bloc.dart' show ApplicationBloc;
import 'package:interviews_flutter_assignment/presentation/auth/bloc/bloc.dart';
import 'package:interviews_flutter_assignment/presentation/jobs/bloc/bloc.dart';


final sl = GetIt.instance;

Future<void> init() async {

  sl.registerLazySingleton(() => DatabaseHelper());
  sl.registerLazySingleton(() => CVParserService());
  sl.registerLazySingleton(() => ConnectivityService());
  sl.registerLazySingleton(() => AuthPreferences());
  sl.registerLazySingleton(() => PythonCVService());


  sl.registerLazySingleton<JobRepository>(() => JobRepositoryImpl());
  sl.registerLazySingleton<ApplicationRepository>(
    () => ApplicationRepositoryImpl(sl(), sl()),
  );

  
  sl.registerLazySingleton(() => GetJobsUseCase(sl()));
  sl.registerLazySingleton(() => SearchJobsUseCase(sl()));
  sl.registerLazySingleton(() => ApplyToJobUseCase(sl(), sl()));
  sl.registerLazySingleton(() => GetApplicationsUseCase(sl()));


  sl.registerFactory(() => JobsBloc(sl(), sl()));
  sl.registerFactory(() => ApplicationBloc(sl(), sl(), sl()));
  sl.registerLazySingleton(() => AuthBloc());
}