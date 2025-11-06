import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/export.dart';

/// 加密服务类
/// 提供各种数据加密、解密和安全管理功能
class EncryptionService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // 加密配置常量
  static const String _keyAlias = 'encryption_key';
  static const String _saltAlias = 'encryption_salt';
  static const int _keySize = 32; // 256位密钥;
  static const int _ivSize = 16; // 128位初始化向量;
  static const int _saltSize = 32; // 256位盐值;

  /// 生成加密密钥
  /// 返回Base64编码的密钥字符串
  static Future<String> generateEncryptionKey() async {
    final keyGenerator = KeyGenerator('AES');
    final secureRandom = SecureRandom('Fortuna');
    final seeds = List<int>.generate(32, (i) => Random.secure().nextInt(256));
secureRandom.seed(KeyParameter(Uint8List.fromList(seeds));

    keyGenerator.init(ParametersWithRandom(
KeyParameter(Uint8List.fromList(List<int>.filled(_keySize, 0)),
      secureRandom,
    ));

    final key = keyGenerator.generateKey();
    final keyString = base64Encode(key.key);

    // 安全存储密钥
    await _secureStorage.write(key: _keyAlias, value: keyString);

    return keyString;
  }

  /// 获取或生成加密密钥
  static Future<String> getOrCreateEncryptionKey() async {
    String? keyString = await _secureStorage.read(key: _keyAlias);
    
    if (keyString == null || keyString.isEmpty) {
      keyString = await generateEncryptionKey();
    }

    return keyString;
  }

  /// 使用AES-256-GCM加密数据
  /// 
  /// [plainText] 要加密的明文
  /// [keyString] Base64编码的密钥字符串
  /// 返回加密结果的Base64字符串，包含IV和认证标签
  static Future<String> encryptWithAES256GCM(String plainText, String keyString) async {
    try {
      // 解码密钥
      final keyBytes = base64Decode(keyString);
      final key = KeyParameter(keyBytes);

      // 生成随机IV
      final iv = _generateSecureRandomBytes(_ivSize);

      // 创建加密器
      final encrypter = GCMBlockCipher(AESEngine());
encrypter.init(true, ParametersWithRandom(key, SecureRandom('Fortuna')..seed(KeyParameter(iv));

      // 加密数据
      final plainBytes = utf8.encode(plainText);
      final cipherBytes = encrypter.process(plainBytes);

      // 组合IV + 认证标签 + 密文
      final authTag = encrypter.tagLength ~/ 8; // 认证标签长度;
      final tag = encrypter.doFinal(Uint8List(0)).sublist(0, authTag);
      
      final result = Uint8List(iv.length + tag.length + cipherBytes.length);
      result.setRange(0, iv.length, iv);
      result.setRange(iv.length, iv.length + tag.length, tag);
      result.setRange(iv.length + tag.length, result.length, cipherBytes);

      return base64Encode(result);
    } catch (e) {
      throw EncryptionException('AES-256-GCM加密失败: $e');
    }
  }

  /// 使用AES-256-GCM解密数据
  /// 
  /// [cipherText] Base64编码的密文
  /// [keyString] Base64编码的密钥字符串
  /// 返回解密后的明文
  static Future<String> decryptWithAES256GCM(String cipherText, String keyString) async {
    try {
      // 解码密钥和密文
      final keyBytes = base64Decode(keyString);
      final key = KeyParameter(keyBytes);
      
      final cipherBytes = base64Decode(cipherText);
      
      // 提取IV、认证标签和密文
      final iv = cipherBytes.sublist(0, _ivSize);
      final authTag = cipherBytes.sublist(cipherBytes.length - 16, cipherBytes.length);
      final data = cipherBytes.sublist(_ivSize, cipherBytes.length - 16);

      // 创建解密器
      final decrypter = GCMBlockCipher(AESEngine());
decrypter.init(false, ParametersWithRandom(key, SecureRandom('Fortuna')..seed(KeyParameter(iv));

      // 解密数据
      final plainBytes = decrypter.process(data);
      
      return utf8.decode(plainBytes);
    } catch (e) {
      throw EncryptionException('AES-256-GCM解密失败: $e');
    }
  }

  /// 使用PBKDF2派生密钥并加密
  /// 
  /// [plainText] 要加密的明文
  /// [password] 密码
  /// 返回加密结果的Base64字符串
  static Future<String> encryptWithPBKDF2(String plainText, String password) async {
    try {
      // 生成或获取盐值
      String? saltString = await _secureStorage.read(key: _saltAlias);
      if (saltString == null || saltString.isEmpty) {
        saltString = base64Encode(_generateSecureRandomBytes(_saltSize));
        await _secureStorage.write(key: _saltAlias, value: saltString);
      }
      
      final salt = base64Decode(saltString);
      
      // 使用PBKDF2派生密钥
      final derivedKey = _deriveKeyPBKDF2(password, salt);
      
      // 使用AES-256-CBC加密
      final iv = _generateSecureRandomBytes(_ivSize);
      final key = KeyParameter(derivedKey);
      
      final encrypter = CBCBlockCipher(AESEngine());
encrypter.init(true, ParametersWithRandom(key, SecureRandom('Fortuna')..seed(KeyParameter(iv));

      final plainBytes = utf8.encode(plainText);
      final cipherBytes = encrypter.process(plainBytes);

      // 组合IV + 密文
      final result = Uint8List(iv.length + cipherBytes.length);
      result.setRange(0, iv.length, iv);
      result.setRange(iv.length, result.length, cipherBytes);

      return base64Encode(result);
    } catch (e) {
      throw EncryptionException('PBKDF2加密失败: $e');
    }
  }

  /// 使用PBKDF2派生密钥并解密
  /// 
  /// [cipherText] Base64编码的密文
  /// [password] 密码
  /// 返回解密后的明文
  static Future<String> decryptWithPBKDF2(String cipherText, String password) async {
    try {
      // 获取盐值
      final saltString = await _secureStorage.read(key: _saltAlias);
      if (saltString == null || saltString.isEmpty) {
        throw EncryptionException('未找到盐值');
      }
      
      final salt = base64Decode(saltString);
      
      // 使用PBKDF2派生密钥
      final derivedKey = _deriveKeyPBKDF2(password, salt);
      
      // 解码密文
      final cipherBytes = base64Decode(cipherText);
      
      // 提取IV和密文
      final iv = cipherBytes.sublist(0, _ivSize);
      final data = cipherBytes.sublist(_ivSize);
      
      final key = KeyParameter(derivedKey);
      
      // 使用AES-256-CBC解密
      final decrypter = CBCBlockCipher(AESEngine());
decrypter.init(false, ParametersWithRandom(key, SecureRandom('Fortuna')..seed(KeyParameter(iv));

      final plainBytes = decrypter.process(data);
      
      return utf8.decode(plainBytes);
    } catch (e) {
      throw EncryptionException('PBKDF2解密失败: $e');
    }
  }

  /// 生成安全的哈希值
  /// 
  /// [data] 要哈希的数据
  /// [salt] 可选的盐值
  /// 返回SHA-256哈希值的Base64字符串
  static String generateSecureHash(String data, [String? salt]) {
    final bytes = utf8.encode(data);
    final saltBytes = salt != null ? utf8.encode(salt) : <int>[];
    
    final combined = Uint8List(bytes.length + saltBytes.length);
    combined.setRange(0, bytes.length, bytes);
    combined.setRange(bytes.length, combined.length, saltBytes);
    
    final digest = sha256.convert(combined);
    return base64Encode(digest.bytes);
  }

  /// 验证哈希值
  /// 
  /// [data] 原始数据
  /// [hash] 要验证的哈希值
  /// [salt] 盐值
  /// 返回是否验证成功
  static bool verifyHash(String data, String hash, [String? salt]) {
    final computedHash = generateSecureHash(data, salt);
    return computedHash == hash;
  }

  /// 生成随机密码
  /// 
  /// [length] 密码长度，默认16位
  /// [includeSpecial] 是否包含特殊字符，默认true
  /// 返回生成的密码
  static String generateRandomPassword({
    int length = 16,
    bool includeSpecial = true,
  }) {
    const String lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const String uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String numbers = '0123456789';
    const String special = '!@#$%^&*(),.?":{}|<>';

    String chars = lowercase + uppercase + numbers;
    if (includeSpecial) chars += special;

    final random = Random.secure();
    return String.fromCharCodes(
Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    );
  }

  /// 安全地存储敏感数据
  /// 
  /// [key] 存储键
  /// [value] 要存储的值
  /// [encrypt] 是否加密存储，默认true
  static Future<void> storeSecureData(String key, String value, {bool encrypt = true}) async {
    try {
      String storedValue;
      
      if (encrypt) {
        final keyString = await getOrCreateEncryptionKey();
        storedValue = await encryptWithAES256GCM(value, keyString);
      } else {
        storedValue = value;
      }

      await _secureStorage.write(key: key, value: storedValue);
    } catch (e) {
      throw EncryptionException('安全存储失败: $e');
    }
  }

  /// 安全地读取敏感数据
  /// 
  /// [key] 存储键
  /// [decrypt] 是否解密读取，默认true
  /// 返回读取的值
  static Future<String?> readSecureData(String key, {bool decrypt = true}) async {
    try {
      final storedValue = await _secureStorage.read(key: key);
      
      if (storedValue == null) return null;
      
      if (decrypt) {
        final keyString = await getOrCreateEncryptionKey();
        return await decryptWithAES256GCM(storedValue, keyString);
      } else {
        return storedValue;
      }
    } catch (e) {
      throw EncryptionException('安全读取失败: $e');
    }
  }

  /// 删除安全存储的数据
  /// 
  /// [key] 存储键
  static Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key);
  }

  /// 清除所有安全存储的数据
  static Future<void> clearAllSecureData() async {
    await _secureStorage.deleteAll();
  }

  /// 验证加密数据完整性
  /// 
  /// [originalData] 原始数据
  /// [encryptedData] 加密数据
  /// [keyString] 密钥字符串
  /// 返回是否完整
  static Future<bool> verifyDataIntegrity(String originalData, String encryptedData, String keyString) async {
    try {
      final decryptedData = await decryptWithAES256GCM(encryptedData, keyString);
      return originalData == decryptedData;
    } catch (e) {
      return false;
    }
  }

  // 私有辅助方法

  /// 生成安全随机字节
  static Uint8List _generateSecureRandomBytes(int length) {
    final random = Random.secure();
return Uint8List.fromList(List.generate(length, (_) => random.nextInt(256));
  }

  /// 使用PBKDF2派生密钥
  static Uint8List _deriveKeyPBKDF2(String password, Uint8List salt) {
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    pbkdf2.init(Pbkdf2Parameters(salt, 10000, _keySize));
    
    return pbkdf2.process(utf8.encode(password));
  }
}

/// 加密异常类
class EncryptionException implements Exception {
  final String message;
  
  const EncryptionException(this.message);
  
  @override
  String toString() => 'EncryptionException: $message';
}

/// 加密结果类
class EncryptionResult {
  final String encryptedData;
  final String algorithm;
  final DateTime timestamp;
  final bool success;
  final String? error;

  const EncryptionResult({
    required this.encryptedData,
    required this.algorithm,
    required this.timestamp,
    required this.success,
    this.error,
  });

  Map<String, dynamic> toJson() => {
    'encryptedData': encryptedData,
    'algorithm': algorithm,
    'timestamp': timestamp.toIso8601String(),
    'success': success,
    'error': error,
  };
}

/// 解密结果类
class DecryptionResult {
  final String decryptedData;
  final String algorithm;
  final DateTime timestamp;
  final bool success;
  final String? error;

  const DecryptionResult({
    required this.decryptedData,
    required this.algorithm,
    required this.timestamp,
    required this.success,
    this.error,
  });

  Map<String, dynamic> toJson() => {
    'decryptedData': decryptedData,
    'algorithm': algorithm,
    'timestamp': timestamp.toIso8601String(),
    'success': success,
    'error': error,
  };
}

/// 加密服务使用示例
class EncryptionServiceExample {
  static Future<void> runExamples() async {
    print('=== 加密服务示例 ===\n');

    try {
      // 1. AES-256-GCM加密示例
      print('1. AES-256-GCM加密示例:');
      final originalData = '这是敏感信息，需要加密保护';
      final keyString = await EncryptionService.getOrCreateEncryptionKey();
      
      final encryptedData = await EncryptionService.encryptWithAES256GCM(originalData, keyString);
      final decryptedData = await EncryptionService.decryptWithAES256GCM(encryptedData, keyString);
      
      print('原始数据: $originalData');
      print('加密后: ${encryptedData.substring(0, 50)}...');
      print('解密后: $decryptedData');
      print('一致性: ${originalData == decryptedData}');
      print('---');

      // 2. PBKDF2加密示例
      print('\n2. PBKDF2加密示例:');
      const password = 'MySecurePassword123!';
      final pbkdf2Encrypted = await EncryptionService.encryptWithPBKDF2(originalData, password);
      final pbkdf2Decrypted = await EncryptionService.decryptWithPBKDF2(pbkdf2Encrypted, password);
      
      print('密码: $password');
      print('加密后: ${pbkdf2Encrypted.substring(0, 50)}...');
      print('解密后: $pbkdf2Decrypted');
      print('一致性: ${originalData == pbkdf2Decrypted}');
      print('---');

      // 3. 安全哈希示例
      print('\n3. 安全哈希示例:');
      const sensitiveData = '用户密码123';
      final hash = EncryptionService.generateSecureHash(sensitiveData);
      final isValid = EncryptionService.verifyHash(sensitiveData, hash);
      
      print('原始数据: $sensitiveData');
      print('哈希值: $hash');
      print('验证结果: $isValid');
      print('---');

      // 4. 随机密码生成示例
      print('\n4. 随机密码生成示例:');
      final password1 = EncryptionService.generateRandomPassword();
      final password2 = EncryptionService.generateRandomPassword(length: 20, includeSpecial: false);
      
      print('默认密码 (16位): $password1');
      print('增强密码 (20位, 无特殊字符): $password2');
      print('---');

      // 5. 安全存储示例
      print('\n5. 安全存储示例:');
      const userToken = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
      await EncryptionService.storeSecureData('user_token', userToken);
      final retrievedToken = await EncryptionService.readSecureData('user_token');
      
      print('存储的令牌: ${userToken.substring(0, 30)}...');
      print('读取的令牌: ${retrievedToken?.substring(0, 30)}...');
      print('一致性: ${userToken == retrievedToken}');

      // 清理测试数据
      await EncryptionService.deleteSecureData('user_token');
      print('---');

      print('\n✅ 所有加密服务示例执行成功');

    } catch (e) {
      print('❌ 加密服务示例执行失败: $e');
    }
  }
}

void main() async {
  await EncryptionServiceExample.runExamples();
}