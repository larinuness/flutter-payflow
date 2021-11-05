import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthController {
  //var que diz se está logado ou não
  UserModel? _user;

  //devolve o userm, mantém instancia unica, só que usa a função setUser
  UserModel get user => _user!;

  //saber se está logado
  void setUser(BuildContext context, UserModel? user) {
    if (user != null) {
      saveUser(user);
      //salvar user no user
      _user = user;
      //coloca na home e remove o sinal de volta
      Navigator.pushReplacementNamed(context, '/home', arguments: user);
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  //salva o usuario
  Future<void> saveUser(UserModel user) async {
    //pega a instancia do sharedPreferences
    final instance = await SharedPreferences.getInstance();
    await instance.setString('user', user.toJson());
    //return vazio
    return;
  }

  //pega user atual
  Future<void> currentUser(BuildContext context) async {
    //pega a instancia do sharedPreferences
    final instance = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    if (instance.containsKey('user')) {
      final json = instance.get('user') as String;
      setUser(context, UserModel.fromJson(json));
      //return vazio
      return;
    } else {
      setUser(context, null);
    }
  }
}
