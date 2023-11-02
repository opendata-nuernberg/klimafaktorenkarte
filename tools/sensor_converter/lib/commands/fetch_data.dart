import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:sensor_converter/luftdaten_api.dart';
import 'package:sensor_converter/sensor_converter.dart';

class FetchDataCommand extends Command {
  @override
  final name = "fetch";
  @override
  final description = "fetch data from sensor.community";

  FetchDataCommand() {
    argParser.addOption('url', abbr: 'u', defaultsTo: LuftdatenApi.baseUrl);
    argParser.addOption('latitude', aliases: ['lat'], mandatory: true);
    argParser.addOption('longitude', aliases: ['long'], mandatory: true);
    argParser.addOption('radius', abbr: 'r', mandatory: true);
    argParser.addFlag('convert');
  }

  @override
  Future<void> run() async {
    final url = argResults!["url"];
    final lat = double.parse(argResults!["latitude"]);
    final long = double.parse(argResults!["longitude"]);
    final radius = double.parse(argResults!["radius"]);
    final convert = argResults?.arguments.contains('convert') ?? false;

    final apiResult = await LuftdatenApi.fetchSensors(
      baseUrl: url,
      lat: lat,
      long: long,
      radius: radius,
    );

    if (convert) {
      final data = SensorConverter.convert(apiResult);
      JsonEncoder encoder = JsonEncoder.withIndent('  ');
      final jsonData = encoder.convert(data);
      print(jsonData);
    } else {
      JsonEncoder encoder = JsonEncoder.withIndent('  ');
      final jsonData = encoder.convert(apiResult);
      print(jsonData);
    }
  }
}
