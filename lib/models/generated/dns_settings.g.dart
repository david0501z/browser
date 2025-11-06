// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../dns_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************/

_$DNSConfiguration _$$DNSConfigurationFromJson(Map<String, dynamic> json) =>
    _$DNSConfiguration(
      customDNS: json['customDNS'] as bool? ?? false,
      dnsServers: (json['dnsServers'] as List<dynamic>).map((e) => e as String).toList(),
      dnsOverHttps: json['dnsOverHttps'] as bool? ?? false,
      dohServer: json['dohServer'] as String?,
    );

Map<String, dynamic> _$$DNSConfigurationToJson(_$DNSConfiguration instance) =>
    <String, dynamic>{
      'customDNS': instance.customDNS,
      'dnsServers': instance.dnsServers,
      'dnsOverHttps': instance.dnsOverHttps,
      'dohServer': instance.dohServer,
    };
