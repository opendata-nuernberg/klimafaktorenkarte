import 'dart:convert';
import 'package:http/http.dart' as http;

// https://api.luftdaten.info/v1/filter/area=49.450167,11.079402,20
class LuftdatenApi {
  static const String baseUrl = 'https://api.luftdaten.info/v1';

  static Future<List<Map<String, dynamic>>> fetchSensors({
    String baseUrl = LuftdatenApi.baseUrl,
    double? lat,
    double? long,
    double radius = 10,
  }) async {
    final url = () {
      if (lat != null && long != null) {
        return '$baseUrl/filter/area=$lat,$long,$radius';
      }
      return baseUrl;
    }();
    final response = await http.get(Uri.parse(url));
    final list = json.decode(response.body) as List<dynamic>;
    final maplist = list.map((e) => e as Map<String, dynamic>).toList();
    return maplist;
  }
}

class SensorParser {
  static SensorParser create(Map<String, dynamic> data) {
    final sensorType = data['sensor']['sensor_type']['name'] as String;
    switch (sensorType) {
      case SensorParserDHT22.sensorType:
        return SensorParserDHT22(data);
      case SensorParserBME280.sensorType:
        return SensorParserBME280(data);
      default:
        return SensorParserUnknown(data);
    }
  }

  bool get isValid => !indoor;
  bool get indoor => data['location']['indoor'] == 1;
  String get type => data['sensor']['sensor_type']['name'] as String;
  double? get temperature => null;
  double? get humidity => null;
  double get longitude => double.parse(data['location']['longitude']);
  double get latitude => double.parse(data['location']['latitude']);
  int get id => data['id'] as int;

  SensorParser._(this.data);
  final Map<String, dynamic> data;

  dynamic _getSensorValue(String valueType) {
    final result = data['sensordatavalues']
        .firstWhere((e) => e['value_type'] == valueType);
    return result['value'];
  }
}

class SensorParserUnknown extends SensorParser {
  SensorParserUnknown(Map<String, dynamic> data) : super._(data);

  @override
  bool get isValid => false;
}

class SensorParserDHT22 extends SensorParser {
  static const String sensorType = 'DHT22';
  SensorParserDHT22(Map<String, dynamic> data) : super._(data);

  @override
  bool get isValid =>
      super.isValid &&
      type == sensorType &&
      temperature != null &&
      temperature != 0 &&
      humidity != null &&
      humidity != 0;

  @override
  double? get temperature => double.tryParse(_getSensorValue('temperature'));

  @override
  double? get humidity => double.tryParse(_getSensorValue('humidity'));
}

class SensorParserBME280 extends SensorParser {
  static const String sensorType = 'BME280';
  SensorParserBME280(Map<String, dynamic> data) : super._(data);

  @override
  bool get isValid =>
      super.isValid &&
      type == sensorType &&
      temperature != null &&
      temperature != 0 &&
      humidity != null &&
      humidity != 0;

  @override
  double? get temperature => double.tryParse(_getSensorValue('temperature'));
  @override
  double? get humidity => double.tryParse(_getSensorValue('humidity'));
}

class SensorData {
  SensorData(
    this.temperature,
    this.humidity,
    this.longitude,
    this.latitude,
  );
  final double temperature;
  final double humidity;
  final double longitude;
  final double latitude;
}
