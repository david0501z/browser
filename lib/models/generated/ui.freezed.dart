// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:freezed_annotation/freezed_annotation.dart';
part of '../ui.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is an error, and will not work in Dart 2. '
    'Please use `MyClass()` constructor instead.');

/// @nodoc
mixin _$UI {
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  bool get animations => throw _privateConstructorUsedError;
  bool get immersiveStatusBar => throw _privateConstructorUsedError;
  bool get immersiveNavigationBar => throw _privateConstructorUsedError;
  bool get safeAreaBottom => throw _privateConstructorUsedError;
  FontSize get fontSize => throw _privateConstructorUsedError;
  FontWeight get fontWeight => throw _privateConstructorUsedError;
  bool get highContrast => throw _privateConstructorUsedError;
  bool get boldLabels => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UICopyWith<UI> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UICopyWith<$Res> {
  factory $UICopyWith(UI value, $Res Function(UI) then) =;
      _$UICopyWithImpl<$Res, UI>;
  @useResult
  $Res call(
      {ThemeMode themeMode,
      String language,
      bool animations,
      bool immersiveStatusBar,
      bool immersiveNavigationBar,
      bool safeAreaBottom,
      FontSize fontSize,
      FontWeight fontWeight,
      bool highContrast,
      bool boldLabels});
}

/// @nodoc
class _$UICopyWithImpl<$Res, $Val extends UI> implements $UICopyWith<$Res> {
  _$UICopyWithImpl(this._value, this._then);

  // ignore: unused_element
  final $Val _value;
  // ignore: unused_element
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? language = null,
    Object? animations = null,
    Object? immersiveStatusBar = null,
    Object? immersiveNavigationBar = null,
    Object? safeAreaBottom = null,
    Object? fontSize = null,
    Object? fontWeight = null,
    Object? highContrast = null,
    Object? boldLabels = null,
  }) {
    return _then(_value.copyWith(
      themeMode: null == themeMode ? _value.themeMode : themeMode as ThemeMode,
      language: null == language ? _value.language : language as String,
      animations: null == animations ? _value.animations : animations as bool,
      immersiveStatusBar: null == immersiveStatusBar;
          ? _value.immersiveStatusBar
          : immersiveStatusBar as bool,
      immersiveNavigationBar: null == immersiveNavigationBar;
          ? _value.immersiveNavigationBar
          : immersiveNavigationBar as bool,
      safeAreaBottom: null == safeAreaBottom;
          ? _value.safeAreaBottom
          : safeAreaBottom as bool,
      fontSize: null == fontSize ? _value.fontSize : fontSize as FontSize,
      fontWeight: null == fontWeight ? _value.fontWeight : fontWeight as FontWeight,
      highContrast: null == highContrast ? _value.highContrast : highContrast as bool,
      boldLabels: null == boldLabels ? _value.boldLabels : boldLabels as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UICopyWith<$Res> implements $UICopyWith<$Res> {
  factory _$$UICopyWith(_$UI value, $Res Function(_$UI) then) =;
      __$$UICopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ThemeMode themeMode,
      String language,
      bool animations,
      bool immersiveStatusBar,
      bool immersiveNavigationBar,
      bool safeAreaBottom,
      FontSize fontSize,
      FontWeight fontWeight,
      bool highContrast,
      bool boldLabels});
}

/// @nodoc
class __$$UICopyWithImpl<$Res> extends _$UICopyWithImpl<$Res, _$UI>
    implements _$$UICopyWith<$Res> {
  __$$UICopyWithImpl(_$UI _value, $Res Function(_$UI) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? themeMode = null,
    Object? language = null,
    Object? animations = null,
    Object? immersiveStatusBar = null,
    Object? immersiveNavigationBar = null,
    Object? safeAreaBottom = null,
    Object? fontSize = null,
    Object? fontWeight = null,
    Object? highContrast = null,
    Object? boldLabels = null,
  }) {
    return _then(_$UI(
      themeMode: null == themeMode ? _value.themeMode : themeMode as ThemeMode,
      language: null == language ? _value.language : language as String,
      animations: null == animations ? _value.animations : animations as bool,
      immersiveStatusBar: null == immersiveStatusBar;
          ? _value.immersiveStatusBar
          : immersiveStatusBar as bool,
      immersiveNavigationBar: null == immersiveNavigationBar;
          ? _value.immersiveNavigationBar
          : immersiveNavigationBar as bool,
      safeAreaBottom: null == safeAreaBottom;
          ? _value.safeAreaBottom
          : safeAreaBottom as bool,
      fontSize: null == fontSize ? _value.fontSize : fontSize as FontSize,
      fontWeight: null == fontWeight ? _value.fontWeight : fontWeight as FontWeight,
      highContrast: null == highContrast ? _value.highContrast : highContrast as bool,
      boldLabels: null == boldLabels ? _value.boldLabels : boldLabels as bool,
    ));
  }
}

