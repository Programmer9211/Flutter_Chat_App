package com.example.chatapp;



    // ...
import android.annotation.SuppressLint;

import io.flutter.app.FlutterApplication;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;

    @SuppressLint("Registered")
    public class Application extends FlutterApplication implements PluginRegistrantCallback {
        // ...
        @Override
        public void onCreate() {
            super.onCreate();
            FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
        }

        @Override
        public void registerWith(PluginRegistry registry) {
            GeneratedPluginRegistrant.registerWith((FlutterEngine) registry);
        }
        // ...
    }


