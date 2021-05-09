///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class LoginBean {
/*
{
  "id": 82504,
  "email": "",
  "username": "513960124@qq.com"
  "password": "",
  "admin": false,
  "coinCount": 0,
  "token": "",
} 
*/

  int id;
  String email;
  String username;
  String password;
  bool admin;
  int coinCount;
  String token;

  LoginBean({
    this.id,
    this.email,
    this.username,
    this.password,
    this.admin,
    this.coinCount,
    this.token,
  });
  LoginBean.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toInt();
    email = json["email"]?.toString();
    username = json["username"]?.toString();
    password = json["password"]?.toString();
    admin = json["admin"];
    coinCount = json["coinCount"]?.toInt();
    token = json["token"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["email"] = email;
    data["username"] = username;
    data["password"] = password;
    data["admin"] = admin;
    data["coinCount"] = coinCount;
    data["token"] = token;
    return data;
  }
}