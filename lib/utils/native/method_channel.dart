import 'package:flutter/services.dart';

const methodChannel = MethodChannel('method.channel.bannzai.Medicalarm');

void requestAppTrackingTransparency() {
  methodChannel.invokeMethod('requestAppTrackingTransparency');
}
