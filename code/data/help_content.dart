/// 帮助内容数据类
/// 包含所有帮助文档、FAQ、快捷键等信息
class HelpContent {
  // 引导步骤内容
  static final onboardingSteps = [
    OnboardingStep(
      id: 'welcome',
      title: '欢迎使用FlClash',
      description: 'FlClash是一个强大的VPN客户端，让您安全地浏览互联网。',
      image: 'assets/images/onboarding/welcome.png',
      animation: 'welcome.json',
    ),
    OnboardingStep(
      id: 'connect',
      title: '连接服务器',
      description: '选择您喜欢的服务器位置，点击连接按钮即可开始使用。',
      image: 'assets/images/onboarding/connect.png',
      animation: 'connect.json',
      highlightWidget: 'connect_button',
    ),
    OnboardingStep(
      id: 'settings',
      title: '个性化设置',
      description: '在设置中您可以自定义代理规则、网络设置等。',
      image: 'assets/images/onboarding/settings.png',
      animation: 'settings.json',
      highlightWidget: 'settings_button',
    ),
    OnboardingStep(
      id: 'complete',
      title: '完成设置',
      description: '恭喜！您已经完成所有设置，现在可以开始安全上网了。',
      image: 'assets/images/onboarding/complete.png',
      animation: 'complete.json',
    ),
  ];

  // FAQ内容
  static final faqCategories = [
    FAQCategory(
      id: 'basic',
      title: '基础使用',
      icon: '❓',
      faqs: [
        FAQItem(
          id: 'what_is_flclash',
          question: 'FlClash是什么？',
          answer: 'FlClash是一个基于Flutter开发的VPN客户端，支持多种代理协议，提供安全、快速的上网体验。',
          tags: ['基础', '介绍'],
        ),
        FAQItem(
          id: 'how_to_connect',
          question: '如何连接VPN？',
          answer: '选择服务器后，点击主界面的连接按钮即可。连接成功后状态栏会显示连接图标。',
          tags: ['连接', '使用'],
          relatedSteps: ['connect'],
        ),
        FAQItem(
          id: 'connection_failed',
          question: '连接失败怎么办？',
          answer: '请检查网络连接、服务器状态，或尝试切换其他服务器。如果问题持续，请联系技术支持。',
          tags: ['故障', '连接'],
        ),
      ],
    ),
    FAQCategory(
      id: 'settings',
      title: '设置相关',
      icon: '⚙️',
      faqs: [
        FAQItem(
          id: 'proxy_settings',
          question: '如何配置代理设置？',
          answer: '在设置页面中，您可以配置HTTP代理、SOCKS代理等参数。建议根据您的网络环境进行调整。',
          tags: ['设置', '代理'],
          relatedSteps: ['settings'],
        ),
        FAQItem(
          id: 'network_settings',
          question: '网络设置有哪些选项？',
          answer: '您可以设置DNS服务器、连接超时、协议类型等。建议使用默认设置以获得最佳性能。',
          tags: ['设置', '网络'],
        ),
      ],
    ),
    FAQCategory(
      id: 'troubleshooting',
      title: '故障排除',
      icon: '🔧',
      faqs: [
        FAQItem(
          id: 'slow_speed',
          question: '网速很慢怎么办？',
          answer: '尝试切换到其他服务器节点，或检查本地网络环境。某些服务器可能因为地理位置导致延迟较高。',
          tags: ['速度', '性能'],
        ),
        FAQItem(
          id: 'app_crash',
          question: '应用崩溃怎么办？',
          answer: '请重启应用，如果问题持续，请清除应用数据或重新安装。同时检查是否有可用的应用更新。',
          tags: ['崩溃', '故障'],
        ),
      ],
    ),
  ];

  // 快捷键和手势
  static final shortcuts = [
    ShortcutItem(
      id: 'quick_connect',
      description: '快速连接/断开',
      keys: ['长按连接按钮'],
      category: '连接',
    ),
    ShortcutItem(
      id: 'switch_server',
      description: '切换服务器',
      keys: ['左右滑动服务器列表'],
      category: '服务器',
    ),
    ShortcutItem(
      id: 'open_settings',
      description: '打开设置',
      keys: ['点击右上角设置图标'],
      category: '导航',
    ),
    ShortcutItem(
      id: 'view_logs',
      description: '查看连接日志',
      keys: ['双击状态指示器'],
      category: '调试',
    ),
  ];

  // 工具提示内容
  static final tooltips = {
    'connect_button': TooltipContent(
      title: '连接按钮',
      description: '点击这里连接或断开VPN连接。长按可快速切换服务器。',
      position: TooltipPosition.bottom,
    ),
    'server_list': TooltipContent(
      title: '服务器列表',
      description: '选择您想要连接的服务器位置。不同地区可能有不同的网络表现。',
      position: TooltipPosition.right,
    ),
    'status_indicator': TooltipContent(
      title: '状态指示器',
      description: '显示当前连接状态：绿色表示已连接，红色表示未连接。',
      position: TooltipPosition.left,
    ),
    'settings_button': TooltipContent(
      title: '设置按钮',
      description: '访问应用设置，配置代理规则、网络参数等。',
      position: TooltipPosition.left,
    ),
  };

