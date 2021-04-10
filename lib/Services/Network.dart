import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getUser(String gmail) async {
  var response = await http
      .get(Uri.http('glacial-shore-29640.herokuapp.com', '/users/$gmail'));

  Map<String, dynamic> map = json.decode(response.body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    print(map);
    return map;
  } else {
    print(map);
    return map;
  }
}

Future<int> registerNewUser(Map<String, dynamic> map) async {
  var response = await http.post(
    Uri.http('glacial-shore-29640.herokuapp.com', '/users/register'),
    body: json.encode(map),
    headers: {
      "Content-Type": "application/json; charset=utf-8",
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    print("Register Sucessfully");
    return response.statusCode;
  } else {
    print("Error Occured");
    return response.statusCode;
  }
}
