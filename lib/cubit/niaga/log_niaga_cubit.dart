// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:niaga_apps_mobile/servicelocator.dart';
// import 'package:niaga_apps_mobile/shared/widget/logger.dart';
// import '../../model/niaga/log_niaga.dart';
// import '../../services/niaga service/log_niaga_service.dart';

// part 'log_niaga_state.dart';

// class LogNiagaCubit extends Cubit<LogNiagaState> {
//   final log = getLogger('LogNiagaCubit');

//   LogNiagaCubit() : super(LogNiagaInitial());

//   Future<void> logNiaga(String actionUrl) async {
//     log.i('LogNiagaCubit');
//     try {
//       emit(LogNiagaInProgress()); 

//       // final sysdate =
//       //     DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

//       final LogNiagaAccesses response =
//           await sl<LogNiagaService>().logNiaga(actionUrl);

//       emit(LogNiagaSuccess(response: response));
//     } catch (e) {
//       log.e('LogNiagaCubit error: $e');
//       emit(LogNiagaFailure('$e'));
//     }
//   }
// }
