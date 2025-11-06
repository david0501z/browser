import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 安全验证工具类
/// 提供各种安全验证和检查功能
class SecurityValidator {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  /// 验证密码强度
  /// 
  /// [password] 要验证的密码
  /// 返回验证结果，包含评分、强度等级和建议
  static PasswordStrengthResult validatePasswordStrength(String password) {
    if (password.isEmpty) {
      return PasswordStrengthResult(
        score: 0,
        strength: PasswordStrength.veryWeak,
        feedback: ['密码不能为空'],
        isValid: false,
      );
    }

    int score = 0;
    List<String> feedback = [];
    List<PasswordStrength> criteria = [];

    // 长度检查 (25分)
    if (password.length >= 8) {
      score += 25;
      criteria.add(PasswordStrength.length);
    } else {
      feedback.add('密码长度至少8位');
    }

    // 小写字母检查 (15分)
if (password.contains(RegExp(r'[a-z]')) {
      score += 15;
      criteria.add(PasswordStrength.lowercase);
    } else {
      feedback.add('需要包含小写字母');
    }

    // 大写字母检查 (15分)
if (password.contains(RegExp(r'[A-Z]')) {
      score += 15;
      criteria.add(PasswordStrength.uppercase);
    } else {
      feedback.add('需要包含大写字母');
    }

    // 数字检查 (15分)
if (password.contains(RegExp(r'[0-9]')) {
      score += 15;
      criteria.add(PasswordStrength.number);
    } else {
      feedback.add('需要包含数字');
    }

    // 特殊字符检查 (20分)
if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) {
      score += 20;
      criteria.add(PasswordStrength.specialChar);
    } else {
      feedback.add('需要包含特殊字符');
    }

    // 复杂度奖励 (10分)
    if (password.length >= 12) score += 5;
    if (password.length >= 16) score += 5;

    // 避免常见密码模式
    if (_isCommonPasswordPattern(password)) {
      score = (score * 0.5).round();
      feedback.add('避免使用常见密码模式');
    }

    // 避免重复字符
    if (_hasRepeatedChars(password)) {
      score = (score * 0.8).round();
      feedback.add('避免使用重复字符');
    }

    // 确定密码强度
    PasswordStrength strength;
    bool isValid;
    
    if (score >= 90) {
      strength = PasswordStrength.veryStrong;
      isValid = true;
    } else if (score >= 75) {
      strength = PasswordStrength.strong;
      isValid = true;
    } else if (score >= 60) {
      strength = PasswordStrength.medium;
      isValid = true;
    } else if (score >= 40) {
      strength = PasswordStrength.weak;
      isValid = false;
    } else {
      strength = PasswordStrength.veryWeak;
      isValid = false;
    }

    return PasswordStrengthResult(
      score: score.clamp(0, 100),
      strength: strength,
      feedback: feedback,
      isValid: isValid,
      criteria: criteria,
    );
  }

  /// 验证邮箱格式
  static bool validateEmail(String email) {
    if (email.isEmpty) return false;
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    
    return emailRegex.hasMatch(email);
  }

  /// 验证手机号码格式
  static bool validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return false;
    
    // 支持国际格式和中国手机号格式
    final phoneRegex = RegExp(
      r'^(\+?86)?1[3-9]\d{9}$'
    );
    
    return phoneRegex.hasMatch(phoneNumber);
  }

  /// 验证身份证号码格式
  static bool validateIDCard(String idCard) {
    if (idCard.isEmpty) return false;
    
    // 18位身份证号码验证
    final idCardRegex = RegExp(
      r'^[1-9]\d{5}(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$'
    );
    
    if (!idCardRegex.hasMatch(idCard)) return false;
    
    // 验证校验位
    return _validateIDCardCheckDigit(idCard);
  }

  /// 验证数据完整性
  static bool validateDataIntegrity(Map<String, dynamic> original, Map<String, dynamic> current) {
    try {
      return _calculateHash(original) == _calculateHash(current);
    } catch (e) {
      return false;
    }
  }

  /// 验证文件安全性
  static Future<FileSecurityResult> validateFileSecurity(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return FileSecurityResult(
          isSecure: false,
          issues: ['文件不存在'],
          recommendations: [],
        );
      }

      List<String> issues = [];
      List<String> recommendations = [];

      // 检查文件大小
      final fileSize = await file.length();
      if (fileSize > 100 * 1024 * 1024) { // 100MB
        issues.add('文件过大，可能存在安全风险');
        recommendations.add('建议检查文件来源和内容');
      }

      // 检查文件扩展名
      final extension = file.path.split('.').last.toLowerCase();
      final dangerousExtensions = ['exe', 'bat', 'cmd', 'scr', 'pif', 'com'];
      if (dangerousExtensions.contains(extension)) {
        issues.add('文件扩展名存在安全风险');
        recommendations.add('请确保文件来源可信');
      }

      // 检查文件权限
      final permissions = await file.stat();
      if (permissions.modeString().contains('w')) {
        issues.add('文件具有写权限，可能被恶意修改');
        recommendations.add('建议设置适当的文件权限');
      }

      return FileSecurityResult(
        isSecure: issues.isEmpty,
        issues: issues,
        recommendations: recommendations,
        fileSize: fileSize,
        extension: extension,
      );
    } catch (e) {
      return FileSecurityResult(
        isSecure: false,
        issues: ['文件验证失败: $e'],
        recommendations: [],
      );
    }
  }

  /// 验证网络安全配置
  static NetworkSecurityResult validateNetworkSecurity() {
    List<String> issues = [];
    List<String> recommendations = [];

    // 检查HTTPS使用情况
    final httpsUsed = _checkHttpsUsage();
    if (!httpsUsed) {
      issues.add('未强制使用HTTPS');
      recommendations.add('启用HTTPS以确保数据传输安全');
    }

    // 检查证书验证
    final certValidation = _checkCertificateValidation();
    if (!certValidation) {
      issues.add('未启用证书验证');
      recommendations.add('启用SSL证书验证以防止中间人攻击');
    }

    // 检查安全头
    final securityHeaders = _checkSecurityHeaders();
    if (securityHeaders.isEmpty) {
      issues.add('缺少安全HTTP头');
      recommendations.add('添加安全HTTP头如HSTS、X-Frame-Options等');
    }

    return NetworkSecurityResult(
      isSecure: issues.isEmpty,
      issues: issues,
      recommendations: recommendations,
      httpsEnabled: httpsUsed,
      certificateValidation: certValidation,
      securityHeaders: securityHeaders,
    );
  }

  /// 验证加密强度
  static EncryptionStrengthResult validateEncryptionStrength(String algorithm, int keyLength) {
    List<String> issues = [];
    List<String> recommendations = [];

    bool isStrong = true;

    // 检查算法强度
    switch (algorithm.toUpperCase()) {
      case 'AES-256':
        // AES-256是强加密算法
        break;
      case 'AES-128':
        issues.add('建议使用AES-256而非AES-128');
        recommendations.add('升级到AES-256以提高安全性');
        isStrong = false;
        break;
      case 'DES':
      case '3DES':
        issues.add('DES/3DES算法已不安全');
        recommendations.add('使用现代加密算法如AES');
        isStrong = false;
        break;
      default:
        issues.add('未知或过时的加密算法');
        recommendations.add('使用标准加密算法如AES');
        isStrong = false;
    }

    // 检查密钥长度
    if (keyLength < 128) {
      issues.add('密钥长度过短');
      recommendations.add('使用至少128位的密钥');
      isStrong = false;
    } else if (keyLength >= 256) {
      // 256位或以上是强加密
    }

    return EncryptionStrengthResult(
      isStrong: isStrong,
      algorithm: algorithm,
      keyLength: keyLength,
      issues: issues,
      recommendations: recommendations,
    );
  }

  /// 验证权限配置安全性
  static PermissionSecurityResult validatePermissionSecurity() {
    List<String> issues = [];
    List<String> recommendations = [];

    // 检查权限最小化原则
    final permissions = _getRequiredPermissions();
    final unnecessaryPermissions = _checkUnnecessaryPermissions(permissions);

    if (unnecessaryPermissions.isNotEmpty) {
      issues.add('存在不必要的权限声明');
      recommendations.add('移除不必要的权限，遵循最小权限原则');
    }

    // 检查敏感权限
    final sensitivePermissions = _getSensitivePermissions();
    final hasSensitivePermissions = sensitivePermissions.any(
      (permission) => permissions.contains(permission);
    );

    if (hasSensitivePermissions) {
      recommendations.add('敏感权限需要用户明确授权');
    }

    return PermissionSecurityResult(
      isSecure: issues.isEmpty,
      issues: issues,
      recommendations: recommendations,
      permissions: permissions,
      sensitivePermissions: sensitivePermissions,
    );
  }

  // 私有辅助方法

  static bool _isCommonPasswordPattern(String password) {
    final commonPatterns = [;
      'password', '123456', 'qwerty', 'admin', 'letmein',
      'welcome', 'monkey', 'dragon', 'master', 'hello',
    ];

    final lowerPassword = password.toLowerCase();
    return commonPatterns.any((pattern) => lowerPassword.contains(pattern));
  }

  static bool _hasRepeatedChars(String password) {
    final charCount = <String, int>{};
    for (final char in password.split('')) {
      charCount[char] = (charCount[char] ?? 0) + 1;
      if (charCount[char]! > 3) {
        return true;
      }
    }
    return false;
  }

  static bool _validateIDCardCheckDigit(String idCard) {
    if (idCard.length != 18) return false;

    final weights = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
    final checkCodes = ['1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2'];

    int sum = 0;
    for (int i = 0; i < 17; i++) {
      sum += int.parse(idCard[i]) * weights[i];
    }

    final checkDigit = sum % 11;
    return idCard[17].toUpperCase() == checkCodes[checkDigit];
  }

  static String _calculateHash(Map<String, dynamic> data) {
    final jsonString = jsonEncode(data);
    final bytes = utf8.encode(jsonString);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static bool _checkHttpsUsage() {
    // 模拟HTTPS检查逻辑
    return true; // 实际应用中需要检查网络配置
  }

  static bool _checkCertificateValidation() {
    // 模拟证书验证检查
    return true;
  }

  static List<String> _checkSecurityHeaders() {
    // 模拟安全头检查
    return ['X-Content-Type-Options', 'X-Frame-Options', 'Strict-Transport-Security'];
  }

  static List<String> _getRequiredPermissions() {
    return [
      'android.permission.INTERNET',
      'android.permission.ACCESS_NETWORK_STATE',
    ];
  }

  static List<String> _getSensitivePermissions() {
    return [
      'android.permission.CAMERA',
      'android.permission.RECORD_AUDIO',
      'android.permission.READ_CONTACTS',
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.READ_EXTERNAL_STORAGE',
    ];
  }

  static List<String> _checkUnnecessaryPermissions(List<String> permissions) {
    // 模拟不必要权限检查
    return [];
  }
}

