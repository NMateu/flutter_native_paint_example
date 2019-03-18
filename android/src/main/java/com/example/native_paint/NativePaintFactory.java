package com.example.native_paint;

import android.content.Context;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

class NativePaintFactory extends PlatformViewFactory {

  private final Registrar mPluginRegistrar;

  NativePaintFactory(Registrar registrar) {
    super(StandardMessageCodec.INSTANCE);
    mPluginRegistrar = registrar;
  }

  @Override
  public PlatformView create(Context context, int i, Object o) {
    return new NativePaintView(context, mPluginRegistrar, i);
  }
}
