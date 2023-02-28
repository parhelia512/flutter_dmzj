import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_dmzj/app/app_error.dart';
import 'package:flutter_dmzj/models/user/login_result_model.dart';
import 'package:flutter_dmzj/models/user/user_profile_model.dart';
import 'package:flutter_dmzj/requests/common/api.dart';
import 'package:flutter_dmzj/requests/common/http_client.dart';
import 'package:flutter_dmzj/services/user_service.dart';

class UserRequest {
  Future<LoginResultModel> login(
      {required String nickname, required String password}) async {
    var pwd = md5.convert(utf8.encode(password)).toString().toUpperCase();

    Map<String, dynamic> data = Api.getDefaultParameter();
    data.addAll({
      "_m": "D6132DCE99D329CACDE913C7FA952CF3",
      "_a": "05CDFDA93076FC56950D6598B94FD986",
      "_i": "8508AEE02C57308631D8E5F774D3AABC",
      "nickname": nickname,
      "pwd": pwd,
    });

    var result = await HttpClient.instance.postJson(
      "/loginV2/m_confirm",
      baseUrl: Api.BASE_URL_USER,
      data: data,
      formUrlEncoded: true,
    );
    var jsonResult = json.decode(result);
    if (jsonResult["result"] == 1) {
      var data = LoginResultModel.fromJson(jsonResult["data"]);
      return data;
    } else {
      throw AppError(jsonResult["msg"].toString());
    }
  }

  /// 用户资料
  Future<UserProfileModel> userProfile() async {
    var result = await HttpClient.instance.getJson(
      "/UCenter/comicsv2/${UserService.instance.userId}.json",
      baseUrl: Api.BASE_URL_V3,
      queryParameters: {
        "dmzj_token": UserService.instance.dmzjToken,
      }..addAll(
          Api.getDefaultParameter(),
        ),
    );

    return UserProfileModel.fromJson(result);
  }
}