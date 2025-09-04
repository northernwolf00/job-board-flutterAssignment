import 'package:interviews_flutter_assignment/core/services/connectivity_service.dart';
import 'package:interviews_flutter_assignment/data/datasources/database_helper.dart';
import '../models/application.dart';


abstract class ApplicationRepository {
  Future<void> saveApplication(Application application);
  Future<List<Application>> getApplications();
  Future<List<Application>> getApplicationsByJobId(String jobId);
  Future<void> syncApplications();
}

class ApplicationRepositoryImpl implements ApplicationRepository {
  final DatabaseHelper _databaseHelper;
  final ConnectivityService _connectivityService;

  ApplicationRepositoryImpl(this._databaseHelper, this._connectivityService);

  @override
  Future<void> saveApplication(Application application) async {
    await _databaseHelper.insertApplication(application);

    if (await _connectivityService.isConnected) {
      await _syncSingleApplication(application);
    }
  }

  @override
  Future<List<Application>> getApplications() async {
    return await _databaseHelper.getApplications();
  }

  @override
  Future<List<Application>> getApplicationsByJobId(String jobId) async {
    return await _databaseHelper.getApplicationsByJobId(jobId);
  }

  @override
  Future<void> syncApplications() async {
    if (!await _connectivityService.isConnected) return;
    
    final unsyncedApplications = await _databaseHelper.getUnsyncedApplications();
    
    for (final application in unsyncedApplications) {
      await _syncSingleApplication(application);
    }
  }

  Future<void> _syncSingleApplication(Application application) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await _databaseHelper.updateApplicationSyncStatus(application.id, true);
    } catch (e) {
      print('Failed to sync application: ${application.id}');
    }
  }
}
