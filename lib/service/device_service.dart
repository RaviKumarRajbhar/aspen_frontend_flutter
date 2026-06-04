import 'package:aspen_app/dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeviceService {

  final Dio dio;

  DeviceService(this.dio);

  Future<void> registerDeviceToken() async {

    try {
      final token = await FirebaseMessaging.instance.getToken();

      if(token == null) {
        return;
      }

      await dio.post(
        "/device/register",
        data: {
          "token" : token ,
          "type" : "ANDROID",
          "deviceName" : "Poco F7"
        },
      );

      print("Device Token registered");

    } catch (e) {

      print("failed ot register device token");

    }

  }
}

final deviceServiceProvider = Provider<DeviceService> ((ref){
  final dio = ref.read(universalDioProvider);
  return DeviceService(dio);
});