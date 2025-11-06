// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************/

_$DNSSettings _$$DNSSettingsFromJson(Map<String, dynamic> json) =>
    _$DNSSettings(
      customDNS: json['customDNS'] as bool? ?? false,
      dnsServers: (json['dnsServers'] as List<dynamic>).map((e) => e as String).toList(),
      dnsOverHttps: json['dnsOverHttps'] as bool? ?? false,
      dohServer: json['dohServer'] as String?,
    );

Map<String, dynamic> _$$DNSSettingsToJson(_$DNSSettings instance) =>
    <String, dynamic>{
      'customDNS': instance.customDNS,
      'dnsServers': instance.dnsServers,
      'dnsOverHttps': instance.dnsOverHttps,
      'dohServer': instance.dohServer,
    };
