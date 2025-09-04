import 'dart:async';
import 'dart:math';

import '../../models/readings.dart';

class BluetoothService {
  final bool mock;

  BluetoothService({this.mock = true});

  Future<Reading> fetchReading() async {
    if (mock) {
      await Future.delayed(const Duration(milliseconds: 900));
      final r = Random();
      final temp = 20 + r.nextDouble() * 10;
      final moisture = 30 + r.nextDouble() * 50;
      return Reading(
        timestamp: DateTime.now(),
        temperature: double.parse(temp.toStringAsFixed(1)),
        moisture: double.parse(moisture.toStringAsFixed(1)),
      );
    } else {
      throw UnimplementedError('Real Bluetooth not implemented yet.');
    }
  }
}