  // 教程覆盖层配置
  static final tutorialSteps = [
    TutorialStep(
      id: 'main_interface',
      title: '主界面介绍',
      description: '这是应用的主界面，包含连接按钮、服务器选择和状态显示。',
      targetWidget: 'main_scaffold',
      action: TutorialAction.highlight,
    ),
    TutorialStep(
      id: 'connection_status',
      title: '连接状态',
      description: '这里显示当前的连接状态和相关信息。',
      targetWidget: 'status_card',
      action: TutorialAction.highlight,
    ),
    TutorialStep(
      id: 'server_selection',
      title: '选择服务器',
      description: '点击这里选择您想要的服务器位置。',
      targetWidget: 'server_list',
      action: TutorialAction.highlight,
      nextAction: TutorialAction.tap,
    ),
    TutorialStep(
      id: 'connect_action',
      title: '开始连接',
      description: '现在点击连接按钮开始使用VPN。',
      targetWidget: 'connect_button',
      action: TutorialAction.highlight,
      nextAction: TutorialAction.tap,
    ),
  ];
}

/// 引导步骤数据模型
class OnboardingStep {
  final String id;
  final String title;
  final String description;
  final String image;
  final String? animation;
  final String? highlightWidget;

  const OnboardingStep({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    this.animation,
    this.highlightWidget,
  });
}

/// FAQ分类数据模型
class FAQCategory {
  final String id;
  final String title;
  final String icon;
  final List<FAQItem> faqs;

  const FAQCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.faqs,
  });
}

/// FAQ项目数据模型
class FAQItem {
  final String id;
  final String question;
  final String answer;
  final List<String> tags;
  final List<String>? relatedSteps;

  const FAQItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.tags,
    this.relatedSteps,
  });
}

/// 快捷键数据模型
class ShortcutItem {
  final String id;
  final String description;
  final List<String> keys;
  final String category;

  const ShortcutItem({
    required this.id,
    required this.description,
    required this.keys,
    required this.category,
  });
}

/// 工具提示数据模型
class TooltipContent {
  final String title;
  final String description;
  final TooltipPosition position;

  const TooltipContent({
    required this.title,
    required this.description,
    required this.position,
  });
}

/// 工具提示位置枚举
enum TooltipPosition {
  top,
  bottom,
  left,
  right,
  center,
}

/// 教程步骤数据模型
class TutorialStep {
  final String id;
  final String title;
  final String description;
  final String targetWidget;
  final TutorialAction action;
  final TutorialAction? nextAction;

  const TutorialStep({
    required this.id,
    required this.title,
    required this.description,
    required this.targetWidget,
    required this.action,
    this.nextAction,
  });
}

/// 教程动作枚举
enum TutorialAction {
  highlight,
  tap,
  swipe,
  longPress,
}

/// 用户反馈数据模型
class UserFeedback {
  final String id;
  final String type; // 'bug', 'suggestion', 'rating'
  final String content;
  final double? rating;
  final String? contact;
  final DateTime timestamp;

  const UserFeedback({
    required this.id,
    required this.type,
    required this.content,
    this.rating,
    this.contact,
    required this.timestamp,
  });
}

/// 帮助内容本地化支持
class HelpLocalization {
  static final Map<String, Map<String, String>> _translations = {
    'zh': {
      'onboarding_title': '新用户引导',
      'faq_title': '常见问题',
      'shortcuts_title': '快捷键',
      'help_title': '帮助中心',
      'tutorial_title': '交互式教程',
      'feedback_title': '反馈建议',
      'search_hint': '搜索帮助内容...',
      'skip': '跳过',
      'next': '下一步',
      'previous': '上一步',
      'finish': '完成',
      'got_it': '知道了',
      'try_again': '重试',
      'contact_support': '联系客服',
    },
    'en': {
      'onboarding_title': 'Onboarding',
      'faq_title': 'FAQ',
      'shortcuts_title': 'Shortcuts',
      'help_title': 'Help Center',
      'tutorial_title': 'Interactive Tutorial',
      'feedback_title': 'Feedback',
      'search_hint': 'Search help content...',
      'skip': 'Skip',
      'next': 'Next',
      'previous': 'Previous',
      'finish': 'Finish',
      'got_it': 'Got it',
      'try_again': 'Try Again',
      'contact_support': 'Contact Support',
    },
  };

  static String getLocalizedText(String key, String locale) {
    return _translations[locale]?[key] ?? _translations['zh']?[key] ?? key;
  }
}