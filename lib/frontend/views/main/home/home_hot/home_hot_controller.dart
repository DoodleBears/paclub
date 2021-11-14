import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:paclub/frontend/constants/colors.dart';
import 'package:paclub/frontend/modules/pack_module.dart';
import 'package:paclub/frontend/modules/post_module.dart';
import 'package:paclub/frontend/modules/user_module.dart';
import 'package:paclub/frontend/widgets/notifications/toast.dart';
import 'package:paclub/models/feed_model.dart';
import 'package:paclub/models/pack_model.dart';
import 'package:paclub/models/post_model.dart';
import 'package:paclub/models/user_model.dart';
import 'package:paclub/utils/app_response.dart';
import 'package:paclub/utils/logger.dart';

enum LoadState { firstTime, moreOld, moreNew }

class HomeHotController extends GetxController {
  final PackModule _packModule = Get.find<PackModule>();
  final PostModule _postModule = Get.find<PostModule>();
  final UserModule _userModule = Get.find<UserModule>();

  double lastScrollOffset = 0.0;
  AxisDirection lastScrollDirection = AxisDirection.left;
  bool isAllowHeaderChange = false;

  List<PackModel> packList = <PackModel>[];
  List<PostModel> postList = <PostModel>[];

  List<FeedModel> feedList = <FeedModel>[];

  List<PackModel> moreOldPackList = <PackModel>[];
  List<PostModel> moreOldPostList = <PostModel>[];

  List<PackModel> moreNewPackList = <PackModel>[];
  List<PostModel> moreNewPostList = <PostModel>[];

  bool isLoading = false;
  bool isRefresh = false;
  bool isMoreOldPackExist = true;
  bool isMoreOldPostExist = true;
  int lastLength = 0;
  List<String> updatedPost = <String>[];
  List<String> updatedPack = <String>[];

  // MARK: 更新 Feed 信息
  // NOTE: 更新 Pack Feed
  Future<void> updatePackUserInfo({
    required PackModel packModel,
  }) async {
    // NOTE: 已经更新过返回
    if (updatedPack.contains(packModel.pid)) {
      logger.d('已更新过 Pack');
      return;
    }
    updatedPack.add(packModel.pid);
    logger.d('updatePackUserInfo');
    AppResponse appResponseUserProfile = await _userModule.getUserProfile(uid: packModel.ownerUid);

    if (appResponseUserProfile.data != null) {
      UserModel userModel = appResponseUserProfile.data;
      Map<String, dynamic> updateMap = {};

      if (packModel.ownerAvatarURL != userModel.avatarURL) {
        packModel.ownerAvatarURL = userModel.avatarURL;
        updateMap['ownerAvatarURL'] = userModel.avatarURL;
      }
      if (packModel.ownerName != userModel.displayName) {
        packModel.ownerName = userModel.displayName;
        updateMap['ownerName'] = userModel.displayName;
      }

      if (updateMap.isNotEmpty) {
        AppResponse appResponseUpdatePackProfile =
            await _packModule.updatePack(pid: packModel.pid, updateMap: updateMap);
        if (appResponseUpdatePackProfile.data == null) {
          logger.d('PackUserInfo 更新失败');
        }
      } else {
        logger.d('PackUserInfo 无需更新');
      }
    }
  }

  // NOTE: 更新 Post Feed
  Future<void> updatePostUserInfo({
    required PostModel postModel,
  }) async {
    if (updatedPost.contains(postModel.postId)) {
      logger.d('已更新过 Post');
      return;
    }
    updatedPost.add(postModel.postId);
    logger.d('updatePostUserInfo');
    AppResponse appResponseUserProfile = await _userModule.getUserProfile(uid: postModel.ownerUid);

    if (appResponseUserProfile.data != null) {
      UserModel userModel = appResponseUserProfile.data;
      Map<String, dynamic> updateMap = {};

      if (postModel.ownerAvatarURL != userModel.avatarURL) {
        postModel.ownerAvatarURL = userModel.avatarURL;
        updateMap['ownerAvatarURL'] = userModel.avatarURL;
      }
      if (postModel.ownerName != userModel.displayName) {
        postModel.ownerName = userModel.displayName;
        updateMap['ownerName'] = userModel.displayName;
      }

      if (updateMap.isNotEmpty) {
        AppResponse appResponseUpdatePackProfile =
            await _postModule.updatePost(postId: postModel.postId, updateMap: updateMap);
        if (appResponseUpdatePackProfile.data == null) {
          logger.d('PostUserInfo 更新失败');
        }
      } else {
        logger.d('PostUserInfo 无需更新');
      }
    }
  }

