// test/mocks.dart
import 'package:mockito/annotations.dart';
import 'package:interviews_flutter_assignment/core/services/connectivity_service.dart';
import 'package:interviews_flutter_assignment/data/datasources/database_helper.dart';

@GenerateMocks([DatabaseHelper, ConnectivityService])
void main() {}
