import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicalarm/entity/timestamp.dart';

part 'setting.g.dart';
part 'setting.freezed.dart';

/// アプリの設定情報を管理するEntity
///
/// ユーザーの設定項目をFirestoreで永続化するためのデータ構造です。
/// AlarmKit機能やCritical Alert設定を管理します。
@freezed
class Setting with _$Setting {
  @JsonSerializable(explicitToJson: true)
  const factory Setting({
    /// ユーザーID
    required String userID,

    /// AlarmKit機能の有効フラグ
    ///
    /// trueの場合、iOS 26+でAlarmKitを使用して服薬リマインダーを送信します。
    /// サイレントモード・フォーカスモード時でも確実に通知が表示されます。
    /// iOS 26未満やAndroidでは既存のlocal notificationが使用されます。
    @Default(false) bool useAlarmKit,

    /// 緊急アラートの音量レベル
    ///
    /// 0.0-1.0の範囲で緊急アラート時の音量を指定します。
    /// デフォルトは0.5（50%）に設定されています。
    @Default(0.5) double criticalAlertVolume,

    /// 作成日時
    @ClientCreatedTimestamp() DateTime? createdDateTime,

    /// 更新日時
    @ClientUpdatedTimestamp() DateTime? updatedDateTime,

    /// サーバー作成日時
    @ServerCreatedTimestamp() DateTime? serverCreatedDateTime,

    /// サーバー更新日時
    @ServerUpdatedTimestamp() DateTime? serverUpdatedDateTime,
  }) = _Setting;

  factory Setting.fromJson(Map<String, dynamic> json) => _$SettingFromJson(json);
  const Setting._();

  /// 初期設定を作成する
  ///
  /// ユーザー登録時に使用するデフォルト設定を生成します。
  static Setting initial({required String userID}) {
    return Setting(userID: userID);
  }
}
