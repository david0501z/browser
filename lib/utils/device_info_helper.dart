import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// 设备信息助手工具类
/// 提供跨平台设备信息获取和兼容性检测功能
class DeviceInfoHelper {
  static const MethodChannel _channel = MethodChannel('device_info_helper');
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  static final PackageInfo _packageInfo = PackageInfo();

  /// 获取Android设备信息
  static Future<Map<String, dynamic>> getAndroidInfo() async {
    if (!Platform.isAndroid) {
      throw UnsupportedError('This method only supports Android platform');
    }

    try {
      final androidInfo = await _deviceInfo.androidInfo;
      
      return {
        'version': androidInfo.version.release,
        'apiLevel': androidInfo.version.sdkInt,
        'model': androidInfo.model,
        'manufacturer': androidInfo.manufacturer,
        'brand': androidInfo.brand,
        'device': androidInfo.device,
        'product': androidInfo.product,
        'hardware': androidInfo.hardware,
        'id': androidInfo.id,
        'buildId': androidInfo.id,
        'type': androidInfo.type,
        'tags': androidInfo.tags,
        'fingerprint': androidInfo.fingerprint,
        'isPhysicalDevice': androidInfo.isPhysicalDevice,
        'systemFeatures': androidInfo.systemFeatures,
        'serialNumber': androidInfo.serialNumber,
        'bootloader': androidInfo.bootloader,
        'buildNumber': androidInfo.version.incremental,
        'codeName': androidInfo.version.codename,
        'baseOS': androidInfo.version.baseOS,
        'previewSdkInt': androidInfo.version.previewSdkInt,
        'securityPatch': androidInfo.version.securityPatch,
      };
    } catch (e) {
      throw Exception('Failed to get Android info: $e');
    }
  }

  /// 获取iOS设备信息
  static Future<Map<String, dynamic>> getIOSInfo() async {
    if (!Platform.isIOS) {
      throw UnsupportedError('This method only supports iOS platform');
    }

    try {
      final iosInfo = await _deviceInfo.iosInfo;
      
      return {
        'model': iosInfo.model,
        'name': iosInfo.name,
        'systemName': iosInfo.systemName,
        'systemVersion': iosInfo.systemVersion,
        'identifierForVendor': iosInfo.identifierForVendor,
        'isPhysicalDevice': iosInfo.isPhysicalDevice,
        'utsname': {
          'machine': iosInfo.utsname.machine,
          'nodename': iosInfo.utsname.nodename,
          'release': iosInfo.utsname.release,
          'sysname': iosInfo.utsname.sysname,
          'version': iosInfo.utsname.version,
        },
      };
    } catch (e) {
      throw Exception('Failed to get iOS info: $e');
    }
  }

  /// 获取Web设备信息
  static Future<Map<String, dynamic>> getWebInfo() async {
    if (!kIsWeb) {
      throw UnsupportedError('This method only supports Web platform');
    }

    try {
      final webInfo = await _deviceInfo.webBrowserInfo;
      
      return {
        'browserName': webInfo.browserName.toString(),
        'deviceMemory': webInfo.deviceMemory,
        'hardwareConcurrency': webInfo.hardwareConcurrency,
        'language': webInfo.language,
        'maxTouchPoints': webInfo.maxTouchPoints,
        'platform': webInfo.platform,
        'userAgent': webInfo.userAgent,
        'vendor': webInfo.vendor,
        'vendorSub': webInfo.vendorSub,
        'product': webInfo.product,
        'productSub': webInfo.productSub,
        'appCodeName': webInfo.appCodeName,
        'appName': webInfo.appName,
        'appVersion': webInfo.appVersion,
        'platformExtras': webInfo.platformExtras,
        'webDriver': webInfo.webDriver,
      };
    } catch (e) {
      throw Exception('Failed to get Web info: $e');
    }
  }

