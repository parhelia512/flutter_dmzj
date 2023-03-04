import 'package:flutter_dmzj/app/app_error.dart';
import 'package:flutter_dmzj/models/comic/category_comic_model.dart';
import 'package:flutter_dmzj/models/comic/category_filter_model.dart';
import 'package:flutter_dmzj/models/comic/category_item_model.dart';
import 'package:flutter_dmzj/models/comic/recommend_model.dart';
import 'package:flutter_dmzj/models/comic/special_model.dart';
import 'package:flutter_dmzj/models/proto/comic.pb.dart';
import 'package:flutter_dmzj/requests/common/http_client.dart';

import '../models/comic/special_detail_model.dart';

class ComicRequest {
  /// 漫画-推荐
  Future<List<ComicRecommendModel>> recommend() async {
    var list = <ComicRecommendModel>[];
    var result = await HttpClient.instance.getJson(
      '/recommend_new.json',
    );
    for (var item in result) {
      list.add(ComicRecommendModel.fromJson(item));
    }
    return list;
  }

  /// 猜你喜欢
  Future<ComicRecommendModel> refreshRecommend(int categoryId) async {
    var result = await HttpClient.instance.getJson(
      '/recommend/batchUpdate',
      needLogin: true,
      queryParameters: {
        "category_id": categoryId,
      },
    );
    var model = ComicRecommendModel.fromJson(result["data"]);
    for (var item in model.data) {
      if (categoryId == 50) {
        item.objId = item.id;
        item.type = 1;
      }
    }
    return model;
  }

  // TODO 我的订阅

  /// 最近更新
  Future<List<ComicUpdateListInfoProto>> latest(
      {required int type, int page = 1}) async {
    var result = await HttpClient.instance.getEncryptV4(
      '/comic/update/list/$type/$page',
      needLogin: true,
    );
    var data = ComicUpdateListResponseProto.fromBuffer(result);
    if (data.errno != 0) {
      throw AppError(data.errmsg);
    }
    return data.data;
  }

  /// 分类
  Future<List<ComicCategoryItemModel>> categores() async {
    var list = <ComicCategoryItemModel>[];
    var result = await HttpClient.instance.getJson(
      '/0/category.json',
    );
    for (var item in result) {
      list.add(ComicCategoryItemModel.fromJson(item));
    }
    return list;
  }

  /// 分类-筛选
  Future<List<ComicCategoryFilterModel>> categoryFilter() async {
    var list = <ComicCategoryFilterModel>[];
    var result = await HttpClient.instance.getJson(
      '/classify/filter.json',
    );
    for (var item in result) {
      list.add(ComicCategoryFilterModel.fromJson(item));
    }
    return list;
  }

  /// 分类下漫画
  /// - [ids] 标签
  /// - [sort] 排序,0=人气,1=更新
  /// - [page] 页数
  Future<List<ComicCategoryComicModel>> categoryComic({
    required List<int> ids,
    int sort = 0,
    int page = 1,
  }) async {
    var path = "classify/";
    for (var item in ids) {
      if (item != 0) {
        path += "$item-";
      }
    }
    if (path == "classify/") {
      path = "classify/0";
    } else {
      path = path.substring(0, path.length - 1);
    }

    var list = <ComicCategoryComicModel>[];
    var result = await HttpClient.instance.getJson(
      '/$path/$sort/$page.json',
    );
    for (var item in result) {
      list.add(ComicCategoryComicModel.fromJson(item));
    }
    return list;
  }

  /// 排行榜
  Future<List<ComicRankListInfoProto>> rank({
    required int tagId,
    required byTime,
    required rankType,
    int page = 1,
  }) async {
    var result = await HttpClient.instance.getEncryptV4(
      '/comic/rank/list',
      queryParameters: {
        'tag_id': tagId,
        'by_time': byTime,
        'rank_type': rankType,
        'page': page
      },
      needLogin: true,
    );
    var data = ComicRankListResponseProto.fromBuffer(result);
    if (data.errno != 0) {
      throw AppError(data.errmsg);
    }
    return data.data;
  }

  /// 排行榜-分类
  Future<Map<int, String>> rankFilter() async {
    var result = await HttpClient.instance.getJson(
      '/rank/type_filter.json',
    );
    Map<int, String> map = {};
    for (var item in result) {
      map.addAll({
        item["tag_id"]: item["tag_name"],
      });
    }
    return map;
  }

  /// 专题
  Future<List<ComicSpecialModel>> special({int page = 1}) async {
    var list = <ComicSpecialModel>[];
    var result = await HttpClient.instance.getJson(
      '/subject/0/$page.json',
    );
    for (var item in result) {
      list.add(ComicSpecialModel.fromJson(item));
    }
    return list;
  }

  /// 专题
  Future<ComicSpecialDetailModel> specialDetail({required int id}) async {
    var result = await HttpClient.instance.getJson(
      '/subject/$id.json',
    );

    return ComicSpecialDetailModel.fromJson(result);
  }
}
