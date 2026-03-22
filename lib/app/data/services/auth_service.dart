import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_models.dart';
import '../network/api_client.dart';
import 'package:logger/logger.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(client: ref.watch(apiClientProvider));
});

final userProfileProvider = FutureProvider.autoDispose<UserModel>((ref) async {
  final response = await ref.watch(authServiceProvider).getProfile();
  if (response.success && response.data != null) {
    return response.data!;
  }
  throw Exception(response.message);
});

/// Service layer for authentication.
class AuthService {
  final ApiClient _client;
  final Logger _logger = Logger();

  AuthService({ApiClient? client}) : _client = client ?? ApiClient();

  // ── Update Name (Requested Endpoint) ──────────────────────────────────────
  Future<AuthResponseModel> updateName({required String fullName}) async {
    try {
      final json = await _client.put(
        '${ApiClient.baseUrl}/update-name',
        data: {'fullName': fullName},
        requiresAuth: true,
      );
      return AuthResponseModel.fromJson(json);
    } on ApiException catch (e) {
      return AuthResponseModel(success: false, message: e.message);
    } catch (e) {
      return AuthResponseModel(success: false, message: e.toString());
    }
  }

  Future<AuthResponseModel> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final data = await _client.post(
        '${ApiClient.baseUrl}/register',
        data: {
          'fullName': fullName,
          'email': email,
          'phoneNumber': phoneNumber,
          'password': password,
          'confirmPassword': confirmPassword,
        },
      );
      return AuthResponseModel.fromJson(data);
    } on ApiException catch (e) {
      return AuthResponseModel(success: false, message: e.message);
    } catch (e) {
      return AuthResponseModel(success: false, message: e.toString());
    }
  }

  Future<AuthResponseModel> sendOtp({
    required String phoneNumber,
  }) async {
    try {
      _logger.i('Sending OTP request for $phoneNumber');
      final data = await _client.post(
        '${ApiClient.otpBaseUrl}/send',
        data: {
          'phoneNumber': phoneNumber,
        },
      );
      final response = AuthResponseModel.fromJson(data);
      if (response.success && response.otp != null) {
        _logger.w('VERIFICATION OTP FOR $phoneNumber IS: ${response.otp}');
      }
      return response;
    } on ApiException catch (e) {
      return AuthResponseModel(success: false, message: e.message);
    } catch (e) {
      return AuthResponseModel(success: false, message: e.toString());
    }
  }

  Future<AuthResponseModel> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      _logger.i('Verifying OTP $otp for $phoneNumber');
      final data = await _client.post(
        '${ApiClient.otpBaseUrl}/verify',
        data: {
          'phoneNumber': phoneNumber,
          'otp': otp,
        },
      );
      final response = AuthResponseModel.fromJson(data);
      if (response.success && response.token != null && response.token!.isNotEmpty) {
        _logger.i('OTP Verified successfully. Token obtained.');
        await ApiClient.saveToken(response.token!);
      }
      return response;
    } on ApiException catch (e) {
      return AuthResponseModel(success: false, message: e.message);
    } catch (e) {
      return AuthResponseModel(success: false, message: e.toString());
    }
  }

  // ── Forgot / Change Password ───────────────────────────────────────────────
  Future<AuthResponseModel> forgotPassword({
    required String email,
  }) async {
    try {
      final data = await _client.post(
        '${ApiClient.baseUrl}/forgot-password',
        data: {'email': email},
      );
      return AuthResponseModel.fromJson(data);
    } on ApiException catch (e) {
      return AuthResponseModel(success: false, message: e.message);
    } catch (e) {
      return AuthResponseModel(
          success: false, message: 'Unexpected error: ${e.toString()}');
    }
  }

  Future<AuthResponseModel> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final data = await _client.put(
        '${ApiClient.baseUrl}/change-password',
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
        requiresAuth: true,
      );
      return AuthResponseModel.fromJson(data);
    } on ApiException catch (e) {
      return AuthResponseModel(success: false, message: e.message);
    } catch (e) {
      return AuthResponseModel(
          success: false, message: 'Unexpected error: ${e.toString()}');
    }
  }

  // ── Profile ───────────────────────────────────────────────────────────────
  Future<AuthResponseModel> getProfile() async {
    try {
      final data = await _client.get(
        '${ApiClient.baseUrl}/profile',
        requiresAuth: true,
      );
      return AuthResponseModel.fromJson(data);
    } on ApiException catch (e) {
      return AuthResponseModel(success: false, message: e.message);
    } catch (e) {
      return AuthResponseModel(
          success: false, message: 'Unexpected error: ${e.toString()}');
    }
  }

  Future<AuthResponseModel> updateProfile({
    required String fullName,
    required String email,
  }) async {
    try {
      final data = await _client.post(
        '${ApiClient.baseUrl}/profile',
        data: {
          'fullName': fullName,
          'email': email,
        },
        requiresAuth: true,
      );
      return AuthResponseModel.fromJson(data);
    } on ApiException catch (e) {
      return AuthResponseModel(success: false, message: e.message);
    } catch (e) {
      return AuthResponseModel(
          success: false, message: 'Unexpected error: ${e.toString()}');
    }
  }

  // ── Update FCM Token ─────────────────────────────────────────────────────
  Future<AuthResponseModel> updateFcmToken({required String fcmToken}) async {
    try {
      final data = await _client.post(
        '${ApiClient.baseUrl}/update-fcm-token',
        data: {'fcmToken': fcmToken},
        requiresAuth: true,
      );
      return AuthResponseModel.fromJson(data);
    } on ApiException catch (e) {
      return AuthResponseModel(success: false, message: e.message);
    } catch (e) {
      return AuthResponseModel(success: false, message: e.toString());
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    await ApiClient.clearToken();
  }
}