  /// 获取Windows设备信息
  static Future<Map<String, dynamic>> getWindowsInfo() async {
    if (!Platform.isWindows) {
      throw UnsupportedError('This method only supports Windows platform');
    }

    try {
      final windowsInfo = await _deviceInfo.windowsInfo;
      
      return {
        'computerName': windowsInfo.computerName,
        'numberOfCores': windowsInfo.numberOfCores,
        'systemMemoryInMegabytes': windowsInfo.systemMemoryInMegabytes,
        'buildNumber': windowsInfo.buildNumber,
        'platform': windowsInfo.platform,
        'productName': windowsInfo.productName,
        'displayVersion': windowsInfo.displayVersion,
        'editionId': windowsInfo.editionId,
        'installDate': windowsInfo.installDate,
        'productId': windowsInfo.productId,
        'registeredOwner': windowsInfo.registeredOwner,
        'systemManufacturer': windowsInfo.systemManufacturer,
        'systemModel': windowsInfo.systemModel,
        'windows10BuildNumber': windowsInfo.windows10BuildNumber,
        'windows11BuildNumber': windowsInfo.windows11BuildNumber,
      };
    } catch (e) {
      throw Exception('Failed to get Windows info: $e');
    }
  }

  /// 获取macOS设备信息
  static Future<Map<String, dynamic>> getMacOSInfo() async {
    if (!Platform.isMacOS) {
      throw UnsupportedError('This method only supports macOS platform');
    }

    try {
      final macOSInfo = await _deviceInfo.macOSInfo;
      
      return {
        'computerName': macOSInfo.computerName,
        'hostName': macOSInfo.hostName,
        'arch': macOSInfo.arch,
        'model': macOSInfo.model,
        'osRelease': macOSInfo.osRelease,
        'majorVersion': macOSInfo.majorVersion,
        'minorVersion': macOSInfo.minorVersion,
        'patchVersion': macOSInfo.patchVersion,
        'activeCPUs': macOSInfo.activeCPUs,
        'memorySize': macOSInfo.memorySize,
        'cpuFrequency': macOSInfo.cpuFrequency,
      };
    } catch (e) {
      throw Exception('Failed to get macOS info: $e');
    }
  }

  /// 获取Linux设备信息
  static Future<Map<String, dynamic>> getLinuxInfo() async {
    if (!Platform.isLinux) {
      throw UnsupportedError('This method only supports Linux platform');
    }

    try {
      final linuxInfo = await _deviceInfo.linuxInfo;
      
      return {
        'name': linuxInfo.name,
        'version': linuxInfo.version,
        'id': linuxInfo.id,
        'idLike': linuxInfo.idLike,
        'versionCodename': linuxInfo.versionCodename,
        'versionId': linuxInfo.versionId,
        'prettyName': linuxInfo.prettyName,
        'buildId': linuxInfo.buildId,
        'variant': linuxInfo.variant,
        'variantId': linuxInfo.variantId,
        'machineId': linuxInfo.machineId,
      };
    } catch (e) {
      throw Exception('Failed to get Linux info: $e');
    }
  }

