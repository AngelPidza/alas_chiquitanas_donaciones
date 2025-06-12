# Provider de Notificaciones

Este provider maneja el estado de las notificaciones de la aplicación usando Riverpod, con persistencia local en SharedPreferences.

## Características

- ✅ Manejo de estado con Riverpod
- ✅ Persistencia local con SharedPreferences
- ✅ Diferentes tipos de notificación (error, warning, info, success)
- ✅ Contador de notificaciones no leídas
- ✅ Métodos de conveniencia para cada tipo
- ✅ Providers específicos para mejor rendimiento
- ✅ Estadísticas automáticas
- ✅ Ordenamiento por fecha (más recientes primero)

## Uso Básico

### 1. Provider Principal

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsState = ref.watch(notificationsProvider);
    
    return Column(
      children: [
        Text('Total: ${notificationsState.notifications.length}'),
        Text('No leídas: ${notificationsState.unreadCount}'),
        if (notificationsState.error != null)
          Text('Error: ${notificationsState.error}'),
      ],
    );
  }
}
```

### 2. Providers Específicos (Recomendado)

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsListProvider);
    final unreadCount = ref.watch(unreadCountProvider);
    final error = ref.watch(notificationsErrorProvider);
    
    return Column(
      children: [
        Text('Notificaciones: ${notifications.length}'),
        Text('No leídas: $unreadCount'),
        if (error != null) Text('Error: $error'),
      ],
    );
  }
}
```

### 3. Agregar Notificaciones

```dart
// Método general
ref.read(notificationsProvider.notifier).addNotification(
  message: 'Tu donación ha sido procesada',
  type: NotificationType.success,
  data: {'donationId': 123},
);

// Métodos de conveniencia
ref.read(notificationsProvider.notifier).addSuccessNotification(
  '¡Donación exitosa!',
  data: {'amount': 100.0},
);

ref.read(notificationsProvider.notifier).addErrorNotification(
  'Error al procesar la donación',
  data: {'errorCode': 'NETWORK_ERROR'},
);

ref.read(notificationsProvider.notifier).addWarningNotification(
  'Tu sesión expirará pronto',
);

ref.read(notificationsProvider.notifier).addInfoNotification(
  'Nueva funcionalidad disponible',
);
```

### 4. Gestionar Notificaciones

```dart
// Marcar como leída
ref.read(notificationsProvider.notifier).markAsRead(notificationId);

// Marcar todas como leídas
ref.read(notificationsProvider.notifier).markAllAsRead();

// Eliminar una notificación
ref.read(notificationsProvider.notifier).removeNotification(notification);

// Limpiar todas
ref.read(notificationsProvider.notifier).clearNotifications();

// Recargar
ref.read(notificationsProvider.notifier).refresh();
```

### 5. Providers por Tipo

```dart
class NotificationsByTypeWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorNotifications = ref.watch(errorNotificationsProvider);
    final successNotifications = ref.watch(successNotificationsProvider);
    final unreadNotifications = ref.watch(unreadNotificationsProvider);
    
    return Column(
      children: [
        Text('Errores: ${errorNotifications.length}'),
        Text('Éxitos: ${successNotifications.length}'),
        Text('No leídas: ${unreadNotifications.length}'),
      ],
    );
  }
}
```

### 6. Estadísticas

```dart
class StatsWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(notificationsStatsProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Total: ${stats['total']}'),
            Text('No leídas: ${stats['unread']}'),
            Text('Leídas: ${stats['read']}'),
            Text('Errores: ${stats['error']}'),
            Text('Advertencias: ${stats['warning']}'),
            Text('Información: ${stats['info']}'),
            Text('Éxitos: ${stats['success']}'),
          ],
        ),
      ),
    );
  }
}
```

## Estructura de Datos

### NotificationType
```dart
enum NotificationType {
  error,    // Errores (rojo)
  warning,  // Advertencias (naranja)
  info,     // Información (azul)
  success,  // Éxitos (verde)
}
```

### NotificationModel
```dart
class NotificationModel {
  final String id;                    // ID único
  final String message;               // Mensaje de la notificación
  final NotificationType type;        // Tipo de notificación
  final DateTime timestamp;           // Fecha y hora
  final bool isRead;                  // Si está leída
  final Map<String, dynamic>? data;   // Datos adicionales
}
```

### NotificationsState
```dart
class NotificationsState {
  final List<NotificationModel> notifications;  // Lista de notificaciones
  final bool isLoading;                         // Estado de carga
  final String? error;                          // Error actual
  final int unreadCount;                        // Contador de no leídas
}
```

## Providers Disponibles