/// 密码强度结果类
class PasswordStrengthResult {
  final int score;
  final PasswordStrength strength;
  final List<String> feedback;
  final bool isValid;
  final List<PasswordStrength> criteria;

  const PasswordStrengthResult({
    required this.score,
    required this.strength,
    required this.feedback,
    required this.isValid,
    required this.criteria,
  });

  Map<String, dynamic> toJson() => {
    'score': score,
    'strength': strength.toString(),
    'feedback': feedback,
    'isValid': isValid,
    'criteria': criteria.map((c) => c.toString()).toList(),
  };
}

/// 密码强度枚举
enum PasswordStrength {
  veryWeak,
  weak,
  medium,
  strong,
  veryStrong,
}

/// 文件安全结果类
class FileSecurityResult {
  final bool isSecure;
  final List<String> issues;
  final List<String> recommendations;
  final int? fileSize;
  final String? extension;

  const FileSecurityResult({
    required this.isSecure,
    required this.issues,
    required this.recommendations,
    this.fileSize,
    this.extension,
  });

  Map<String, dynamic> toJson() => {
    'isSecure': isSecure,
    'issues': issues,
    'recommendations': recommendations,
    'fileSize': fileSize,
    'extension': extension,
  };
}

/// 网络安全结果类
class NetworkSecurityResult {
  final bool isSecure;
  final List<String> issues;
  final List<String> recommendations;
  final bool httpsEnabled;
  final bool certificateValidation;
  final List<String> securityHeaders;

