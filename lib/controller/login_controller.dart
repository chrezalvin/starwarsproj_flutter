import 'dart:async';

import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:starwarsproj_flutter/pages/home_page.dart';
import 'package:starwarsproj_flutter/service/enseval_service.dart';

class LoginController extends GetxController{
  final Logger log = Logger("LoginController");

  final RxString _username = "".obs;
  final RxString _password = "".obs;
  final RxBool _passwordVisible = false.obs;
  final RxBool _isLoading = false.obs;
  
  final RxString _errorMessage = "".obs;

  // only checks if the username and password is not empty
  final RxBool _validateUsername = false.obs;
  final RxBool _validatePassword = false.obs;

  // getter
  String get username => _username.value;
  String get password => _password.value;
  bool get passwordVisible => _passwordVisible.value;
  bool get isLoading => _isLoading.value;
  String  get error => _errorMessage.value;
  bool get isError => _errorMessage.value.isNotEmpty;
  bool get validateUsername => _validateUsername.value;
  bool get validatePassword => _validatePassword.value;
  bool get isLoginDisabled => username.isEmpty || password.isEmpty || isLoading;

  // this is the private base setter
  void _setUsername(String value) => _username.value = value;
  void _setPassword(String value) => _password.value = value;
  void _togglePasswordVisible() => _passwordVisible.value = !_passwordVisible.value;
  void _setLoading(bool value) => _isLoading.value = value;
  void _setError(String message) => _errorMessage.value = message;
  void _setValidateUsername(bool value) => _validateUsername.value = value;
  void _setValidatePassword(bool value) => _validatePassword.value = value;
  Future<dynamic> _login() async{
    var res = await EnsevalService().login(username, password);

    return res;
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

  void setValidateUsername(bool value){
    log.info("Setting validate username to $value");
    _setValidateUsername(value);
  }

  void setValidatePassword(bool value){
    log.info("Setting validate password to $value");
    _setValidatePassword(value);
  }
  
  Future<void> login() async {
    setValidateUsername(username.isEmpty);
    setValidatePassword(password.isEmpty);

    if(validateUsername || validatePassword){
      log.warning("Username or password is empty");
      return;
    }

    setLoading(true);

    try{
      log.info("Logging in");
      var res = await _login();
      if(res == null){
        _setError("Invalid username or password");
      }
      else{
        log.info("Login success");

        // go to home page
        if(res != null){
          Get.to(HomePage());
        }
      }

      log.info("Logging finished");
    } 
    on Exception catch(e)
    {
      if(e is ClientException){
        _setError("Invalid username or password");
      }
      else if(e is TimeoutException){
        _setError("Request timeout");
      }
      else{
        _setError("Unknown error occured!");
      }
    }
    catch(e){
      log.warning("error occured $e");
      _setError("Unknown error occured!");
    }
    finally{
      setLoading(false);
    }
  }
}