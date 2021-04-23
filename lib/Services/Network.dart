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
    print(response.body);
    return response.statusCode;
  }
}

Future<Map<String, dynamic>> loginUser(Map<String, dynamic> map) async {
  var response = await http.post(
    Uri.http('glacial-shore-29640.herokuapp.com', '/users/login'),
    body: json.encode(map),
    headers: {
      "Content-Type": "application/json; charset=utf-8",
    },
  );

  print(response.body);

  try {
    Map<String, dynamic> maps = json.decode(response.body);

    if (maps['msg'] == "Login Sucessful") {
      print(maps);
      return maps;
    } else if (maps['msg'] == "User does't Exist" ||
        maps['msg'] == "Password is Incorrect") {
      return maps;
    } else {
      return maps;
    }
  } catch (e) {
    return {'msg': "An unexpected Error occured"};
  }
}

Future sendNotifications(Map<String, dynamic> map) async {
  var response = await http.post(
    Uri.http('glacial-shore-29640.herokuapp.com', '/notification/send'),
    body: json.encode(map),
    headers: {
      "Content-Type": "application/json; charset=utf-8",
    },
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    print(response.body);
  } else {
    print("An error occured");
  }
}

Future updateRecentChats(String senderEmail, String recieverEmail) async {
  Map<String, dynamic> map = {
    "gmail": senderEmail,
    "chats": recieverEmail,
  };

  var response = await http.post(
    Uri.http('glacial-shore-29640.herokuapp.com', '/chat/recentchats'),
    body: json.encode(map),
    headers: {
      "Content-Type": "application/json; charset=utf-8",
    },
  );

  if (response.statusCode == 201 || response.statusCode == 200) {
    print("SendSucessfully");
  } else {
    print("An error occured");
  }
}

Future<List> recentChats(String gmail) async {
  var response = await http
      .get(Uri.http('glacial-shore-29640.herokuapp.com', '/chat/$gmail'));

  List data = json.decode(response.body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    print("Data Recieved Sucessfully");
    return data;
  } else {
    print("Error occured");
    return [];
  }
}

Future<Map<String, dynamic>> uploadImageLink(Map<String, dynamic> map) async {
  var response = await http.patch(
    Uri.http('glacial-shore-29640.herokuapp.com', '/users/updateimage'),
    body: json.encode(map),
    headers: {
      "Content-Type": "application/json; charset=utf-8",
    },
  );

  Map<String, dynamic> resp = json.decode(response.body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    print("Sucessfull");
    return resp;
  } else {
    print("error");
    return resp;
  }
}
