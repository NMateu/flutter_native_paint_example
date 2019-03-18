package com.example.native_paint;

import android.content.Context;
import android.view.View;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.platform.PlatformView;

class NativePaintView implements PlatformView {

  private final DrawingView drawingView;

  NativePaintView(Context context, Registrar mPluginRegistrar, int id) {
    drawingView = new DrawingView(context);
  }

  @Override
  public View getView() {
    return drawingView;
  }

  @Override
  public void dispose() {

  }
}
