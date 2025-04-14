import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/image_slider.dart';
import '../../services/niaga service/image_slider_service.dart';

part 'image_slider_state.dart';

class ImageSliderCubit extends Cubit<ImageSliderState> {
  final log = getLogger('ImageSliderCubit');

  ImageSliderCubit() : super(ImageSliderInitial());

  Future<dynamic> imageSlider(bool active) async {
    log.i('ImageSliderCubit');
    try {
      emit(ImageSliderInProgress());

      final List<ImageSliderAccesses> response =
          await sl<ImageSliderService>().getImageSlider(active);

      emit(ImageSliderSuccess(response: response));
    } catch (e) {
      log.e('ImageSliderCubit error: $e');
      emit(ImageSliderFailure('$e'));
    }
  }
}
