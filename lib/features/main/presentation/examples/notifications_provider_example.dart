import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/notifications_provider.dart';

/// Ejemplo completo de cómo usar el provider de notificaciones
class NotificationsProviderExample extends ConsumerWidget {
  const NotificationsProviderExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejemplo Provider Notificaciones'),
        backgroundColor: const Color(0xFF0D1B2A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(notificationsProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estadísticas generales
            _buildStatsCard(ref),
            const SizedBox(height: 16),
            
            // Controles para agregar notificaciones
            _buildAddNotificationsCard(ref),
            const SizedBox(height: 16),
            
            // Lista de notificaciones
            _buildNotificationsList(ref),
            const SizedBox(height: 16),
            
            // Providers específicos
            _buildSpecificProvidersCard(ref),
          ],
        ),
      ),
    );
  }

  // Tarjeta de estadísticas
  Widget _buildStatsCard(WidgetRef ref) {
    final stats = ref.watch(notificationsStatsProvider);
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Estadísticas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem('Total', stats['total'], Colors.blue),
                ),
                Expanded(
                  child: _buildStatItem('No leídas', stats['unread'], Colors.red),
                ),
                Expanded(
                  child: _buildStatItem('Leídas', stats['read'], Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem('Errores', stats['error'], Colors.red),
                ),
                Expanded(
                  child: _buildStatItem('Advertencias', stats['warning'], Colors.orange),
                ),
                Expanded(
                  child: _buildStatItem('Éxitos', stats['success'], Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  // Tarjeta para agregar notificaciones
  Widget _buildAddNotificationsCard(WidgetRef ref) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '➕ Agregar Notificaciones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(notificationsProvider.notifier).addSuccessNotification(
                      '¡Donación procesada exitosamente!',
                      data: {'amount': 150.0, 'donationId': 123},
                    );
                  },
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: const Text('Éxito', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(notificationsProvider.notifier).addErrorNotification(
                      'Error al conectar con el servidor',
                      data: {'errorCode': 'NETWORK_ERROR'},
                    );
                  },
                  icon: const Icon(Icons.error, color: Colors.white),
                  label: const Text('Error', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(notificationsProvider.notifier).addWarningNotification(
                      'Tu sesión expirará en 5 minutos',
                      data: {'expiresAt': DateTime.now().add(const Duration(minutes: 5))},
                    );
                  },
                  icon: const Icon(Icons.warning, color: Colors.white),
                  label: const Text('Advertencia', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(notificationsProvider.notifier).addInfoNotification(
                      'Nueva funcionalidad disponible',
                      data: {'feature': 'donations_history'},
                    );
                  },
                  icon: const Icon(Icons.info, color: Colors.white),
                  label: const Text('Info', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(notificationsProvider.notifier).markAllAsRead();
                    },
                    icon: const Icon(Icons.mark_email_read),
                    label: const Text('Marcar todas como leídas'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(notificationsProvider.notifier).clearNotifications();
                    },
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Limpiar todas'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Lista de notificaciones
  Widget _buildNotificationsList(WidgetRef ref) {
    final notifications = ref.watch(notificationsListProvider);
    final unreadCount = ref.watch(unreadCountProvider);
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '📋 Notificaciones ($unreadCount no leídas)',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (notifications.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      ref.read(notificationsProvider.notifier).markAllAsRead();
                    },
                    child: const Text('Marcar todas como leídas'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (notifications.isEmpty)
              const Center(
                child: Column(
                  children: [
                    Icon(Icons.notifications_none, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('No hay notificaciones', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            else
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _buildNotificationTile(ref, notification);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTile(WidgetRef ref, NotificationModel notification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: notification.isRead ? Colors.grey[50] : Colors.white,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getColorForType(notification.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getIconForType(notification.type),
            color: _getColorForType(notification.type),
            size: 20,
          ),
        ),
        title: Text(
          notification.message,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(notification.timestamp),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (notification.data != null)
              Text(
                'Datos: ${notification.data}',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            IconButton(
              icon: const Icon(Icons.close, size: 16),
              onPressed: () {
                ref.read(notificationsProvider.notifier).removeNotification(notification);
              },
            ),
          ],
        ),
        onTap: () {
          if (!notification.isRead) {
            ref.read(notificationsProvider.notifier).markAsRead(notification.id);
          }
        },
      ),
    );
  }

  // Tarjeta de providers específicos
  Widget _buildSpecificProvidersCard(WidgetRef ref) {
    final errorNotifications = ref.watch(errorNotificationsProvider);
    final successNotifications = ref.watch(successNotificationsProvider);
    final unreadNotifications = ref.watch(unreadNotificationsProvider);
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔍 Providers Específicos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildProviderStat('Errores', errorNotifications.length, Colors.red),
                ),
                Expanded(
                  child: _buildProviderStat('Éxitos', successNotifications.length, Colors.green),
                ),
                Expanded(
                  child: _buildProviderStat('No leídas', unreadNotifications.length, Colors.orange),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderStat(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.error:
        return Icons.error_outline;
      case NotificationType.warning:
        return Icons.warning_amber_outlined;
      case NotificationType.info:
        return Icons.info_outline;
      case NotificationType.success:
        return Icons.check_circle_outline;
    }
  }

  Color _getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.error:
        return Colors.red;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.info:
        return Colors.blue;
      case NotificationType.success:
        return Colors.green;
    }
  }
}

/// Ejemplo de widget que escucha cambios en las notificaciones
class NotificationsListener extends ConsumerWidget {
  const NotificationsListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Este widget se reconstruirá solo cuando cambie el contador de no leídas
    final unreadCount = ref.watch(unreadCountProvider);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: unreadCount > 0 ? Colors.red[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: unreadCount > 0 ? Colors.red : Colors.grey,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.notifications,
            color: unreadCount > 0 ? Colors.red : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            unreadCount > 0 
                ? 'Tienes $unreadCount notificación${unreadCount == 1 ? '' : 'es'} sin leer'
                : 'No tienes notificaciones sin leer',
            style: TextStyle(
              color: unreadCount > 0 ? Colors.red : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 