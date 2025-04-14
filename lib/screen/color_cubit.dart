import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:niaga_apps_mobile/packing/packing_list.dart';

class ColorCubit extends Cubit<Color> {
  ColorCubit() : super(Colors.red); // Initial color

  void updateColor(Color color) {
    emit(color);
  }
}
