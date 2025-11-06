// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:freezed_annotation/freezed_annotation.dart';
part of '../app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is an error, and will not work in Dart 2. '
    'Please use `MyClass()` constructor instead.');

/// @nodoc
mixin _$RuleSettings {
  bool get customRules => throw _privateConstructorUsedError;
  String? get rulePath => throw _privateConstructorUsedError;
  RuleType get ruleType => throw _privateConstructorUsedError;
  bool get adBlock => throw _privateConstructorUsedError;
  bool get trackingBlock => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RuleSettingsCopyWith<RuleSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RuleSettingsCopyWith<$Res> {
  factory $RuleSettingsCopyWith(
          RuleSettings value, $Res Function(RuleSettings) then) =
      _$RuleSettingsCopyWithImpl<$Res, RuleSettings>;
  @useResult
  $Res call(
      {bool customRules,
      String? rulePath,
      RuleType ruleType,
      bool adBlock,
      bool trackingBlock});
}

/// @nodoc
class _$RuleSettingsCopyWithImpl<$Res, $Val extends RuleSettings>
    implements $RuleSettingsCopyWith<$Res> {
  _$RuleSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_element
  final $Val _value;
  // ignore: unused_element
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customRules = null,
    Object? rulePath = freezed,
    Object? ruleType = null,
    Object? adBlock = null,
    Object? trackingBlock = null,
  }) {
    return _then(_value.copyWith(
      customRules: null == customRules ? _value.customRules : customRules as bool,
      rulePath: freezed == rulePath ? _value.rulePath : rulePath as String?,
      ruleType: null == ruleType ? _value.ruleType : ruleType as RuleType,
      adBlock: null == adBlock ? _value.adBlock : adBlock as bool,
      trackingBlock: null == trackingBlock
          ? _value.trackingBlock
          : trackingBlock as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RuleSettingsCopyWith<$Res>
    implements $RuleSettingsCopyWith<$Res> {
  factory _$$RuleSettingsCopyWith(
          _$RuleSettings value, $Res Function(_$RuleSettings) then) =
      __$$RuleSettingsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool customRules,
      String? rulePath,
      RuleType ruleType,
      bool adBlock,
      bool trackingBlock});
}

/// @nodoc
class __$$RuleSettingsCopyWithImpl<$Res>
    extends _$RuleSettingsCopyWithImpl<$Res, _$RuleSettings>
    implements _$$RuleSettingsCopyWith<$Res> {
  __$$RuleSettingsCopyWithImpl(
      _$RuleSettings _value, $Res Function(_$RuleSettings) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customRules = null,
    Object? rulePath = freezed,
    Object? ruleType = null,
    Object? adBlock = null,
    Object? trackingBlock = null,
  }) {
    return _then(_$RuleSettings(
      customRules: null == customRules ? _value.customRules : customRules as bool,
      rulePath: freezed == rulePath ? _value.rulePath : rulePath as String?,
      ruleType: null == ruleType ? _value.ruleType : ruleType as RuleType,
      adBlock: null == adBlock ? _value.adBlock : adBlock as bool,
      trackingBlock: null == trackingBlock
          ? _value.trackingBlock
          : trackingBlock as bool,
    ));
  }
}

/// @nodoc

class _$RuleSettings extends _RuleSettings {
  const _$RuleSettings(
      {this.customRules = false,
      this.rulePath,
      this.ruleType = RuleType.auto,
      this.adBlock = true,
      this.trackingBlock = true})
      : super._();

  @override
  final bool customRules;
  @override
  final String? rulePath;
  @override
  final RuleType ruleType;
  @override
  final bool adBlock;
  @override
  final bool trackingBlock;

  @override
  String toString() {
    return 'RuleSettings(customRules: $customRules, rulePath: $rulePath, ruleType: $ruleType, adBlock: $adBlock, trackingBlock: $trackingBlock)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RuleSettings &&
            (identical(other.customRules, customRules) ||
                other.customRules == customRules) &&
            (identical(other.rulePath, rulePath) ||
                other.rulePath == rulePath) &&
            (identical(other.ruleType, ruleType) ||
                other.ruleType == ruleType) &&
            (identical(other.adBlock, adBlock) || other.adBlock == adBlock) &&
            (identical(other.trackingBlock, trackingBlock) ||
                other.trackingBlock == trackingBlock));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, customRules, rulePath, ruleType, adBlock, trackingBlock);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RuleSettingsCopyWith<_$RuleSettings> get copyWith =>
      __$$RuleSettingsCopyWithImpl<_$RuleSettings>(this, _$identity);
}

abstract class _RuleSettings extends RuleSettings {
  const factory _RuleSettings(
      {final bool customRules,
      final String? rulePath,
      final RuleType ruleType,
      final bool adBlock,
      final bool trackingBlock}) = _$RuleSettings;
  const _RuleSettings._() : super._();

  @override
  bool get customRules;
  @override
  String? get rulePath;
  @override
  RuleType get ruleType;
  @override
  bool get adBlock;
  @override
  bool get trackingBlock;
  @override
  @JsonKey(ignore: true)
  _$$RuleSettingsCopyWith<_$RuleSettings> get copyWith;
}
