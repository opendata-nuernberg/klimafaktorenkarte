import 'package:args/command_runner.dart';
import 'package:sensor_converter/sensor_converter.dart';

Future<void> main(List<String> arguments) async {
  try {
    final runner = CommandRunner(
        "convert", "cli tool to convert sensor data from sensor.community")
      ..addCommand(ConvertCommand());

    await runner.run(arguments);
  } catch (ex) {
    if (ex is UsageException) {
      print(ex.usage);
    } else {
      print(ex);
    }
  }
}
