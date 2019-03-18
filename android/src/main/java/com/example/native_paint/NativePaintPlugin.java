package com.example.native_paint;

import io.flutter.plugin.common.PluginRegistry.Registrar;

/** NativePaintPlugin */
public class NativePaintPlugin {

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    if (registrar.activity() == null) {
      return;
    }
    registrar
        .platformViewRegistry()
        .registerViewFactory(
            "plugins.example.com/native_paint", new NativePaintFactory(registrar));
  }
}
