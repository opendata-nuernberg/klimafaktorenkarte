import 'package:sensor_converter/luftdaten_api.dart';
import 'package:sensor_converter/sensor_converter.dart';
import 'package:test/test.dart';
import 'dart:io' as io;
import 'dart:convert';

void main() {
  test('Parse DHT22', () async {
    final data = await apiResponseMock();
    final some = data
        .map((e) => SensorParser.create(e))
        .firstWhere((e) => e.id == 17135330259);

    expect(some.type, SensorParserDHT22.sensorType);
    expect(some.isValid, true);
    expect(some.temperature, 23.4);
    expect(some.humidity, 98.5);
    expect(some.longitude, 11.14);
    expect(some.latitude, 49.358);
  });

  test('Parse BME280', () async {
    final data = await apiResponseMock();
    final some = data
        .map((e) => SensorParser.create(e))
        .firstWhere((e) => e.id == 17135328393);

    expect(some.type, SensorParserBME280.sensorType);
    expect(some.isValid, true);
    expect(some.temperature, 16.70);
    expect(some.humidity, 72.94);
    expect(some.longitude, 11.034);
    expect(some.latitude, 49.404);
  });

  test('Parse all Sensors', () async {
    final luftdatenApiResult = await apiResponseMock();
    final data = SensorConverter.convert(luftdatenApiResult);
    JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final jsonData = encoder.convert(data);
    print(jsonData);
  });
}

Future<List<Map<String, dynamic>>> apiResponseMock() async {
  final file = io.File('test/luftdaten_api_mock.json');
  final data = await file.absolute.readAsString();
  return (json.decode(data) as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList();
}

void printSensorTypes(List<Map<String, dynamic>> data) {
  final sensorTypes = <String, int>{};

  for (final map in data) {
    final type = map['sensor']['sensor_type']['name'] as String;
    if (sensorTypes.containsKey(type)) {
      sensorTypes[type] = sensorTypes[type]! + 1;
    } else {
      sensorTypes[type] = 1;
    }
  }

  // radius 2km: {BME280: 5, DHT22: 12, SDS011: 23}
  // radius 20km: {DHT22: 111, SDS011: 265, Radiation Si22G: 3, BME280: 65, SHT31: 5, DNMS (Laerm): 4, BMP180: 4, BMP280: 8, PMS7003: 2}
  //              {SDS011: 256, BMP280: 8, DHT22: 104, SHT31: 4, BME280: 62, PMS7003: 3, DNMS (Laerm): 4, Radiation Si22G: 2, BMP180: 4}

  print(sensorTypes);
}
