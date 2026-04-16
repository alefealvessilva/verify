import 'dart:developer';

abstract class IRegisterLog {
  void call(Object e);
}

class RegisterLogImpl implements IRegisterLog {
  @override
  void call(Object e) async {
    final error = 'Error: $e';
    log(error);
  }
}
