/// [AppResponse] 是用于封装网络请求（需要用到Future作为return）的回传值的类
/// 具有基本的 message 和 data 两个属性
/// 此外还具有 exceptionType 属性来存放 Exception 类型
/// override 了 toString() function 可以在回传出错时候快速输出报错
class AppResponse {
  // 关于这个网络请求的状态的解释
  late String _message;

  /// 获得 Response 里的信息（错误代码）
  String get message => _message;

  // response 的 data
  dynamic _data;

  /// 获得 Response 里的数据（错误代码）
  dynamic get data => _data;

  late String _exceptionType;

  /// 获得 Response 里的错误类型（exceptionType）
  String get exceptionType => _exceptionType;

  /// [封装 AppResponse]
  ///
  /// [传入参数]
  /// - [AppResponse]
  ///   - message: [String] 错误代码
  ///   - data: [dynamic]
  AppResponse(String message, dynamic data,
      [String exceptionType = 'NO_EXCEPTION_PROVIDED']) {
    _message = message;
    _data = data;
    _exceptionType = exceptionType;
  }

  /// [输出 Exception 和 Message]
  @override
  String toString() {
    return 'Exception: $exceptionType\nMessage: $message';
  }
}
