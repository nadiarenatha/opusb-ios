import 'package:flutter/material.dart';

Color white = Colors.white;
Color black = Colors.black;
Color blueOceanTheme = Color(0xFF3172FD);
Color greyBackground = const Color(0xD5FFF7F7);
Color mainColor = Color.fromRGBO(72, 148, 204, 5);
Color backgroundColor = Color.fromRGBO(229, 245, 252, 5);
Color purewhiteTheme = Colors.white;
Color buttonsubmitColor = Color.fromRGBO(169, 214, 127, 10);
Color iconColor = Color.fromRGBO(255, 255, 255, .3);
Color themeswatch = Color.fromRGBO(0, 173, 239, 5);
Color pureblackTheme = Colors.black;

//  #0D5CAB
Color blue = const Color.fromRGBO(13, 92, 171, 1);
//  #1270B0
Color blueIsActive = const Color.fromRGBO(18, 112, 176, 1);
//  #ED302A
Color red = const Color.fromRGBO(237, 48, 42, 1);
//  #FF0000
Color redCalendar = const Color.fromRGBO(255, 0, 0, 1);

//  #052A49
Color navy = const Color.fromRGBO(5, 42, 73, 1);

//  #10FF0B
Color green = const Color.fromRGBO(16, 255, 11, 1);
//  #47FF06
Color greenOnBoarding = const Color.fromRGBO(71, 255, 6, 1);

//  #A0A0A0
Color grey = const Color.fromRGBO(160, 160, 160, 1);
//  #D8D7D7
Color greyCardBorder = const Color.fromRGBO(216, 215, 215, 1);
//  #B9B9B9
Color greyCardBorder2 = const Color.fromRGBO(185, 185, 185, 1);
//  #EFEFEF
Color greyCardBorder3 = const Color.fromRGBO(239, 239, 239, 1);
//  #B3B3B3
Color greyCardBorder4 = const Color.fromRGBO(174, 174, 174, 1);
//  #D9D9D9
Color greyTableBorder = const Color.fromRGBO(217, 217, 217, 1);
//  #D8D8D8
Color greyTableBorder2 = const Color.fromRGBO(216, 216, 216, 1);
//  #FAFAFA
Color greyTableRow = const Color.fromRGBO(250, 250, 250, 1);
//  #7B7B7B
Color greyNavPath = const Color.fromRGBO(123, 123, 123, 1);
//  #E4E4E4
Color greyNavPathBorder = const Color.fromRGBO(228, 228, 228, 1);
//  #BDBDBD
Color greyActionBtnBorder = const Color.fromRGBO(189, 189, 189, 1);
//  #052A49
Color greyTableRowText = const Color.fromRGBO(5, 42, 73, 1);
//  #616161
Color greyMenuTextDescr = const Color.fromRGBO(97, 97, 97, 1);
//  #FBFBFB
Color greyBackground2 = const Color.fromRGBO(251, 251, 251, 1);
//  #F4F4F4
Color greyF4 = const Color.fromRGBO(244, 244, 244, 1);
//  #989898
Color greyDisableSecondary = const Color.fromRGBO(151, 152, 152, 1);
//  #C7C7C7
Color greyTakeLocation = const Color.fromRGBO(199, 199, 199, 1);
//  #8A8A8A
Color greyDivider = const Color.fromRGBO(138, 138, 138, 1);

//  #0DAB26
Color greenDocStatusCO = const Color.fromRGBO(13, 171, 38, 1);
//  #F4A800
Color orangeDocStatusIP = const Color.fromRGBO(244, 168, 0, 1);

//  #F4A800
Color blackLocName = const Color.fromRGBO(50, 46, 38, 1);
//  #FFC107
Color yellowEnroll = const Color.fromRGBO(255, 193, 7, 1);

FontWeight superLight = FontWeight.w100;
FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;
FontWeight superBold = FontWeight.w900;

TextDecoration underline = TextDecoration.underline;
FontStyle italic = FontStyle.italic;

MaterialStateProperty<Color?> redButton = MaterialStateProperty.all(Colors.red);
MaterialStateProperty<Color?> themecolorButton =
    MaterialStateProperty.all(blueOceanTheme);
MaterialStateProperty<Color?> greenButton =
    MaterialStateProperty.all(Colors.green);

// * Font Family
const String poppins = 'Poppins';

class OpusbTheme {
  TextStyle blackTextStyle =
      const TextStyle(fontFamily: 'Montserrat', color: Colors.black);
  TextStyle whiteTextStyle =
      const TextStyle(fontFamily: 'Montserrat', color: Colors.white);
  TextStyle blackTextStyleO =
      const TextStyle(fontFamily: 'Oswald', color: Colors.black);
  TextStyle whiteTextStyleO =
      const TextStyle(fontFamily: 'Oswald', color: Colors.white);
}
