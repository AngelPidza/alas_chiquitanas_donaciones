import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Enum para los tipos de notificación
enum NotificationType {
  error,
  warning,
  info,
  success,
}

// Modelo de notificación
class NotificationModel {
  final String id;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? data;

  const NotificationModel({
    required this.id,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.data,
  });

  // Constructor desde JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => NotificationType.info,
      ),
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      isRead: json['isRead'] ?? false,
      data: json['data'],
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'type': type.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'data': data,
    };
  }

  // Copiar con modificaciones
  NotificationModel copyWith({
    String? id,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Estado de las notificaciones
class NotificationsState {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final String? error;
  final int unreadCount;

  const NotificationsState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
    this.unreadCount = 0,
  });

  NotificationsState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    String? error,
    int? unreadCount,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

// Notifier para manejar las notificaciones
class NotificationsNotifier extends StateNotifier<NotificationsState> {
  NotificationsNotifier() : super(const NotificationsState()) {
    _loadNotifications();
  }

  // Cargar notificaciones desde SharedPreferences
  Future<void> _loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getStringList('notifications') ?? [];
      
      final notifications = notificationsJson
          .map((json) => NotificationModel.fromJson(jsonDecode(json)))
          .toList();
      
      // Ordenar por timestamp (más recientes primero)
      notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      final unreadCount = notifications.where((n) => !n.isRead).length;
      
      state = state.copyWith(
        notifications: notifications,
        unreadCount: unreadCount,
      );
    } catch (e) {
      state = state.copyWith(error: 'Error al cargar notificaciones: $e');
    }
  }

  // Guardar notificaciones en SharedPreferences
  Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = state.notifications
          .map((notification) => jsonEncode(notification.toJson()))
          .toList();
      
      await prefs.setStringList('notifications', notificationsJson);
    } catch (e) {
      state = state.copyWith(error: 'Error al guardar notificaciones: $e');
    }
  }

  // Agregar una nueva notificación
  void addNotification({
    required String message,
    required NotificationType type,
    Map<String, dynamic>? data,
  }) {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      type: type,
      timestamp: DateTime.now(),
      data: data,
    );

    final newNotifications = [notification, ...state.notifications];
    final unreadCount = newNotifications.where((n) => !n.isRead).length;

    state = state.copyWith(
      notifications: newNotifications,
      unreadCount: unreadCount,
    );

    _saveNotifications();
  }

  // Marcar notificación como leída
  void markAsRead(String notificationId) {
    final updatedNotifications = state.notifications.map((notification) {
      if (notification.id == notificationId) {
        return notification.copyWith(isRead: true);
      }
      return notification;
    }).toList();

    final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

    state = state.copyWith(
      notifications: updatedNotifications,
      unreadCount: unreadCount,
    );

    _saveNotifications();
  }

  // Marcar todas como leídas
  void markAllAsRead() {
    final updatedNotifications = state.notifications
        .map((notification) => notification.copyWith(isRead: true))
        .toList();

    state = state.copyWith(
      notifications: updatedNotifications,
      unreadCount: 0,
    );

    _saveNotifications();
  }

  // Eliminar una notificación
  void removeNotification(NotificationModel notification) {
    final updatedNotifications = state.notifications
        .where((n) => n.id != notification.id)
        .toList();

    final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

    state = state.copyWith(
      notifications: updatedNotifications,
      unreadCount: unreadCount,
    );

    _saveNotifications();
  }

  // Limpiar todas las notificaciones
  void clearNotifications() {
    state = state.copyWith(
      notifications: [],
      unreadCount: 0,
    );

    _saveNotifications();
  }

  // Limpiar error
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Recargar notificaciones
  Future<void> refresh() async {
    await _loadNotifications();
  }

  // Métodos de conveniencia para agregar notificaciones específicas
  void addErrorNotification(String message, {Map<String, dynamic>? data}) {
    addNotification(
      message: message,
      type: NotificationType.error,
      data: data,
    );
  }

  void addWarningNotification(String message, {Map<String, dynamic>? data}) {
    addNotification(
      message: message,
      type: NotificationType.warning,
      data: data,
    );
  }

  void addInfoNotification(String message, {Map<String, dynamic>? data}) {
    addNotification(
      message: message,
      type: NotificationType.info,
      data: data,
    );
  }

  void addSuccessNotification(String message, {Map<String, dynamic>? data}) {
    addNotification(
      message: message,
      type: NotificationType.success,
      data: data,
    );
  }

  // Obtener notificaciones por tipo
  List<NotificationModel> getNotificationsByType(NotificationType type) {
    return state.notifications
        .where((notification) => notification.type == type)
        .toList();
  }

  // Obtener notificaciones no leídas
  List<NotificationModel> get unreadNotifications {
    return state.notifications
        .where((notification) => !notification.isRead)
        .toList();
  }

  // Obtener notificaciones leídas
  List<NotificationModel> get readNotifications {
    return state.notifications
        .where((notification) => notification.isRead)
        .toList();
  }
}

// Provider principal
final notificationsProvider = StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  return NotificationsNotifier();
});

// Providers específicos para mejor rendimiento
final notificationsListProvider = Provider<List<NotificationModel>>((ref) {
  return ref.watch(notificationsProvider).notifications;
});

final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).unreadCount;
});

final isLoadingNotificationsProvider = Provider<bool>((ref) {
  return ref.watch(notificationsProvider).isLoading;
});

final notificationsErrorProvider = Provider<String?>((ref) {
  return ref.watch(notificationsProvider).error;
});

// Providers para notificaciones específicas
final unreadNotificationsProvider = Provider<List<NotificationModel>>((ref) {
  final notifications = ref.watch(notificationsListProvider);
  return notifications.where((n) => !n.isRead).toList();
});

final readNotificationsProvider = Provider<List<NotificationModel>>((ref) {
  final notifications = ref.watch(notificationsListProvider);
  return notifications.where((n) => n.isRead).toList();
});

// Providers por tipo de notificación
final errorNotificationsProvider = Provider<List<NotificationModel>>((ref) {
  final notifications = ref.watch(notificationsListProvider);
  return notifications.where((n) => n.type == NotificationType.error).toList();
});

final warningNotificationsProvider = Provider<List<NotificationModel>>((ref) {
  final notifications = ref.watch(notificationsListProvider);
  return notifications.where((n) => n.type == NotificationType.warning).toList();
});

final infoNotificationsProvider = Provider<List<NotificationModel>>((ref) {
  final notifications = ref.watch(notificationsListProvider);
  return notifications.where((n) => n.type == NotificationType.info).toList();
});

final successNotificationsProvider = Provider<List<NotificationModel>>((ref) {
  final notifications = ref.watch(notificationsListProvider);
  return notifications.where((n) => n.type == NotificationType.success).toList();
});

// Provider para estadísticas de notificaciones
final notificationsStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final notifications = ref.watch(notificationsListProvider);
  final unreadCount = ref.watch(unreadCountProvider);

  final errorCount = notifications.where((n) => n.type == NotificationType.error).length;
  final warningCount = notifications.where((n) => n.type == NotificationType.warning).length;
  final infoCount = notifications.where((n) => n.type == NotificationType.info).length;
  final successCount = notifications.where((n) => n.type == NotificationType.success).length;

  return {
    'total': notifications.length,
    'unread': unreadCount,
    'read': notifications.length - unreadCount,
    'error': errorCount,
    'warning': warningCount,
    'info': infoCount,
    'success': successCount,
  };
});
