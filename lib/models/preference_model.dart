// *  [文件说明]
//    User 的 Data Model（注意区别MVC中的 Model）
class PreferenceModel {
  final bool isDarkMode; // 用户黑夜模式开关

  // constructor 构建者
  const PreferenceModel({
    required this.isDarkMode,
  });

  // 方便修改 user 中的某一个值，全体 copy 然后单独设定某几个特定属性的值
  PreferenceModel copy({
    bool? isDarkMode,
  }) =>
      PreferenceModel(
        // 如果是 null 则用原本的 this.XXX
        isDarkMode: isDarkMode ?? this.isDarkMode,
      );

  // *  从 json 格式转为 object
  static PreferenceModel fromJson(Map<String, dynamic> json) => PreferenceModel(
        isDarkMode: json['isDarkMode'],
      );
  // 相比传统 toJson(Object) 来将 object 转为 json
  // 这种用 . 的调用方式 object.tojson() 更加易于理解
  // Class function，该 class 的 instance 直接调用会直接调用该class的值
  // *  [使用方式]
  // User user;
  // let json = jsonEncode(user.toJson());
  Map<String, dynamic> toJson() => {
        'isDarkMode': isDarkMode,
      };
}
