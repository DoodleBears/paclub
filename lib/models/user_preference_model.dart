// *  [文件说明]
//    User 的 Data Model（注意区别MVC中的 Model）
class UserPreferenceModel {
  final String imagePath; // 头像路径（1.网络图片，2.本地图片）
  final String name; // 用户名
  final String email; // 用户邮箱
  final String about; // 用户自我介绍（关于自己）
  final bool isDarkMode; // 用户黑夜模式开关

  // constructor 构建者
  const UserPreferenceModel({
    required this.imagePath,
    required this.name,
    required this.email,
    required this.about,
    required this.isDarkMode,
  });

  // 方便修改 user 中的某一个值，全体 copy 然后单独设定某几个特定属性的值
  UserPreferenceModel copy({
    String? imagePath,
    String? name,
    String? email,
    String? about,
    bool? isDarkMode,
  }) =>
      UserPreferenceModel(
        // 如果是 null 则用原本的 this.XXX
        imagePath: imagePath ?? this.imagePath,
        name: name ?? this.name,
        email: email ?? this.email,
        about: about ?? this.about,
        isDarkMode: isDarkMode ?? this.isDarkMode,
      );

  // *  从 json 格式转为 object
  static UserPreferenceModel fromJson(Map<String, dynamic> json) =>
      UserPreferenceModel(
        imagePath: json['imagePath'],
        name: json['name'],
        email: json['email'],
        about: json['about'],
        isDarkMode: json['isDarkMode'],
      );
  // 相比传统 toJson(Object) 来将 object 转为 json
  // 这种用 . 的调用方式 object.tojson() 更加易于理解
  // Class function，该 class 的 instance 直接调用会直接调用该class的值
  // *  [使用方式]
  // User user;
  // let json = jsonEncode(user.toJson());
  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'name': name,
        'email': email,
        'about': about,
        'isDarkMode': isDarkMode,
      };
}
