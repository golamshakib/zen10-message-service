class ProfileResponse {
  bool success;
  int statusCode;
  String message;
  Data data;

  ProfileResponse({
    this.success = false,
    this.statusCode = 0,
    this.message = '',
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: Data.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'statusCode': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class Data {
  String id;
  String userName;
  String email;
  String profileImage;
  String role;
  String status;
  String paypalAccountId;
  String location;
  double locationLatitude;
  double locationLongitude;

  Data({
    this.id = '',
    this.userName = '',
    this.email = '',
    this.profileImage = '',
    this.role = '',
    this.status = '',
    this.paypalAccountId = '',
    this.location = '',
    this.locationLatitude = 0.0,
    this.locationLongitude = 0.0,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      paypalAccountId: json['paypalAccountId'] ?? '',
      location: json['location'] ?? '',
      locationLatitude: json['locationLatitude'] ?? 0.0,
      locationLongitude: json['locationLongitude'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'profileImage': profileImage,
      'role': role,
      'status': status,
      'paypalAccountId': paypalAccountId,
      'location': location,
      'locationLatitude': locationLatitude,
      'locationLongitude': locationLongitude,
    };
  }
}