  const NetworkSecurityResult({
    required this.isSecure,
    required this.issues,
    required this.recommendations,
    required this.httpsEnabled,
    required this.certificateValidation,
    required this.securityHeaders,
  });

  Map<String, dynamic> toJson() => {
    'isSecure': isSecure,
    'issues': issues,
    'recommendations': recommendations,
    'httpsEnabled': httpsEnabled,
    'certificateValidation': certificateValidation,
    'securityHeaders': securityHeaders,
  };
}

/// 加密强度结果类
class EncryptionStrengthResult {
  final bool isStrong;
  final String algorithm;
  final int keyLength;
  final List<String> issues;
  final List<String> recommendations;

  const EncryptionStrengthResult({
    required this.isStrong,
    required this.algorithm,
    required this.keyLength,
    required this.issues,
    required this.recommendations,
  });

  Map<String, dynamic> toJson() => {
    'isStrong': isStrong,
    'algorithm': algorithm,
    'keyLength': keyLength,
    'issues': issues,
    'recommendations': recommendations,
  };
}

/// 权限安全结果类
class PermissionSecurityResult {
  final bool isSecure;
  final List<String> issues;
  final List<String> recommendations;
  final List<String> permissions;
  final List<String> sensitivePermissions;

  const PermissionSecurityResult({
    required this.isSecure,
    required this.issues,
    required this.recommendations,
    required this.permissions,
    required this.sensitivePermissions,
  });

