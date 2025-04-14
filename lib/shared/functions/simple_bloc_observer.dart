import 'package:bloc/bloc.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

class SimpleBlocObserver extends BlocObserver {
  final log = getLogger('SimpleBlocObserver');

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log.d(transition);
  }
}