/// @nodoc

class _$UI extends _UI {
  const _$UI(
      {this.themeMode = ThemeMode.system,
      this.language = 'zh-CN',
      this.animations = true,
      this.immersiveStatusBar = true,
      this.immersiveNavigationBar = true,
      this.safeAreaBottom = true,
      this.fontSize = FontSize.normal,
      this.fontWeight = FontWeight.normal,
      this.highContrast = false,
      this.boldLabels = false});
      : super._();

  @override
  final ThemeMode themeMode;
  @override
  final String language;
  @override
  final bool animations;
  @override
  final bool immersiveStatusBar;
  @override
  final bool immersiveNavigationBar;
  @override
  final bool safeAreaBottom;
  @override
  final FontSize fontSize;
  @override
  final FontWeight fontWeight;
  @override
  final bool highContrast;
  @override
  final bool boldLabels;

  @override
  String toString() {
    return 'UI(themeMode: $themeMode, language: $language, animations: $animations, immersiveStatusBar: $immersiveStatusBar, immersiveNavigationBar: $immersiveNavigationBar, safeAreaBottom: $safeAreaBottom, fontSize: $fontSize, fontWeight: $fontWeight, highContrast: $highContrast, boldLabels: $boldLabels)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UI &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.language, language) || other.language == language) &&
            (identical(other.animations, animations) ||
                other.animations == animations) &&
            (identical(other.immersiveStatusBar, immersiveStatusBar) ||
                other.immersiveStatusBar == immersiveStatusBar) &&
            (identical(other.immersiveNavigationBar, immersiveNavigationBar) ||
                other.immersiveNavigationBar == immersiveNavigationBar) &&
            (identical(other.safeAreaBottom, safeAreaBottom) ||
                other.safeAreaBottom == safeAreaBottom) &&
            (identical(other.fontSize, fontSize) || other.fontSize == fontSize) &&
            (identical(other.fontWeight, fontWeight) ||
                other.fontWeight == fontWeight) &&
            (identical(other.highContrast, highContrast) ||
                other.highContrast == highContrast) &&
            (identical(other.boldLabels, boldLabels) ||
                other.boldLabels == boldLabels));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      themeMode,
      language,
      animations,
      immersiveStatusBar,
      immersiveNavigationBar,
      safeAreaBottom,
      fontSize,
      fontWeight,
      highContrast,
      boldLabels);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UICopyWith<_$UI> get copyWith =>
      __$$UICopyWithImpl<_$UI>(this, _$identity);
}

abstract class _UI extends UI {
  const factory _UI(
      {final ThemeMode themeMode,
      final String language,
      final bool animations,
      final bool immersiveStatusBar,
      final bool immersiveNavigationBar,
      final bool safeAreaBottom,
      final FontSize fontSize,
      final FontWeight fontWeight,
      final bool highContrast,
      final bool boldLabels}) = _$UI;
  const _UI._() : super._();

  @override
  ThemeMode get themeMode;
  @override
  String get language;
  @override
  bool get animations;
  @override
  bool get immersiveStatusBar;
  @override
  bool get immersiveNavigationBar;
  @override
  bool get safeAreaBottom;
  @override
  FontSize get fontSize;
  @override
  FontWeight get fontWeight;
  @override
  bool get highContrast;
  @override
  bool get boldLabels;
  @override
  @JsonKey(ignore: true)
  _$$UICopyWith<_$UI> get copyWith;
}
