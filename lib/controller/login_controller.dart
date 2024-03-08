import 'package:get/get.dart';
import 'package:logging/logging.dart';

import 'package:http/http.dart' as http;

class LoginController extends GetxController{
  final Logger log = Logger("LoginController");

  final RxString _username = "".obs;
  final RxString _password = "".obs;
  final RxBool _passwordVisible = false.obs;
  final RxBool _isLoading = false.obs;
  
  final RxString _errorMessage = "".obs;

  // getter
  String get username => _username.value;
  String get password => _password.value;
  bool get passwordVisible => _passwordVisible.value;
  bool get isLoading => _isLoading.value;
  String  get error => _errorMessage.value;
  bool get isError => _errorMessage.value.isNotEmpty;

  // this is the private base setter
  void _setUsername(String value) => _username.value = value;
  void _setPassword(String value) => _password.value = value;
  void _togglePasswordVisible() => _passwordVisible.value = !_passwordVisible.value;
  void _setLoading(bool value) => _isLoading.value = value;
  void _setError(String message) => _errorMessage.value = message;
  Future<void> _login() async{
    // simulate a login process
    await Future.delayed(const Duration(seconds: 2));

    // simulate error
    throw UnimplementedError("Login failed");
  }

  // setter with logging
  void setUsername(String value){
    log.info("Setting username to $value");
    _setUsername(value);
  }

  void setPassword(String value){
    log.info("Setting password to $value");
    _setPassword(value);
  }

  void togglePasswordVisible(){
    log.info("Toggling password visibility");
    _togglePasswordVisible();
  }

  void setLoading(bool value){
    log.info("Setting loading to $value");
    _setLoading(value);
  }

  void triggerError(
    {
      required String message,
      int cancelTimeMs = 2000
    }
    ){
      log.info("triggered an error with message: $message");
      _setError(message);

      Future.delayed(Duration(milliseconds: cancelTimeMs), (){
        _setError("");
        log.info("cleaned the error message");
      });
    }
  
  Future<void> login() async {
    setLoading(true);

    try{
      log.info("Logging in");
      await _login();
      log.info("Logging finished");
    }
    catch(e){
      log.warning("error occured");
      setUsername("");
      _setError("Unknown error occured!");
    }
    finally{
      setLoading(false);
    }
  }
}