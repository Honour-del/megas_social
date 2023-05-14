// TODO Implement this library.

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';



class Preferences {
  /// set token
  Future<void> setToken(String value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    await _preferences.setString("token", value);
  }

  /// set email
  Future<void> setEmail(String value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    await _preferences.setString("email", value);
  }

  /// retrieve email
  Future<String?> getEmail() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String? token = _preferences.getString("email");
    return token;
  }


  /// retrieve token
  Future<String?> getToken() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String? token = _preferences.getString("token");
    return token;
  }

  Future<void> deleteToken() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    await _preferences.remove("token");
  }
  Future<void> setRefreshToken(String value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    await _preferences.setString("refresh_token", value);
  }
  Future<String?> getRefreshToken() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String? token = _preferences.getString("refresh_token");
    return token;
  }

  Future<void> deleteRefreshToken() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    await _preferences.remove("refresh_token");
  }


  Future<void> setFCMToken(String value) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    await _preferences.setString("fcm_token", value);
  }

  Future<String?> getFCMToken() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String? token = _preferences.getString("fcm_token");
    return token;
  }

//   Future<bool> saveUser1(ProfileModel user) async {
//     SharedPreferences _preferences = await SharedPreferences.getInstance();
//     await _preferences.setString("email", user.email!);
//     await _preferences.setString("name", user.profileName!);
//     await _preferences.setInt("id", user.id as int);
//     await _preferences.setString("role", user.role!);
//     // await _preferences.setString("password", user.password);
//     // await _preferences.setString("confirmPassword", user.password2);
//     await _preferences.setString("phoneNumber", user.phoneNumber!);
//     await _preferences.setString("address", user.address!);
//
//     return _preferences.commit();
//   }
//
//
//   Future<ProfileModel> getUser1() async {
//     SharedPreferences _preferences = await SharedPreferences.getInstance();
//     int? id = _preferences.getInt("id");
//     String? email = _preferences.getString("email");
//     String? name =  _preferences.getString("name");
//     String? role =  _preferences.getString("role");
//     String? phone =  _preferences.getString("phoneNumber");
//     String? address =  _preferences.getString("address");
//     // String? name =  _preferences.getString("name");
//
//     return ProfileModel(
//         id: id.toString(), profileImage: '',
//         role: role, profileName: name, email: email,
//         phoneNumber: phone, address: address);
//   }
//
//   Future<void> saveUser({
//     required String email,
//     required String name,
//     required String role,
//     required String password,
//     required String password2,
//     required String phone,
//     required String address,
// }) async {
//     SharedPreferences _preferences = await SharedPreferences.getInstance();
//     await _preferences.setString("email", email);
//     await _preferences.setString("name", name);
//     await _preferences.setString("role", role);
//     await _preferences.setString("password", password);
//     await _preferences.setString("confirmPassword", password2);
//     await _preferences.setString("phoneNumber", phone);
//     await _preferences.setString("address", address);
//   }
//
//   Future<String?> getUser() async {
//     SharedPreferences _preferences = await SharedPreferences.getInstance();
//     String? email = _preferences.getString("email");
//     String? name =  _preferences.getString("name");
//     String? role =  _preferences.getString("role");
//     String? password =  _preferences.getString("password");
//     String? confirmPassword =  _preferences.getString("confirmPassword");
//     String? phone =  _preferences.getString("phoneNumber");
//     String? address =  _preferences.getString("address");
//     // String? name =  _preferences.getString("name");
//     if(email != null) {
//       return email;
//     } else if(name != null) {
//       return name;
//     } else if (role != null) {
//       return role;
//     } else if (password != null) {
//       return password;
//     } else if (confirmPassword != null) {
//       return confirmPassword;
//     } else if (phone != null) {
//       return phone;
//     } else if(address != null) {
//       return address;
//     }
//     else {
//       return null;
//     }
//   }
}