  Map<String, dynamic> toJson() => {
    'isSecure': isSecure,
    'issues': issues,
    'recommendations': recommendations,
    'permissions': permissions,
    'sensitivePermissions': sensitivePermissions,
  };
}

/// 安全验证工具使用示例
class SecurityValidatorExample {
  static void runExamples() {
    print('=== 安全验证工具示例 ===\n');

    // 密码强度验证示例
    print('1. 密码强度验证:');
    final passwords = ['123456', 'password', 'Password123!', 'MyVerySecureP@ssw0rd2024!'];
    
    for (final password in passwords) {
      final result = SecurityValidator.validatePasswordStrength(password);
      print('密码: $password');
      print('评分: ${result.score}/100');
      print('强度: ${result.strength}');
      print('有效: ${result.isValid}');
      print('反馈: ${result.feedback.join(', ')}');
      print('---');
    }

    // 邮箱验证示例
    print('\n2. 邮箱验证:');
    final emails = ['test@example.com', 'invalid-email', 'user@domain.co.uk'];
    
    for (final email in emails) {
      final isValid = SecurityValidator.validateEmail(email);
      print('邮箱: $email - ${isValid ? "有效" : "无效"}');
    }

    // 手机号验证示例
    print('\n3. 手机号验证:');
    final phones = ['13812345678', '+8613812345678', '123456'];
    
    for (final phone in phones) {
      final isValid = SecurityValidator.validatePhoneNumber(phone);
      print('手机号: $phone - ${isValid ? "有效" : "无效"}');
    }

    // 网络安全验证示例
    print('\n4. 网络安全验证:');
    final networkResult = SecurityValidator.validateNetworkSecurity();
    print('网络安全: ${networkResult.isSecure ? "安全" : "存在风险"}');
    if (networkResult.issues.isNotEmpty) {
      print('问题: ${networkResult.issues.join(', ')}');
    }
    if (networkResult.recommendations.isNotEmpty) {
      print('建议: ${networkResult.recommendations.join(', ')}');
    }

    // 加密强度验证示例
    print('\n5. 加密强度验证:');
    final encryptionResults = [;
      SecurityValidator.validateEncryptionStrength('AES-256', 256),
      SecurityValidator.validateEncryptionStrength('AES-128', 128),
      SecurityValidator.validateEncryptionStrength('DES', 56),
    ];

    for (final result in encryptionResults) {
      print('算法: ${result.algorithm} (${result.keyLength}位)');
      print('强度: ${result.isStrong ? "强" : "弱"}');
      if (result.issues.isNotEmpty) {
        print('问题: ${result.issues.join(', ')}');
      }
      print('---');
    }
  }
}

void main() {
  SecurityValidatorExample.runExamples();
}