  // MARK: 首次加载 Feed
  Future<void> firstLoadFeed() async {
    if (isRefresh) {
      return;
    }
    logger.d('开始 firstLoadFeed');
    isRefresh = true;
    var processPack = _packModule.getPacksFirstTime(limit: 5);
    var processPost = _postModule.getPostsFirstTime(limit: 20);

    AppResponse appResponsePack = await processPack;
    if (appResponsePack.data != null) {
      List<PackModel> tempPackList = appResponsePack.data;
      if (appResponsePack.message == 'no_more_history_pack') {
        logger.w(appResponsePack.message);
        isMoreOldPackExist = false;
      }
      if (packList.isEmpty) {
        packList = List<PackModel>.from(tempPackList);
      } else if (packList.first.lastUpdateAt != tempPackList.first.lastUpdateAt) {
        packList = List<PackModel>.from(appResponsePack.data);
      }
    } else {
      return;
    }
    AppResponse appResponsePost = await processPost;
    if (appResponsePost.data != null) {
      List<PostModel> tempPostList = appResponsePost.data;
      if (appResponsePost.message == 'no_more_history_post') {
        logger.w(appResponsePost.message);
        isMoreOldPostExist = false;
      }
      if (postList.isEmpty) {
        // NOTE: 如果是空，直接采用
        postList = List<PostModel>.from(tempPostList);
      } else if (tempPostList.first.lastUpdateAt != postList.first.lastUpdateAt) {
        // NOTE: 如果非空，且最新 Post 不同，则采用

        postList = List<PostModel>.from(appResponsePost.data);
      }
    } else {
      return;
    }

    isRefresh = false;
    genreateFeed(loadState: LoadState.firstTime);
  }

  // MARK: 加载更多 新Feed
  Future<void> loadMoreNewFeed() async {
    if (isRefresh) {
      return;
    }
    HapticFeedback.lightImpact();

    if (feedList.isEmpty) {
      await firstLoadFeed();
      return;
    } else {
      var processPack = _packModule.getNewFeedPacks(firstPackDoc: packList.first.documentSnapshot);
      var processPost = _postModule.getNewFeedPosts(firstPostDoc: postList.first.documentSnapshot);
      bool isPackUpdate = true;
      bool isPostUpdate = true;

      AppResponse appResponsePack = await processPack;
      if (appResponsePack.data != null) {
        List<PackModel> tempPackList = appResponsePack.data;

        if (tempPackList.isNotEmpty) {
          moreNewPackList = List<PackModel>.from(appResponsePack.data);
          packList.insertAll(0, moreNewPackList); // 更新 pack List
        } else {
          isPackUpdate = false;
        }
      } else {
        toastTop('Fetch Pack Fail');
        return;
      }
      AppResponse appResponsePost = await processPost;
      if (appResponsePost.data != null) {
        List<PostModel> tempPostList = appResponsePost.data;

        if (tempPostList.isNotEmpty) {
          moreNewPostList = List<PostModel>.from(appResponsePost.data);
          postList.insertAll(0, moreNewPostList); // 更新 post List
        } else {
          isPostUpdate = false;
        }
      } else {
        toastTop('Fetch Post Fail');
        return;
      }
      if (isPackUpdate == false && isPostUpdate == false) {
        toastTop('No New Post & Pack');
      } else {
        genreateFeed(loadState: LoadState.moreNew);
      }
    }
  }

  // MARK: 加载更多 历史Feed
  Future<void> loadMoreOldFeed(int length) async {
    // NOTICE: 注意因为采用接触底部自动加载，所以需要判断是否是首次接触底部
    // 是首次接触底部才需要加载，否则不需要（防止无限加载）
    if (isLoading) return;
    if (length == lastLength) {
      return;
    }
    lastLength = length;

    var processPack = loadMoreOldPacks();
    var processPost = loadMoreOldPosts();
    isLoading = true;
    await processPack;
    await processPost;

    if (moreOldPackList.isEmpty && moreOldPostList.isEmpty) {
      toastTop('No More Data');
      logger.w('No More Data');
    } else {
      genreateFeed(loadState: LoadState.moreOld);
    }
  }

  // NOTE: 加载更多历史 Post
  Future<void> loadMoreOldPosts({int limit = 20}) async {
    if (isMoreOldPostExist == false) return;

    logger.i('开始加载更早的 Post —— loadMoreOldPosts');
    AppResponse appResponse;
    // NOTE: 当历史列表为空，有可能是第一次进入页面，或是网络重连后，再该页面刷新
    if (postList.isEmpty) {
      appResponse = await _postModule.getPostsFirstTime();
    } else {
      // NOTE: 历史列表不为空, 则基于最早的历史消息, 作为起点, 拉取更早的消息
      appResponse = await _postModule.getMorePosts(
        limit: limit,
        lastPostDoc: postList.last.documentSnapshot,
      );
    }
    if (appResponse.data != null) {
      if (appResponse.message == 'no_more_history_post') {
        isMoreOldPostExist = false;
      }
      moreOldPostList = List<PostModel>.from(appResponse.data);
      postList.addAll(moreOldPostList); // 更新 postList, 将更旧的 post 加到最后
    }
  }

