
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:interviews_flutter_assignment/data/models/application.dart';
import 'package:interviews_flutter_assignment/data/repositories/application_repository.dart';
import 'mocks.mocks.dart';

void main() {
  late ApplicationRepositoryImpl repository;
  late MockDatabaseHelper mockDatabaseHelper;
  late MockConnectivityService mockConnectivityService;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    mockConnectivityService = MockConnectivityService();
    repository = ApplicationRepositoryImpl(mockDatabaseHelper, mockConnectivityService);
  });

 final application = Application(
  id: '1',
  jobId: 'job1',
  candidateName: 'Googa dev',
  candidateEmail: 'admin@example.com',
  candidatePhone: '123456789',
  cvPath: '/path/to/cv.pdf',
  appliedAt: DateTime.now(),
  synced: false,
);


  test('saveApplication calls insert and sync when online', () async {
    when(mockConnectivityService.isConnected).thenAnswer((_) async => true);
    when(mockDatabaseHelper.insertApplication(application)).thenAnswer((_) async {});
    when(mockDatabaseHelper.updateApplicationSyncStatus(application.id, true)).thenAnswer((_) async {});

    await repository.saveApplication(application);

    verify(mockDatabaseHelper.insertApplication(application)).called(1);
    verify(mockDatabaseHelper.updateApplicationSyncStatus(application.id, true)).called(1);
  });

  test('saveApplication calls insert but not sync when offline', () async {
    when(mockConnectivityService.isConnected).thenAnswer((_) async => false);
    when(mockDatabaseHelper.insertApplication(application)).thenAnswer((_) async {});

    await repository.saveApplication(application);

    verify(mockDatabaseHelper.insertApplication(application)).called(1);
    verifyNever(mockDatabaseHelper.updateApplicationSyncStatus(application.id, true));
  });

  test('getApplications returns list from database', () async {
    when(mockDatabaseHelper.getApplications()).thenAnswer((_) async => [application]);

    final apps = await repository.getApplications();

    expect(apps, [application]);
  });
}
