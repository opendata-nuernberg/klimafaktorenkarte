import 'package:h3_dart/h3_dart.dart';

import 'luftdaten_api.dart';
import 'models.dart';

import 'dart:io' show Platform;

class SensorConverter {
  static Map<String, dynamic> convert(
      List<Map<String, dynamic>> luftdatenApiResult) {
    final sensorDataList = luftdatenApiResult
        .map((sensor) => SensorParser.create(sensor))
        .where((parser) => parser.isValid)
        .map(
      (parser) {
        return SensorData(
          parser.temperature!,
          parser.humidity!,
          parser.longitude,
          parser.latitude,
        );
      },
    ).toList();

    final data = ComulativeTemperatureData(
      mapSensorDataToArea(sensorDataList, 1),
      mapSensorDataToArea(sensorDataList, 2),
      mapSensorDataToArea(sensorDataList, 3),
      mapSensorDataToArea(sensorDataList, 4),
      mapSensorDataToArea(sensorDataList, 5),
      mapSensorDataToArea(sensorDataList, 6),
      mapSensorDataToArea(sensorDataList, 7),
      mapSensorDataToArea(sensorDataList, 8),
      mapSensorDataToArea(sensorDataList, 9),
      mapSensorDataToArea(sensorDataList, 10),
      mapSensorDataToArea(sensorDataList, 11),
      mapSensorDataToArea(sensorDataList, 12),
      mapSensorDataToArea(sensorDataList, 13),
      mapSensorDataToArea(sensorDataList, 14),
      mapSensorDataToArea(sensorDataList, 15),
    ).toJson();

    return data;
  }

  static H3 _h3Builder() {
    if (Platform.isMacOS) {
      return H3Factory().byPath('bin/h3.so');
    }
    throw UnimplementedError('H3 not supported on this platform');
  }

  static List<SensorArea> mapSensorDataToArea(
      List<SensorData> temperatureList, int h3Resolution) {
    final h3 = _h3Builder();

    final something = <BigInt, List<SensorData>>{};
    for (final temp in temperatureList) {
      final index = h3.geoToH3(
          GeoCoord(lon: temp.longitude, lat: temp.latitude), h3Resolution);

      //final h3Index = index.toRadixString(16);
      // latitude, longitude
      // 49.39, 11.01
      // print("$h3Index: lat: ${temp.latitude}, long: ${temp.longitude}");
      // int.toRadixString(15)

      if (something.containsKey(index)) {
        something[index]!.add(temp);
      } else {
        something[index] = [temp];
      }
    }

    return something
        .map((key, value) {
          final temperature =
              value.map((e) => e.temperature).reduce((a, b) => a + b) /
                  value.length;
          final humidity =
              value.map((e) => e.humidity).reduce((a, b) => a + b) /
                  value.length;
          return MapEntry(
            key,
            SensorArea(
              key,
              temperature,
              humidity,
              value.length,
            ),
          );
        })
        .values
        .toList();
  }
}
