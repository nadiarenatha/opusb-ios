import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'login_body.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/niaga_splash_screen.mp4')
      ..initialize().then((_) {
        print("Video initialized successfully");
        _controller.setVolume(1.0);
        _controller.play();
        setState(() {});
      }).catchError((error) {
        print("Video initialization error: $error");
      });

    _controller.addListener(() {
      if (_controller.value.hasError) {
        print("Video player error: ${_controller.value.errorDescription}");
      }
      if (!_controller.value.isPlaying &&
          _controller.value.position == _controller.value.duration) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginBody()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            // ? Container(
            //     width: double.infinity,
            //     height: double.infinity,
            //     child: FittedBox(
            //       fit: BoxFit
            //           .cover, // This will make the video fill the entire screen
            //       child: SizedBox(
            //         width: _controller.value.size.width,
            //         height: _controller.value.size.height,
            //         child: VideoPlayer(_controller),
            //       ),
            //     ),
            //   )
            ? Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: FittedBox(
                      // This will make the video fill the entire screen
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginBody()),
                        );
                      },
                      child: Text(
                        "Skip",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: TextButton.styleFrom(
                        // Add a background if desired
                        backgroundColor: Colors.black54,
                      ),
                    ),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
