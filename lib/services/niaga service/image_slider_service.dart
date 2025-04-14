
import '../../model/niaga/image_slider.dart';

abstract class ImageSliderService {
  Future<List<ImageSliderAccesses>> getImageSlider(bool active);
}
