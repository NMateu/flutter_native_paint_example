import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativePaintWidget extends StatefulWidget {
  @override
  _NativePaintWidgetState createState() => _NativePaintWidgetState();
}

class _NativePaintWidgetState extends State<NativePaintWidget> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android)
      return AndroidView(
        viewType: 'plugins.example.com/native_paint',
      );
    return Text(
        '$defaultTargetPlatform is not yet supported by the native paint plugin');
  }
}



class NativePaint {

}
