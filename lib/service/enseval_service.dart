import 'package:starwarsproj_flutter/provider/enseval.dart';

class EnsevalService{
  final _api = Enseval();

  Future<dynamic> login(String username, String password) async{
    return await _api.login(username, password);
  }
}