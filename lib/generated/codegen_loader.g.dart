// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _zh = {
  "app_name": "香蕉",
  "pixel": "像素",
  "feedback_title": "您的想法",
  "feedback_description": "请告诉我您想要的功能！\n我会尽最大努力添加功能的！",
  "send_feedback": "发送",
  "feedback_sent_success": "发送成功！",
  "select_languages": "选择语言",
  "updates": "更新"
};
static const Map<String,dynamic> _ja = {
  "app_name": "ワットザバナナ",
  "pixel": "ピクセル",
  "feedback_title": "あなたのアイデア",
  "feedback_description": "見たい機能を教えてください！\nできるだけ早く追加します！",
  "send_feedback": "送信",
  "feedback_sent_success": "送信しました！",
  "select_languages": "言語を選択",
  "updates": "更新"
};
static const Map<String,dynamic> _en = {
  "app_name": "What The Banana",
  "pixel": "Pixel",
  "feedback_title": "Your Ideas",
  "feedback_description": "Let us know what features\nyou'd like to see!\nWe'll do our best to add them!",
  "send_feedback": "SEND",
  "feedback_sent_success": "Successfully sent!",
  "select_languages": "Select Language",
  "updates": "Updates"
};
static const Map<String,dynamic> _ko = {
  "app_name": "왓더바나나",
  "pixel": "픽셀",
  "feedback_title": "Feedback",
  "feedback_description": "어떤 기능을 원하시는지 알려주세요!\n기능을 추가하기 위해\n최선을 다해보겠습니다!",
  "send_feedback": "전송",
  "feedback_sent_success": "전송 완료!",
  "select_languages": "언어 선택",
  "updates": "업데이트"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"zh": _zh, "ja": _ja, "en": _en, "ko": _ko};
}
