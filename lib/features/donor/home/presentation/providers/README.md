# Provider de Donaciones

Este provider maneja el estado de las donaciones del donante, incluyendo tanto donaciones en especie como donaciones en dinero.

## Características

- ✅ Manejo de estado con Riverpod
- ✅ Carga de donaciones en especie y dinero
- ✅ Agrupación automática de donaciones
- ✅ Manejo de errores
- ✅ Estados de carga
- ✅ Providers específicos para mejor rendimiento
- ✅ Estadísticas calculadas automáticamente

## Uso Básico

### 1. Provider Principal

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final donationsState = ref.watch(donationsProvider);
    
    if (donationsState.isLoading) {
      return CircularProgressIndicator();
    }
    
    if (donationsState.error != null) {
      return Text('Error: ${donationsState.error}');
    }
    
    return ListView.builder(
      itemCount: donationsState.groupedDonations.length,
      itemBuilder: (context, index) {
        return DonationCard(donation: donationsState.groupedDonations[index]);
      },
    );
  }
}
```

### 2. Providers Específicos (Recomendado)

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);
    final error = ref.watch(errorProvider);
    final groupedDonations = ref.watch(groupedDonationsProvider);
    final moneyDonations = ref.watch(moneyDonationsProvider);
    
    // Tu widget aquí...
  }
}
```

### 3. Cargar Donaciones

```dart
// En initState o cuando necesites cargar datos
ref.read(donationsProvider.notifier).loadDonations();

// O para recargar
ref.read(donationsProvider.notifier).refresh();
```

### 4. Provider de Estadísticas

```dart
class StatsWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(donationsStatsProvider);
    
    return Row(
      children: [
        Text('Total en especie: ${stats['totalInKind']}'),
        Text('Total en dinero: ${stats['totalMoney']}'),
        Text('Monto total: \$${stats['totalAmount']}'),
      ],
    );
  }
}
```

## Estructura de Datos

### DonationsState
```dart
class DonationsState {
  final List<Map<String, dynamic>> groupedDonations;
  final List<dynamic> moneyDonations;
  final bool isLoading;
  final String? error;
}
```

### Donación Agrupada (En Especie)
```dart
{
  'id_donacion_especie': int,
  'nombre_articulo': String,
  'cantidad_total': int,
  'cantidad_restante_total': int,
  'distribuciones': List<Map<String, dynamic>>,
  'has_distributions': bool,
}
```

### Donación en Dinero
```dart
{
  'monto': double,
  'fecha_donacion': String,
  'descripcion': String,
  // ... otros campos
}
```

## Providers Disponibles

| Provider | Tipo | Descripción |
|----------|------|-------------|
| `donationsProvider` | `StateNotifierProvider<DonationsNotifier, DonationsState>` | Provider principal |
| `groupedDonationsProvider` | `Provider<List<Map<String, dynamic>>>` | Solo donaciones en especie agrupadas |
| `moneyDonationsProvider` | `Provider<List<dynamic>>` | Solo donaciones en dinero |
| `isLoadingProvider` | `Provider<bool>` | Estado de carga |
| `errorProvider` | `Provider<String?>` | Error actual |
| `totalMoneyDonatedProvider` | `Provider<double>` | Total de dinero donado |
| `donationsStatsProvider` | `Provider<Map<String, dynamic>>` | Estadísticas generales |

## Métodos del Notifier

### loadDonations()
Carga todas las donaciones del donante desde la API.

### refresh()
Recarga las donaciones (alias de loadDonations).

### clearError()
Limpia el error actual del estado.

## Manejo de Errores

El provider maneja automáticamente:
- Errores de red
- Errores de autenticación
- Errores de la API
- Estados de carga

## Ejemplo Completo

```dart
class MyDonationsScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyDonationsScreen> createState() => _MyDonationsScreenState();
}

class _MyDonationsScreenState extends ConsumerState<MyDonationsScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar donaciones al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(donationsProvider.notifier).loadDonations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProvider);
    final error = ref.watch(errorProvider);
    final groupedDonations = ref.watch(groupedDonationsProvider);
    final moneyDonations = ref.watch(moneyDonationsProvider);

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          children: [
            Text('Error: $error'),
            ElevatedButton(
              onPressed: () => ref.read(donationsProvider.notifier).loadDonations(),
              child: Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(donationsProvider.notifier).loadDonations(),
        child: ListView(
          children: [
            // Tus widgets aquí...
          ],
        ),
      ),
    );
  }
}
```

## Notas Importantes

1. **Riverpod**: Asegúrate de que tu app esté envuelta en `ProviderScope`
2. **Autenticación**: El provider usa `SharedPreferences` para obtener el token y donante_id
3. **API**: Las URLs están hardcodeadas, considera usar variables de entorno
4. **Rendimiento**: Usa providers específicos en lugar del principal cuando sea posible
5. **Errores**: Siempre maneja los estados de error y carga en tu UI 