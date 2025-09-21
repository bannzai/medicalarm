import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_parameter.freezed.dart';
part 'remote_config_parameter.g.dart';

abstract class RemoteConfigKeys {
  static const minimumAppVersion = 'minimumAppVersion';
  static const promotionDayCount = 'promotionDayCount';
  static const releasedVersion = 'releasedVersion';
}

abstract class RemoteConfigParameterDefaultValues {
  static const minimumAppVersion = '1.0.0';
  static const promotionDayCount = 7;
  static const releasedVersion = '1.0.0';
}

@freezed
// [RemoteConfigDefaultValues] でgrepした場所に全て設定する
class RemoteConfigParameter with _$RemoteConfigParameter {
  const factory RemoteConfigParameter({
    @Default(RemoteConfigParameterDefaultValues.minimumAppVersion) String minimumAppVersion,
    @Default(RemoteConfigParameterDefaultValues.promotionDayCount) int promotionDayCount,
    @Default(RemoteConfigParameterDefaultValues.releasedVersion) String releasedVersion,
  }) = _RemoteConfigParameter;

  const RemoteConfigParameter._();

  factory RemoteConfigParameter.fromJson(Map<String, dynamic> json) => _$RemoteConfigParameterFromJson(json);
}