| Provider | Tipo | Descripción |
|----------|------|-------------|
| `notificationsProvider` | `StateNotifierProvider<NotificationsNotifier, NotificationsState>` | Provider principal |
| `notificationsListProvider` | `Provider<List<NotificationModel>>` | Lista de notificaciones |
| `unreadCountProvider` | `Provider<int>` | Contador de no leídas |
| `isLoadingNotificationsProvider` | `Provider<bool>` | Estado de carga |
| `notificationsErrorProvider` | `Provider<String?>` | Error actual |
| `unreadNotificationsProvider` | `Provider<List<NotificationModel>>` | Solo no leídas |
| `readNotificationsProvider` | `Provider<List<NotificationModel>>` | Solo leídas |
| `errorNotificationsProvider` | `Provider<List<NotificationModel>>` | Solo errores |
| `warningNotificationsProvider` | `Provider<List<NotificationModel>>` | Solo advertencias |
| `infoNotificationsProvider` | `Provider<List<NotificationModel>>` | Solo información |
| `successNotificationsProvider` | `Provider<List<NotificationModel>>` | Solo éxitos |
| `notificationsStatsProvider` | `Provider<Map<String, dynamic>>` | Estadísticas |

## Métodos del Notifier

### Gestión de Notificaciones
- `addNotification(message, type, data)` - Agregar notificación general
- `addErrorNotification(message, data)` - Agregar error
- `addWarningNotification(message, data)` - Agregar advertencia
- `addInfoNotification(message, data)` - Agregar información
- `addSuccessNotification(message, data)` - Agregar éxito

### Gestión de Estado
- `markAsRead(notificationId)` - Marcar como leída
- `markAllAsRead()` - Marcar todas como leídas
- `removeNotification(notification)` - Eliminar notificación
- `clearNotifications()` - Limpiar todas
- `refresh()` - Recargar desde almacenamiento

### Consultas
- `getNotificationsByType(type)` - Obtener por tipo
- `get unreadNotifications` - Obtener no leídas
- `get readNotifications` - Obtener leídas

## Ejemplo Completo

```dart
class NotificationsScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsListProvider);
    final unreadCount = ref.watch(unreadCountProvider);
    final error = ref.watch(notificationsErrorProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones ($unreadCount)'),
        actions: [
          if (unreadCount > 0)
            IconButton(
              icon: Icon(Icons.mark_email_read),
              onPressed: () {
                ref.read(notificationsProvider.notifier).markAllAsRead();
              },
            ),
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: () {
              ref.read(notificationsProvider.notifier).clearNotifications();
            },
          ),
        ],
      ),
      body: error != null
          ? Center(
              child: Column(
                children: [
                  Text('Error: $error'),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(notificationsProvider.notifier).refresh();
                    },
                    child: Text('Reintentar'),
                  ),
                ],
              ),
            )
          : notifications.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      Icon(Icons.notifications_none, size: 64),
                      Text('No hay notificaciones'),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return ListTile(
                      leading: Icon(
                        _getIconForType(notification.type),
                        color: _getColorForType(notification.type),
                      ),
                      title: Text(notification.message),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(notification.timestamp),
                      ),
                      trailing: notification.isRead
                          ? null
                          : Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                      onTap: () {
                        if (!notification.isRead) {
                          ref.read(notificationsProvider.notifier)
                              .markAsRead(notification.id);
                        }
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ejemplo: agregar notificación de prueba
          ref.read(notificationsProvider.notifier).addSuccessNotification(
            'Notificación de prueba agregada',
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.error:
        return Icons.error;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.info:
        return Icons.info;
      case NotificationType.success:
        return Icons.check_circle;
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
```

## Notas Importantes

1. **Riverpod**: Asegúrate de que tu app esté envuelta en `ProviderScope`
2. **SharedPreferences**: El provider usa SharedPreferences para persistencia
3. **Ordenamiento**: Las notificaciones se ordenan automáticamente por fecha (más recientes primero)
4. **Rendimiento**: Usa providers específicos en lugar del principal cuando sea posible
5. **Datos adicionales**: Puedes incluir datos extra en el campo `data` para información específica
6. **Persistencia**: Las notificaciones se guardan automáticamente en el dispositivo

## Integración con el Widget Existente

El provider está diseñado para funcionar perfectamente con tu `NotificationsDialog` existente. Solo necesitas asegurarte de que el widget use `NotificationModel` en lugar de un tipo genérico:

```dart
// En tu widget, cambiar:
List notifications

// Por:
List<NotificationModel> notifications
```

Y actualizar las referencias a las propiedades:

```dart
// En lugar de:
notification.message
notification.type
notification.timestamp

// Usar:
notification.message
notification.type
notification.timestamp
``` 