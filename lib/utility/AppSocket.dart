import 'package:fullmarks/utility/AppStrings.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AppSocket {
  static IO.Socket get _instance => _socketInstance ??= IO
      .io(
        AppStrings.baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build(),
      )
      .connect();
  static IO.Socket _socketInstance;

  // call this method from iniState() function of mainApp().
  static IO.Socket init() {
    _socketInstance = _instance;
    return _socketInstance;
  }

  //random quiz
  static IO.Socket get _randomInstance => _socketInstanceRandom ??= IO
      .io(
        AppStrings.baseUrl + "random",
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build(),
      )
      .connect();
  static IO.Socket _socketInstanceRandom;

  // call this method from iniState() function of mainApp().
  static IO.Socket initRandom() {
    _socketInstanceRandom = _randomInstance;
    return _socketInstanceRandom;
  }
}
