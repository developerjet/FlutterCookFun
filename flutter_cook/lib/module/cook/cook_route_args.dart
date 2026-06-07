class CookConfigArguments {
  final String methodName;
  final String version;
  final Map<String, dynamic> extraParams;

  CookConfigArguments({
    required this.methodName,
    this.version = '4.3.2',
    Map<String, dynamic>? extraParams,
  }) : extraParams = Map<String, dynamic>.from(extraParams ?? {});

  factory CookConfigArguments.fromMap(Map<String, dynamic>? map) {
    final arguments = Map<String, dynamic>.from(map ?? {});
    return CookConfigArguments(
      methodName: arguments['methodName']?.toString() ?? '',
      version: arguments['version']?.toString() ?? '4.3.2',
      extraParams: () {
        arguments.remove('methodName');
        arguments.remove('version');
        return arguments;
      }(),
    );
  }

  bool get isValid => methodName.isNotEmpty;

  Map<String, dynamic> toQueryParams(int page, int size) {
    return {
      ...extraParams,
      'methodName': methodName,
      'version': version,
      'page': page,
      'size': size,
    };
  }
}

class CookStepsArguments {
  final String dishesId;
  final String pushPage;

  CookStepsArguments({required this.dishesId, this.pushPage = ''});

  factory CookStepsArguments.fromMap(Map<String, dynamic>? map) {
    return CookStepsArguments(
      dishesId: map?['dishes_id']?.toString() ?? '',
      pushPage: map?['pushPage']?.toString() ?? '',
    );
  }

  bool get isValid => dishesId.isNotEmpty;
}
