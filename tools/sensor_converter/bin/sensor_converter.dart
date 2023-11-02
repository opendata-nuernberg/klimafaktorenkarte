import 'package:args/command_runner.dart';
import 'package:sensor_converter/commands/fetch_data.dart';

Future<void> main(List<String> arguments) async {
  try {
    final runner = CommandRunner(
        "convert", "cli tool to convert sensor data from sensor.community")
      ..addCommand(FetchDataCommand());

    await runner.run(arguments);
  } catch (ex) {
    print("exception:");
    if (ex is UsageException) {
      print(ex.usage);
    } else {
      print(ex);
    }
  }
}