  /// 获取当前设备信息（平台适配）
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    if (Platform.isAndroid) {
      return await getAndroidInfo();
    } else if (Platform.isIOS) {
      return await getIOSInfo();
    } else if (kIsWeb) {
      return await getWebInfo();
    } else if (Platform.isWindows) {
      return await getWindowsInfo();
    } else if (Platform.isMacOS) {
      return await getMacOSInfo();
    } else if (Platform.isLinux) {
      return await getLinuxInfo();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  /// 获取应用信息
  static Future<Map<String, dynamic>> getAppInfo() async {
    try {
      final info = await _packageInfo;
      
      return {
        'appName': info.appName,
        'packageName': info.packageName,
        'version': info.version,
        'buildNumber': info.buildNumber,
        'buildSignature': info.buildSignature,
        'installerStore': info.installerStore,
        'buildDate': info.buildDate,
      };
    } catch (e) {
      throw Exception('Failed to get app info: $e');
    }
  }

  /// 获取硬件信息
  static Future<Map<String, dynamic>> getHardwareInfo() async {
    final info = <String, dynamic>{};
    
    try {
      if (Platform.isAndroid) {
        final androidInfo = await getAndroidInfo();
        info['cpu_abi'] = androidInfo['hardware'];
        info['processor'] = androidInfo['hardware'];
        info['cores'] = Platform.numberOfProcessors;
        info['memory'] = 'Unknown'; // 需要额外权限
        info['storage'] = 'Unknown'; // 需要额外权限
      } else if (Platform.isIOS) {
        final iosInfo = await getIOSInfo();
        info['processor'] = iosInfo['model'];
        info['cores'] = Platform.numberOfProcessors;
        info['memory'] = 'Unknown';
        info['storage'] = 'Unknown';
      } else if (kIsWeb) {
        final webInfo = await getWebInfo();
        info['processor'] = webInfo['platform'];
        info['cores'] = webInfo['hardwareConcurrency'];
        info['memory'] = '${webInfo['deviceMemory']} GB';
        info['storage'] = 'Unknown';
      } else if (Platform.isWindows) {
        final windowsInfo = await getWindowsInfo();
        info['processor'] = windowsInfo['systemModel'];
        info['cores'] = windowsInfo['numberOfCores'];
        info['memory'] = '${windowsInfo['systemMemoryInMegabytes']} MB';
        info['storage'] = 'Unknown';
      } else if (Platform.isMacOS) {
        final macOSInfo = await getMacOSInfo();
        info['processor'] = macOSInfo['model'];
        info['cores'] = macOSInfo['activeCPUs'];
        info['memory'] = '${macOSInfo['memorySize']} bytes';
        info['storage'] = 'Unknown';
      }
    } catch (e) {
      info['error'] = e.toString();
    }
    
    return info;
  }

  /// 检查权限状态
  static Future<Map<String, dynamic>> checkPermissions() async {
    final permissions = <String, dynamic>{};
    
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        // 存储权限
        permissions['storage'] = await Permission.storage.status.toString();
        
        // 相机权限
        permissions['camera'] = await Permission.camera.status.toString();
        
        // 麦克风权限
        permissions['microphone'] = await Permission.microphone.status.toString();
        
        // 位置权限
        permissions['location'] = await Permission.location.status.toString();
        
        // 通知权限
        permissions['notification'] = await Permission.notification.status.toString();
        
        // 蓝牙权限
        permissions['bluetooth'] = await Permission.bluetooth.status.toString();
        
        if (Platform.isAndroid) {
          // Android特殊权限
          permissions['manage_external_storage'] = 
              await Permission.manageExternalStorage.status.toString();
          permissions['system_alert_window'] = 
              await Permission.systemAlertWindow.status.toString();
        }
      }
    } catch (e) {
      permissions['error'] = e.toString();
    }
    
