import 'dart:async';

import 'package:flutter/material.dart';

class SessionTimeOutListener extends StatefulWidget {
  Widget child;
  Duration duration;
  VoidCallback onTimeOut;
  BuildContext context; // Add context parameter

  SessionTimeOutListener({
    Key? key,
    required this.child,
    required this.duration,
    required this.onTimeOut,
    required this.context, // Initialize context
  }) : super(key: key);

  @override
  State<SessionTimeOutListener> createState() => _SessionTimeOutListenerState();
}

class _SessionTimeOutListenerState extends State<SessionTimeOutListener> {
  Timer? _timer;

  //by using this function start the session timer
  _startTimer() {
    print("Timer Asset");
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }

    _timer = Timer(widget.duration, () {
      print("Elsaped");
      widget.onTimeOut();
    });
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) {
        _startTimer();
      },
      child: widget.child,
    );
  }
}
