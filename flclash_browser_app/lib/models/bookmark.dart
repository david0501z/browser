class Bookmark {
  int? id;
  String title;
  String url;
  String? description;
  String? favicon;
  DateTime createdAt;
  DateTime? updatedAt;
  String? tags;
  int? orderIndex;
  bool isFolder;

  Bookmark({
    this.id,
    required this.title,
    required this.url,
    this.description,
    this.favicon,
    DateTime? createdAt,
    this.updatedAt,
    this.tags,
    this.orderIndex,
    this.isFolder = false,
  }) : createdAt = createdAt ?? DateTime.now();

  // 将Bookmark对象转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'description': description,
      'favicon': favicon,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'tags': tags,
      'orderIndex': orderIndex,
      'isFolder': isFolder ? 1 : 0,
    };
  }

  // 从Map创建Bookmark对象
  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'],
      title: map['title'],
      url: map['url'],
      description: map['description'],
      favicon: map['favicon'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: map['updatedAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : null,
      tags: map['tags'],
      orderIndex: map['orderIndex'],
      isFolder: map['isFolder'] == 1,
    );
  }

  // 复制Bookmark对象
  Bookmark copyWith({
    int? id,
    String? title,
    String? url,
    String? description,
    String? favicon,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? tags,
    int? orderIndex,
    bool? isFolder,
  }) {
    return Bookmark(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      description: description ?? this.description,
      favicon: favicon ?? this.favicon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      orderIndex: orderIndex ?? this.orderIndex,
      isFolder: isFolder ?? this.isFolder,
    );
  }

  @override
  String toString() {
    return 'Bookmark{id: $id, title: $title, url: $url, isFolder: $isFolder}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Bookmark &&
        other.id == id &&
        other.title == title &&
        other.url == url;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ url.hashCode;
  }
}