import 'package:flutter/material.dart';
import 'package:flutter_dmzj/services/local_storage_service.dart';
import 'package:get/get.dart';

class AppSettingsController extends GetxController {
  var themeMode = 0.obs;

  @override
  void onInit() {
    themeMode.value = LocalStorageService.instance
        .getValue(LocalStorageService.kThemeMode, 0);
    //漫画
    comicReaderDirection.value = LocalStorageService.instance
        .getValue(LocalStorageService.kComicReaderDirection, 0);
    comicReaderFullScreen.value = LocalStorageService.instance
        .getValue(LocalStorageService.kComicReaderFullScreen, true);
    comicReaderShowStatus.value = LocalStorageService.instance
        .getValue(LocalStorageService.kComicReaderShowStatus, true);
    comicReaderShowStatus.value = LocalStorageService.instance
        .getValue(LocalStorageService.kComicReaderShowStatus, true);
    comicReaderShowViewPoint.value = LocalStorageService.instance
        .getValue(LocalStorageService.kComicReaderShowViewPoint, true);
    //小说
    novelReaderDirection.value = LocalStorageService.instance
        .getValue(LocalStorageService.kNovelReaderDirection, 0);
    novelReaderFontSize.value = LocalStorageService.instance
        .getValue(LocalStorageService.kNovelReaderFontSize, 16);
    novelReaderLineSpacing.value = LocalStorageService.instance
        .getValue(LocalStorageService.kNovelReaderLineSpacing, 1.5);
    novelReaderTheme.value = LocalStorageService.instance
        .getValue(LocalStorageService.kNovelReaderTheme, 0);
    novelReaderFullScreen.value = LocalStorageService.instance
        .getValue(LocalStorageService.kNovelReaderFullScreen, true);
    novelReaderShowStatus.value = LocalStorageService.instance
        .getValue(LocalStorageService.kNovelReaderShowStatus, true);
    super.onInit();
  }

  void changeTheme() {
    Get.dialog(
      SimpleDialog(
        title: const Text("设置主题"),
        children: [
          RadioListTile<int>(
            title: const Text("跟随系统"),
            value: 0,
            groupValue: themeMode.value,
            onChanged: (e) {
              Get.back();
              setTheme(e ?? 0);
            },
          ),
          RadioListTile<int>(
            title: const Text("浅色模式"),
            value: 1,
            groupValue: themeMode.value,
            onChanged: (e) {
              Get.back();
              setTheme(e ?? 1);
            },
          ),
          RadioListTile<int>(
            title: const Text("深色模式"),
            value: 2,
            groupValue: themeMode.value,
            onChanged: (e) {
              Get.back();
              setTheme(e ?? 2);
            },
          ),
        ],
      ),
    );
  }

  void setTheme(int i) {
    themeMode.value = i;
    var mode = ThemeMode.values[i];

    LocalStorageService.instance.setValue(LocalStorageService.kThemeMode, i);
    Get.changeThemeMode(mode);
  }

  /// 漫画阅读方向
  /// * [0] 左右
  /// * [1] 上下
  /// * [2] 右左
  var comicReaderDirection = 0.obs;
  void setComicReaderDirection(int direction) {
    if (comicReaderDirection.value == direction) {
      return;
    }
    comicReaderDirection.value = direction;
    LocalStorageService.instance
        .setValue(LocalStorageService.kComicReaderDirection, direction);
  }

  /// 漫画全屏阅读
  RxBool comicReaderFullScreen = true.obs;
  void setComicReaderFullScreen(bool value) {
    comicReaderFullScreen.value = value;
    LocalStorageService.instance
        .setValue(LocalStorageService.kComicReaderFullScreen, value);
  }

  /// 漫画阅读显示状态信息
  RxBool comicReaderShowStatus = true.obs;
  void setComicReaderShowStatus(bool value) {
    comicReaderShowStatus.value = value;
    LocalStorageService.instance
        .setValue(LocalStorageService.kComicReaderShowStatus, value);
  }

  /// 漫画阅读尾页显示观点/吐槽
  RxBool comicReaderShowViewPoint = true.obs;
  void setComicReaderShowViewPoint(bool value) {
    comicReaderShowViewPoint.value = value;
    LocalStorageService.instance
        .setValue(LocalStorageService.kComicReaderShowViewPoint, value);
  }

  /// 小说阅读方向
  /// * [0] 左右
  /// * [1] 上下
  /// * [2] 右左
  var novelReaderDirection = 0.obs;
  void setNovelReaderDirection(int direction) {
    if (novelReaderDirection.value == direction) {
      return;
    }
    novelReaderDirection.value = direction;
    LocalStorageService.instance
        .setValue(LocalStorageService.kNovelReaderDirection, direction);
  }

  /// 小说字体
  var novelReaderFontSize = 16.obs;
  void setComicReaderFontSize(int size) {
    if (size < 5) {
      size = 5;
    }
    //应该没人需要这么大的字体吧...
    if (size > 56) {
      size = 56;
    }
    novelReaderFontSize.value = size;
    LocalStorageService.instance
        .setValue(LocalStorageService.kNovelReaderFontSize, size);
  }

  /// 小说行距
  var novelReaderLineSpacing = 1.5.obs;
  void setNovelReaderLineSpacing(double spacing) {
    if (spacing < 1) {
      spacing = 1;
    }
    //应该没人需要这么大的字体吧...
    if (spacing > 5) {
      spacing = 5;
    }
    novelReaderLineSpacing.value = spacing;
    LocalStorageService.instance
        .setValue(LocalStorageService.kNovelReaderLineSpacing, spacing);
  }

  /// 小说阅读主题
  var novelReaderTheme = 0.obs;
  void setNovelReaderTheme(int theme) {
    novelReaderTheme.value = theme;
    LocalStorageService.instance
        .setValue(LocalStorageService.kNovelReaderTheme, theme);
  }

  /// 漫画全屏阅读
  RxBool novelReaderFullScreen = true.obs;
  void setNovelReaderFullScreen(bool value) {
    novelReaderFullScreen.value = value;
    LocalStorageService.instance
        .setValue(LocalStorageService.kNovelReaderFullScreen, value);
  }

  /// 漫画阅读显示状态信息
  RxBool novelReaderShowStatus = true.obs;
  void setNovelReaderShowStatus(bool value) {
    novelReaderShowStatus.value = value;
    LocalStorageService.instance
        .setValue(LocalStorageService.kNovelReaderShowStatus, value);
  }
}