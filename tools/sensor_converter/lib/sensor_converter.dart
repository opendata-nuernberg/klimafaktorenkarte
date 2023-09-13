import 'package:args/command_runner.dart';

class ConvertCommand extends Command {
  // The [name] and [description] properties must be defined by every
  // subclass.
  @override
  final name = "convert";
  @override
  final description = "converts sensor data from sensor.community";

  ConvertCommand() {
    // we can add command specific arguments here.
    // [argParser] is automatically created by the parent class.
    // argParser.addFlag('all', abbr: 'a');
    //addSubcommand(SubCommand());
  }

  // [run] may also return a Future.
  @override
  void run() {
    print(argResults?['all']);
  }
}
