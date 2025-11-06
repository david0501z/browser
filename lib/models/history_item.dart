class HistoryItem {
  int? id;
  String title;
  String url;
  String? description;
  String? favicon;
  DateTime visitedAt;
  int visitCount;
  int? duration; // 访问时长（秒）
  String? userAgent;
  String? referrer;
  bool isBookmarked;

  HistoryItem({
    this.id,
    required this.title,
    required this.url,
    this.description,
    this.favicon,
    DateTime? visitedAt,
    this.visitCount = 1,
    this.duration,
    this.userAgent,
    this.referrer,
    this.isBookmarked = false,
  }) : visitedAt = visitedAt ?? DateTime.now();

  // 将HistoryItem对象转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'description': description,
      'favicon': favicon,
      'visitedAt': visitedAt.millisecondsSinceEpoch,
      'visitCount': visitCount,
      'duration': duration,
      'userAgent': userAgent,
      'referrer': referrer,
      'isBookmarked': isBookmarked ? 1 : 0,
    };
  }

  // 从Map创建HistoryItem对象
  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      id: map['id'],
      title: map['title'],
      url: map['url'],
      description: map['description'],
      favicon: map['favicon'],
      visitedAt: DateTime.fromMillisecondsSinceEpoch(map['visitedAt']),
      visitCount: map['visitCount'] ?? 1,
      duration: map['duration'],
      userAgent: map['userAgent'],
      referrer: map['referrer'],
      isBookmarked: map['isBookmarked'] == 1,
    );
  }

  // 复制HistoryItem对象
  HistoryItem copyWith({
    int? id,
    String? title,
    String? url,
    String? description,
    String? favicon,
    DateTime? visitedAt,
    int? visitCount,
    int? duration,
    String? userAgent,
    String? referrer,
    bool? isBookmarked,
  }) {
    return HistoryItem(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      description: description ?? this.description,
      favicon: favicon ?? this.favicon,
      visitedAt: visitedAt ?? this.visitedAt,
      visitCount: visitCount ?? this.visitCount,
      duration: duration ?? this.duration,
      userAgent: userAgent ?? this.userAgent,
      referrer: referrer ?? this.referrer,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  // 格式化访问时间
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(visitedAt);
    
    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${visitedAt.year}-${visitedAt.month.toString().padLeft(2, '0')}-${visitedAt.day.toString().padLeft(2, '0')}';
    }
  }

  // 格式化访问时长
  String get formattedDuration {
    if (duration == null) return '';
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    if (minutes > 0) {
      return '${minutes}分${seconds}秒';
    } else {
      return '${seconds}秒';
    }
  }

  @override
  String toString() {
    return 'HistoryItem{id: $id, title: $title, url: $url, visitCount: $visitCount}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HistoryItem &&
        other.id == id &&
        other.title == title &&
        other.url == url;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ url.hashCode;
  }
}