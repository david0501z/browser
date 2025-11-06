import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/browser_models.dart';
import '../providers/browser_providers.dart';

/// 浏览器设置页面
/// 提供浏览器相关的配置选项，包括隐私、安全、性能等设置
class BrowserSettingsPage extends ConsumerStatefulWidget {
  const BrowserSettingsPage({super.key});

  @override
  ConsumerState<BrowserSettingsPage> createState() => _BrowserSettingsPageState();
}

class _BrowserSettingsPageState extends ConsumerState<BrowserSettingsPage> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(browserSettingsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('浏览器设置'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          // 基本设置
          _buildSection(
            context,
            '基本设置',
            [
              _buildSearchEngineTile(settings),
              _buildHomepageTile(settings),
              _buildFontSizeTile(settings),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 隐私与安全
          _buildSection(
            context,
            '隐私与安全',
            [
              _buildIncognitoTile(settings),
              _buildPrivacyModeTile(settings),
              _buildAutoClearDataTile(settings),
              _buildJavaScriptTile(settings),
              _buildPopupsTile(settings),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 内容设置
          _buildSection(
            context,
            '内容设置',
            [
              _buildImagesTile(settings),
              _buildDomStorageTile(settings),
              _buildCacheModeTile(settings),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 下载设置
          _buildSection(
            context,
            '下载设置',
            [
              _buildDownloadDirectoryTile(settings),
              _buildDownloadNotificationsTile(settings),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // 高级设置
          _buildSection(
            context,
            '高级设置',
            [
              _buildUserAgentTile(settings),
              _buildClearDataTile(),
              _buildExportDataTile(),
              _buildImportDataTile(),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // 版本信息
          _buildVersionInfo(),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// 构建设置分组
  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  /// 构建搜索引擎设置项
  Widget _buildSearchEngineTile(BrowserSettings settings) {
    return ListTile(
      leading: const Icon(Icons.search),
      title: const Text('默认搜索引擎'),
      subtitle: Text(_getSearchEngineName(settings.searchEngine)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showSearchEngineDialog(settings),
    );
  }

  /// 构建首页设置项
  Widget _buildHomepageTile(BrowserSettings settings) {
    return ListTile(
      leading: const Icon(Icons.home),
      title: const Text('首页'),
      subtitle: Text(settings.homepage),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showHomepageDialog(settings),
    );
  }

  /// 构建字体大小设置项
  Widget _buildFontSizeTile(BrowserSettings settings) {
    return ListTile(
      leading: const Icon(Icons.text_fields),
      title: const Text('字体大小'),
      subtitle: Text('${settings.fontSize}px'),
      trailing: SizedBox(
        width: 120,
        child: Slider(
          value: settings.fontSize.toDouble(),
          min: 10,
          max: 32,
          divisions: 22,
          label: '${settings.fontSize}px',
          onChanged: (value) {
            ref.read(browserSettingsProvider.notifier).updateSettings(
              settings.copyWith(fontSize: value.round()),
            );
          },
        ),
      ),
    );
  }

  /// 构建无痕模式设置项
  Widget _buildIncognitoTile(BrowserSettings settings) {
    return SwitchListTile(
      secondary: const Icon(Icons.incognito),
      title: const Text('无痕模式'),
      subtitle: const Text('不保存浏览历史和Cookie'),
      value: settings.incognito,
      onChanged: (value) {
        ref.read(browserSettingsProvider.notifier).updateSettings(
          settings.copyWith(incognito: value),
        );
      },
    );
  }

  /// 构建隐私模式设置项
  Widget _buildPrivacyModeTile(BrowserSettings settings) {
    return SwitchListTile(
      secondary: const Icon(Icons.privacy_tip),
      title: const Text('隐私模式'),
      subtitle: const Text('增强隐私保护，阻止跟踪器'),
      value: settings.privacyMode,
      onChanged: (value) {
        ref.read(browserSettingsProvider.notifier).updateSettings(
          settings.copyWith(privacyMode: value),
        );
      },
    );
  }

  /// 构建自动清除数据设置项
  Widget _buildAutoClearDataTile(BrowserSettings settings) {
    return SwitchListTile(
      secondary: const Icon(Icons.auto_delete),
      title: const Text('自动清除数据'),
      subtitle: Text('每${settings.clearDataInterval}小时自动清除'),
      value: settings.autoClearData,
      onChanged: (value) {
        ref.read(browserSettingsProvider.notifier).updateSettings(
          settings.copyWith(autoClearData: value),
        );
      },
    );
  }

  /// 构建JavaScript设置项
  Widget _buildJavaScriptTile(BrowserSettings settings) {
    return SwitchListTile(
      secondary: const Icon(Icons.code),
      title: const Text('启用JavaScript'),
      subtitle: const Text('允许网页执行JavaScript代码'),
      value: settings.javascriptEnabled,
      onChanged: (value) {
        ref.read(browserSettingsProvider.notifier).updateSettings(
          settings.copyWith(javascriptEnabled: value),
        );
      },
    );
  }

  /// 构建弹出窗口设置项
  Widget _buildPopupsTile(BrowserSettings settings) {
    return SwitchListTile(
      secondary: const Icon(Icons.open_in_new),
      title: const Text('允许弹出窗口'),
      subtitle: const Text('允许网站打开新窗口'),
      value: settings.popupsEnabled,
      onChanged: (value) {
        ref.read(browserSettingsProvider.notifier).updateSettings(
          settings.copyWith(popupsEnabled: value),
        );
      },
    );
  }

  /// 构建图片加载设置项
  Widget _buildImagesTile(BrowserSettings settings) {
    return SwitchListTile(
      secondary: const Icon(Icons.image),
      title: const Text('加载图片'),
      subtitle: const Text('自动加载网页图片'),
      value: settings.imagesEnabled,
      onChanged: (value) {
        ref.read(browserSettingsProvider.notifier).updateSettings(
          settings.copyWith(imagesEnabled: value),
        );
      },
    );
  }

  /// 构建DOM存储设置项
  Widget _buildDomStorageTile(BrowserSettings settings) {
    return SwitchListTile(
      secondary: const Icon(Icons.storage),
      title: const Text('DOM存储'),
      subtitle: const Text('允许网站使用本地存储'),
      value: settings.domStorageEnabled,
      onChanged: (value) {
        ref.read(browserSettingsProvider.notifier).updateSettings(
          settings.copyWith(domStorageEnabled: value),
        );
      },
    );
  }

  /// 构建缓存模式设置项
  Widget _buildCacheModeTile(BrowserSettings settings) {
    return ListTile(
      leading: const Icon(Icons.cache),
      title: const Text('缓存模式'),
      subtitle: Text(_getCacheModeName(settings.cacheMode)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showCacheModeDialog(settings),
    );
  }

  /// 构建下载目录设置项
  Widget _buildDownloadDirectoryTile(BrowserSettings settings) {
    return ListTile(
      leading: const Icon(Icons.folder),
      title: const Text('下载目录'),
      subtitle: Text(settings.downloadDirectory ?? '默认目录'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _selectDownloadDirectory(settings),
    );
  }

  /// 构建下载通知设置项
  Widget _buildDownloadNotificationsTile(BrowserSettings settings) {
    return SwitchListTile(
      secondary: const Icon(Icons.notifications),
      title: const Text('下载通知'),
      subtitle: const Text('显示下载完成通知'),
      value: settings.downloadNotifications,
      onChanged: (value) {
        ref.read(browserSettingsProvider.notifier).updateSettings(
          settings.copyWith(downloadNotifications: value),
        );
      },
    );
  }

  /// 构建用户代理设置项
  Widget _buildUserAgentTile(BrowserSettings settings) {
    return ListTile(
      leading: const Icon(Icons.devices),
      title: const Text('用户代理'),
      subtitle: Text(
        settings.userAgent ?? '默认用户代理',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showUserAgentDialog(settings),
    );
  }

  /// 构建清除数据设置项
  Widget _buildClearDataTile() {
    return ListTile(
      leading: const Icon(Icons.clear_all, color: Colors.red),
      title: const Text('清除浏览数据'),
      subtitle: const Text('清除历史记录、Cookie和缓存'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: _showClearDataDialog,
    );
  }

  /// 构建导出数据设置项
  Widget _buildExportDataTile() {
    return ListTile(
      leading: const Icon(Icons.file_download),
      title: const Text('导出数据'),
      subtitle: const Text('导出书签和设置'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _exportData(),
    );
  }

  /// 构建导入数据设置项
  Widget _buildImportDataTile() {
    return ListTile(
      leading: const Icon(Icons.file_upload),
      title: const Text('导入数据'),
      subtitle: const Text('从文件导入书签和设置'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _importData(),
    );
  }

  /// 构建版本信息
  Widget _buildVersionInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'FlClash Browser',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '版本 1.0.0',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '基于 Flutter 和 ClashMeta 构建',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 显示搜索引擎选择对话框
  void _showSearchEngineDialog(BrowserSettings settings) {
    final searchEngines = [
      {'name': 'Google', 'url': 'https://www.google.com/search?q='},
      {'name': '百度', 'url': 'https://www.baidu.com/s?wd='},
      {'name': '必应', 'url': 'https://www.bing.com/search?q='},
      {'name': 'DuckDuckGo', 'url': 'https://duckduckgo.com/?q='},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择搜索引擎'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: searchEngines.map((engine) {
            return RadioListTile<String>(
              title: Text(engine['name']!),
              value: engine['url']!,
              groupValue: settings.searchEngine,
              onChanged: (value) {
                if (value != null) {
                  ref.read(browserSettingsProvider.notifier).updateSettings(
                    settings.copyWith(searchEngine: value),
                  );
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 显示首页设置对话框
  void _showHomepageDialog(BrowserSettings settings) {
    final controller = TextEditingController(text: settings.homepage);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('设置首页'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '输入首页URL',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(browserSettingsProvider.notifier).updateSettings(
                  settings.copyWith(homepage: controller.text),
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 显示缓存模式选择对话框
  void _showCacheModeDialog(BrowserSettings settings) {
    final cacheModes = [
      {'name': '默认', 'value': 'default'},
      {'name': '不缓存', 'value': 'no_cache'},
      {'name': '缓存优先', 'value': 'cache_first'},
      {'name': '网络优先', 'value': 'network_first'},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择缓存模式'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: cacheModes.map((mode) {
            return RadioListTile<String>(
              title: Text(mode['name']!),
              value: mode['value']!,
              groupValue: settings.cacheMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(browserSettingsProvider.notifier).updateSettings(
                    settings.copyWith(cacheMode: value),
                  );
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 选择下载目录
  void _selectDownloadDirectory(BrowserSettings settings) {
    // TODO: 实现目录选择功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('目录选择功能开发中')),
    );
  }

  /// 显示用户代理设置对话框
  void _showUserAgentDialog(BrowserSettings settings) {
    final controller = TextEditingController(text: settings.userAgent ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('设置用户代理'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '输入用户代理字符串',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              ref.read(browserSettingsProvider.notifier).updateSettings(
                settings.copyWith(userAgent: controller.text.isEmpty ? null : controller.text),
              );
              Navigator.of(context).pop();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 显示清除数据确认对话框
  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除浏览数据'),
        content: const Text('确定要清除所有浏览数据吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearBrowsingData();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('清除'),
          ),
        ],
      ),
    );
  }

  /// 清除浏览数据
  void _clearBrowsingData() {
    // TODO: 实现数据清除逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('数据清除完成')),
    );
  }

  /// 导出数据
  void _exportData() {
    // TODO: 实现数据导出逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('数据导出功能开发中')),
    );
  }

  /// 导入数据
  void _importData() {
    // TODO: 实现数据导入逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('数据导入功能开发中')),
    );
  }

  /// 获取搜索引擎名称
  String _getSearchEngineName(String url) {
    if (url.contains('google.com')) return 'Google';
    if (url.contains('baidu.com')) return '百度';
    if (url.contains('bing.com')) return '必应';
    if (url.contains('duckduckgo.com')) return 'DuckDuckGo';
    return '自定义';
  }

  /// 获取缓存模式名称
  String _getCacheModeName(String mode) {
    switch (mode) {
      case 'default': return '默认';
      case 'no_cache': return '不缓存';
      case 'cache_first': return '缓存优先';
      case 'network_first': return '网络优先';
      default: return '未知';
    }
  }
}