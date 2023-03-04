import 'dart:async';
import 'dart:convert';

import 'package:flutter_dmzj/app/log.dart';
import 'package:flutter_dmzj/models/user/login_result_model.dart';
import 'package:flutter_dmzj/models/user/user_profile_model.dart';
import 'package:flutter_dmzj/modules/user/login/user_login_dialog.dart';
import 'package:flutter_dmzj/requests/user_request.dart';
import 'package:flutter_dmzj/services/local_storage_service.dart';
import 'package:get/get.dart';

class UserService extends GetxService {
  static StreamController loginedStreamController =
      StreamController.broadcast();
  static StreamController logoutStreamController = StreamController.broadcast();

  ///登录事件流
  static Stream get loginedStream => loginedStreamController.stream;

  ///退出登录事件流
  static Stream get logoutStream => logoutStreamController.stream;

  static UserService get instance => Get.find<UserService>();
  final LocalStorageService storage = Get.find<LocalStorageService>();
  final request = UserRequest();
  LoginResultModel? userAuthInfo;

  Rx<UserProfileModel?> userProfile = Rx<UserProfileModel?>(null);

  String get dmzjToken => userAuthInfo?.dmzjToken ?? '';
  String get userId => userAuthInfo?.uid ?? '';
  String get nickname => userAuthInfo?.nickname ?? '';

  /// 是否已经登录
  var logined = false.obs;

  void init() {
    var value = storage.getValue(LocalStorageService.kUserAuthInfo, '');
    if (value.isEmpty) {
      return;
    }
    LoginResultModel info = LoginResultModel.fromJson(json.decode(value));

    userAuthInfo = info;
    logined.value = true;
  }

  /// 设置登录信息
  void setAuthInfo(LoginResultModel info) {
    userAuthInfo = info;
    storage.setValue(LocalStorageService.kUserAuthInfo, info.toString());
    logined.value = true;
    UserService.loginedStreamController.add(true);
    refreshProfile();
  }

  void logout() {
    storage.removeValue(LocalStorageService.kUserAuthInfo);
    userProfile.value = null;
    logined.value = false;
    UserService.logoutStreamController.add(true);
  }

  Future<bool> login() async {
    if (logined.value) {
      return true;
    }
    var result = await Get.dialog(UserLoginDialog());

    return (result != null && result == true);
  }

  /// 刷新个人资料
  Future refreshProfile() async {
    try {
      if (!logined.value) {
        return;
      }
      userProfile.value = await request.userProfile();
    } catch (e) {
      Log.logPrint(e);
    }
  }

  void subscribeComic(int comicId) {
    //TODO 订阅漫画
  }
}