    return permissions;
  }

  /// 获取系统特性
  static Future<Map<String, dynamic>> getSystemFeatures() async {
    final features = <String, dynamic>{};
    
    try {
      if (Platform.isAndroid) {
        final androidInfo = await getAndroidInfo();
        features['has_notch'] = _checkHasNotch(androidInfo);
        features['corner_radius'] = _getCornerRadius(androidInfo);
        features['safe_areas'] = _getSafeAreas(androidInfo);
        features['supports_split_screen'] = 
            (androidInfo['apiLevel'] as int) >= 24;
        features['supports_picture_in_picture'] = 
            (androidInfo['apiLevel'] as int) >= 26;
      } else if (Platform.isIOS) {
        final iosInfo = await getIOSInfo();
        features['has_notch'] = _checkIOSNotch(iosInfo);
        features['face_id'] = _checkFaceID(iosInfo);
        features['touch_id'] = _checkTouchID(iosInfo);
      }
      
      // 通用特性
      features['supports_biometric_auth'] = await _checkBiometricAuth();
      features['supports_camera'] = await _checkCameraSupport();
      features['supports_location'] = await _checkLocationSupport();
      features['supports_network'] = await _checkNetworkSupport();
      
    } catch (e) {
      features['error'] = e.toString();
    }
    
    return features;
  }

  /// 检查是否有刘海屏（Android）
  static bool _checkHasNotch(Map<String, dynamic> androidInfo) {
    final manufacturer = androidInfo['manufacturer']?.toLowerCase() ?? '';
    final model = androidInfo['model']?.toLowerCase() ?? '';
    
    // 常见有刘海屏的设备
    final notchDevices = [
      'xiaomi', 'huawei', 'oppo', 'vivo', 'oneplus', 'samsung', 'google'
    ];
    
    return notchDevices.any((brand) => 
        manufacturer.contains(brand) || model.contains(brand));
  }

  /// 获取圆角半径
  static double _getCornerRadius(Map<String, dynamic> androidInfo) {
    // 根据设备型号估算圆角半径
    final model = androidInfo['model']?.toLowerCase() ?? '';
    
    if (model.contains('pixel') || model.contains('iphone')) {
      return 12.0;
    } else if (model.contains('galaxy') || model.contains('xiaomi')) {
      return 8.0;
    } else {
      return 6.0;
    }
  }

  /// 获取安全区域
  static Map<String, double> _getSafeAreas(Map<String, dynamic> androidInfo) {
    final hasNotch = _checkHasNotch(androidInfo);
    
    return {
      'top': hasNotch ? 24.0 : 0.0,
      'bottom': hasNotch ? 24.0 : 0.0,
      'left': 0.0,
      'right': 0.0,
    };
  }

  /// 检查iOS刘海屏
  static bool _checkIOSNotch(Map<String, dynamic> iosInfo) {
    final model = iosInfo['model']?.toLowerCase() ?? '';
    return model.contains('iphone') && 
           (model.contains('x') || model.contains('11') || 
            model.contains('12') || model.contains('13') || 
            model.contains('14') || model.contains('15'));
  }

  /// 检查Face ID支持
  static bool _checkFaceID(Map<String, dynamic> iosInfo) {
    final model = iosInfo['model']?.toLowerCase() ?? '';
    return model.contains('iphone') && 
           (model.contains('x') || model.contains('11') || 
            model.contains('12') || model.contains('13') || 
            model.contains('14') || model.contains('15'));
  }

  /// 检查Touch ID支持
  static bool _checkTouchID(Map<String, dynamic> iosInfo) {
    final model = iosInfo['model']?.toLowerCase() ?? '';
    return model.contains('iphone') && !model.contains('x');
  }

  /// 检查生物识别认证支持
  static Future<bool> _checkBiometricAuth() async {
    try {
      // 这里可以集成local_auth插件来检查
      return true; // 简化实现
    } catch (e) {
      return false;
    }
  }

  /// 检查相机支持
  static Future<bool> _checkCameraSupport() async {
    try {
      final status = await Permission.camera.status;
      return status != PermissionStatus.permanentlyDenied;
    } catch (e) {
      return false;
    }
  }

  /// 检查位置支持
  static Future<bool> _checkLocationSupport() async {
    try {
      final status = await Permission.location.status;
      return status != PermissionStatus.permanentlyDenied;
    } catch (e) {
      return false;
    }
  }

  /// 检查网络支持
  static Future<bool> _checkNetworkSupport() async {
    try {
      final connectivity = Connectivity();
      final result = await connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  /// 获取网络信息
  static Future<Map<String, dynamic>> getNetworkInfo() async {
    final networkInfo = <String, dynamic>{};
    
    try {
      final connectivity = Connectivity();
      final connectivityResult = await connectivity.checkConnectivity();
      
      networkInfo['connectivity'] = connectivityResult.toString();
      networkInfo['is_connected'] = connectivityResult != ConnectivityResult.none;
      
      if (Platform.isAndroid || Platform.isIOS) {
        final wifiName = await connectivity.getWifiName();
        final wifiBSSID = await connectivity.getWifiBSSID();
        final wifiIP = await connectivity.getWifiIP();
        
        networkInfo['wifi_name'] = wifiName;
        networkInfo['wifi_bssid'] = wifiBSSID;
        networkInfo['wifi_ip'] = wifiIP;
      }
    } catch (e) {
      networkInfo['error'] = e.toString();
    }
    
    return networkInfo;
  }

  /// 获取设备性能信息
  static Future<Map<String, dynamic>> getPerformanceInfo() async {
    final performanceInfo = <String, dynamic>{};
    
    try {
      // CPU信息
      performanceInfo['cpu_cores'] = Platform.numberOfProcessors;
      performanceInfo['cpu_architecture'] = Platform.operatingSystemArchitecture;
      
      // 内存信息（平台特定）
      if (Platform.isWindows) {
        final windowsInfo = await getWindowsInfo();
        performanceInfo['memory_mb'] = windowsInfo['systemMemoryInMegabytes'];
      } else if (Platform.isMacOS) {
        final macOSInfo = await getMacOSInfo();
        performanceInfo['memory_bytes'] = macOSInfo['memorySize'];
      }
      
      // 应用性能
      performanceInfo['is_low_end_device'] = Platform.numberOfProcessors <= 2;
      performanceInfo['is_high_end_device'] = Platform.numberOfProcessors >= 8;
      
    } catch (e) {
      performanceInfo['error'] = e.toString();
    }
    
    return performanceInfo;
  }

  /// 检查设备兼容性
  static Future<Map<String, dynamic>> checkDeviceCompatibility() async {
    final compatibility = <String, dynamic>{};
    
    try {
      final deviceInfo = await getDeviceInfo();
      final hardwareInfo = await getHardwareInfo();
      final systemFeatures = await getSystemFeatures();
      
      // 基础兼容性
      compatibility['platform_supported'] = true;
      compatibility['minimum_api_met'] = _checkMinimumAPI(deviceInfo);
      compatibility['hardware_requirements_met'] = _checkHardwareRequirements(hardwareInfo);
      
      // 功能兼容性
      compatibility['biometric_compatible'] = systemFeatures['supports_biometric_auth'];
      compatibility['camera_compatible'] = systemFeatures['supports_camera'];
      compatibility['location_compatible'] = systemFeatures['supports_location'];
      compatibility['network_compatible'] = systemFeatures['supports_network'];
      
      // UI兼容性
      compatibility['ui_adaptive'] = true; // Flutter默认支持
      compatibility['orientation_supported'] = true;
      compatibility['theme_support'] = true;
      
      // 性能兼容性
      compatibility['performance_acceptable'] = _checkPerformanceAcceptable(hardwareInfo);
      
      // 总体兼容性评分
      compatibility['compatibility_score'] = _calculateOverallCompatibility(compatibility);
      
    } catch (e) {
      compatibility['error'] = e.toString();
    }
    
    return compatibility;
  }

  /// 检查最低API要求
  static bool _checkMinimumAPI(Map<String, dynamic> deviceInfo) {
    if (Platform.isAndroid) {
      final apiLevel = deviceInfo['apiLevel'] as int;
      return apiLevel >= 21; // Android 5.0
    } else if (Platform.isIOS) {
      final systemVersion = deviceInfo['systemVersion'] ?? '';
      final version = int.tryParse(systemVersion.split('.').first) ?? 0;
      return version >= 11; // iOS 11
    }
    return true; // 其他平台默认支持
  }

  /// 检查硬件要求
  static bool _checkHardwareRequirements(Map<String, dynamic> hardwareInfo) {
    final cores = hardwareInfo['cores'] as int? ?? 0;
    return cores >= 2; // 至少2核CPU
  }

  /// 检查性能是否可接受
  static bool _checkPerformanceAcceptable(Map<String, dynamic> hardwareInfo) {
    final cores = hardwareInfo['cores'] as int? ?? 0;
    return cores >= 1; // 至少1核CPU
  }

  /// 计算总体兼容性评分
  static int _calculateOverallCompatibility(Map<String, dynamic> compatibility) {
    int score = 0;
    int totalChecks = 0;
    
    // 基础兼容性 (40%)
    if (compatibility['platform_supported'] == true) score += 10;
    if (compatibility['minimum_api_met'] == true) score += 15;
    if (compatibility['hardware_requirements_met'] == true) score += 15;
    totalChecks += 40;
    
    // 功能兼容性 (30%)
    if (compatibility['biometric_compatible'] == true) score += 5;
    if (compatibility['camera_compatible'] == true) score += 5;
    if (compatibility['location_compatible'] == true) score += 5;
    if (compatibility['network_compatible'] == true) score += 15;
    totalChecks += 30;
    
    // UI兼容性 (20%)
    if (compatibility['ui_adaptive'] == true) score += 10;
    if (compatibility['orientation_supported'] == true) score += 5;
    if (compatibility['theme_support'] == true) score += 5;
    totalChecks += 20;
    
    // 性能兼容性 (10%)
    if (compatibility['performance_acceptable'] == true) score += 10;
    totalChecks += 10;
    
    return ((score / totalChecks) * 100).round();
  }

  /// 生成设备报告
  static Future<Map<String, dynamic>> generateDeviceReport() async {
    final report = <String, dynamic>{};
    
    try {
      report['timestamp'] = DateTime.now().toIso8601String();
      report['device_info'] = await getDeviceInfo();
      report['app_info'] = await getAppInfo();
      report['hardware_info'] = await getHardwareInfo();
      report['permissions'] = await checkPermissions();
      report['system_features'] = await getSystemFeatures();
      report['network_info'] = await getNetworkInfo();
      report['performance_info'] = await getPerformanceInfo();
      report['compatibility'] = await checkDeviceCompatibility();
      
    } catch (e) {
      report['error'] = e.toString();
    }
    
    return report;
  }
}