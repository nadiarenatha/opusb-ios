part of 'image_slider_cubit.dart';

abstract class ImageSliderState extends Equatable {
  const ImageSliderState();

  @override
  List<Object> get props => [];
}

class ImageSliderInitial extends ImageSliderState {}

class ImageSliderSuccess extends ImageSliderState {
  final List<ImageSliderAccesses> response;

  const ImageSliderSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [response];
}

class ImageSliderInProgress extends ImageSliderState {}

class ImageSliderFailure extends ImageSliderState {
  final String message;

  const ImageSliderFailure(this.message);

  @override
  List<Object> get props => [message];
}
