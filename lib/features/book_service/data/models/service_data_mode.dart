class ServiceDataModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<ServiceData> data;

  ServiceDataModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ServiceDataModel.fromJson(Map<String, dynamic> json) {
    return ServiceDataModel(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => ServiceData.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ServiceData {
  final String id;
  final String userId;
  final String title;
  final String createdAt;
  final String updatedAt;
  final List<ConnectedService> connectedService;

  ServiceData({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.connectedService,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      connectedService: (json['ConnectedService'] as List<dynamic>?)
              ?.map((e) => ConnectedService.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ConnectedService {
  final String id;
  final String userId;
  final String serviceId;
  final String type;
  final String offer;
  final String additionalOffer;
  final String duration;
  final int price;
  final String createdAt;
  final String updatedAt;

  ConnectedService({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.type,
    required this.offer,
    required this.additionalOffer,
    required this.duration,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConnectedService.fromJson(Map<String, dynamic> json) {
    return ConnectedService(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      serviceId: json['serviceId'] ?? '',
      type: json['type'] ?? '',
      offer: json['offer'] ?? '',
      additionalOffer: json['additionalOffer'] ?? '',
      duration: json['duration'] ?? '',
      price: json['price'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
