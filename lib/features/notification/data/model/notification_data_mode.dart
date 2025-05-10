class NotificationDataModel {
  final bool success;
  final int statusCode;
  final String message;
  final NotificationData data;

  NotificationDataModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) {
    return NotificationDataModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: NotificationData.fromJson(json['data'] ?? {}),
    );
  }
}

class NotificationData {
  final Meta meta;
  final List<NotificationItem> data;

  NotificationData({
    required this.meta,
    required this.data,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['data'] is List ? json['data'] : [];
    return NotificationData(
      meta: Meta.fromJson(json['meta'] ?? {}),
      data: list.map((item) => NotificationItem.fromJson(item)).toList(),
    );
  }
}

class Meta {
  final int page;
  final int limit;
  final int total;
  final int totalPage;

  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      totalPage: json['totalPage'] ?? 0,
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String senderId;
  final String createdAt;
  final bool read;
  final String bookingId;
  final Sender sender;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.senderId,
    required this.createdAt,
    required this.read,
    required this.bookingId,
    required this.sender,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      senderId: json['senderId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      read: json['read'] ?? false,
      bookingId: json['bookingId'] ?? '',
      sender: Sender.fromJson(json['sender'] ?? {}),
    );
  }
}

class Sender {
  final String userName;

  Sender({required this.userName});

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      userName: json['userName'] ?? '',
    );
  }
}
