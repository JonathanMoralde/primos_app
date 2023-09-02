package com.example.primos_app

import android.content.ActivityNotFoundException
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val channelName = "rawBtPrint";

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        var channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger,channelName);
        channel.setMethodCallHandler { call, result ->

         if(call.method == "print"){
             val content = call.argument<String>("content")
             if (content != null) {
                 val intent = Intent("ru.a402d.rawbtprinter.action.PRINT_RAWBT")
                 intent.setPackage("ru.a402d.rawbtprinter")
                 intent.putExtra("ru.a402d.rawbtprinter.extra.CONTENT", "Test")

                 try {
                     startActivity(intent)
                     result.success(true)
                 } catch (e: ActivityNotFoundException) {
                     result.success(false)
                 }
             } else {
                 result.success(false)
             }
         }

        }

    }
}