  // NOTE: 加载更多历史 Pack
  Future<void> loadMoreOldPacks({int limit = 5}) async {
    if (isMoreOldPackExist == false) return;
    logger.i('开始加载 loadMorePacks');
    AppResponse appResponse;
    // NOTE: 当历史列表为空，有可能是第一次进入页面，或是网络重连后，再该页面刷新
    if (packList.isEmpty) {
      appResponse = await _packModule.getPacksFirstTime();
    } else {
      // NOTE: 历史列表不为空, 则基于最早的历史消息, 作为起点, 拉取更早的消息
      appResponse = await _packModule.getMorePacks(
        limit: limit,
        lastPackDoc: packList.last.documentSnapshot,
      );
    }
    if (appResponse.data != null) {
      if (appResponse.message == 'no_more_history_pack') {
        isMoreOldPackExist = false;
      }
      moreOldPackList = List<PackModel>.from(appResponse.data);
      packList.addAll(moreOldPackList); // 更新 packList, 将更旧的 pack 加到最后
    }
  }

  void genreateFeed({required LoadState loadState}) {
    if (loadState == LoadState.firstTime) {
      feedList = List.from(postList); // 直接拿 feedList 组合
      feedList.addAll(packList);
      feedList.sort(sortFeedList);
      logger.wtf(
          '首次加载了: ${feedList.length} 条 feeds\n${packList.length} 条 Pack\n${postList.length} 条 Post');
      isRefresh = false;
    } else if (loadState == LoadState.moreOld) {
      List<FeedModel> temp = List.from(moreOldPostList);
      temp.addAll(moreOldPackList); // 合并 Post 和 Pack
      temp.sort(sortFeedList); // 排序
      // NOTE: 然后在添加到 feedList 末尾
      feedList.addAll(temp);
      logger.wtf(
          '加载了: ${temp.length} 条历史 feeds\n${moreOldPackList.length} 条 Pack\n${moreOldPostList.length} 条 Post');
      moreOldPostList.clear();
      moreOldPackList.clear();
      isLoading = false;
    } else if (loadState == LoadState.moreNew) {
      List<FeedModel> temp = List.from(moreNewPostList);
      temp.addAll(moreNewPackList); // 合并 Post 和 Pack
      temp.sort(sortFeedList); // 排序
      // NOTE: 然后在添加到 feedList 头部
      feedList.insertAll(0, temp);
      logger.wtf(
          '加载了: ${temp.length} 条最新 feeds\n${moreNewPackList.length} 条 Pack\n${moreNewPostList.length} 条 Post');
      isRefresh = false;
      toastTop(
        '${temp.length} new feeds',
        backgroundColor: accentColor,
      );
    }
    update();
  }

  int sortFeedList(FeedModel a, FeedModel b) {
    double sumA = a.thumbUpCount * 0.5 + a.commentCount + a.favoriteCount + a.shareCount * 1.5;
    double sumB = b.thumbUpCount * 0.5 + b.commentCount + b.favoriteCount + b.shareCount * 1.5;
    if (sumA <= 0.5) {
      sumA = 0.5;
    }
    if (sumB <= 0.5) {
      sumB = 0.5;
    }
    // final DateTime createdAtA = a.createdAt.toDate().toLocal();
    // final DateTime createdAtB = b.createdAt.toDate().toLocal();
    final DateTime lastUpdateAtA = a.lastUpdateAt.toDate().toLocal();
    final DateTime lastUpdateAtB = b.lastUpdateAt.toDate().toLocal();
    final DateTime now = DateTime.now();
    // NOTICE: 按照天数，距离现在越久，在拥有同样评价时候，效果越差
    double ratioA = 1.0;
    if (now.subtract(const Duration(days: 90)).isAfter(lastUpdateAtA)) {
      // 如果是 90天 以前的
      ratioA = 0.5;
    } else if (now.subtract(const Duration(days: 30)).isAfter(lastUpdateAtA)) {
      // 如果是 30天 以前的
      ratioA = 0.6;
    } else if (now.subtract(const Duration(days: 7)).isAfter(lastUpdateAtA)) {
      // 如果是 7天 以前的
      ratioA = 0.9;
    }
    double ratioB = 1.0;
    if (now.subtract(const Duration(days: 90)).isAfter(lastUpdateAtB)) {
      // 如果是 90天 以前的
      ratioB = 0.5;
    } else if (now.subtract(const Duration(days: 30)).isAfter(lastUpdateAtB)) {
      // 如果是 30天 以前的
      ratioB = 0.6;
    } else if (now.subtract(const Duration(days: 7)).isAfter(lastUpdateAtB)) {
      // 如果是 7天 以前的
      ratioB = 0.9;
    }
    int compare = (sumA * ratioA).compareTo(sumB * ratioB);
    if (compare != 0) {
      return -compare;
    } else {
      return -a.lastUpdateAt.compareTo(b.lastUpdateAt);
    }
  }

  @override
  void onInit() {
    logger.i('启用 HomeHotController');
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // 第一次加载首页信息
    firstLoadFeed();
  }

  @override
  void onClose() {
    logger.w('关闭 HomeHotController');
    super.onClose();
  }
}
