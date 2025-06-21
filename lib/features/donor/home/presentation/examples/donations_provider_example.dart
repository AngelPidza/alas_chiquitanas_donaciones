import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/donations_provider.dart';

/// Ejemplo de cómo usar el provider de donaciones de diferentes maneras
class DonationsProviderExample extends ConsumerWidget {
  const DonationsProviderExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejemplo Provider Donaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Recargar donaciones
              ref.read(donationsProvider.notifier).loadDonations();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Ejemplo 1: Usar el provider principal
          _buildMainProviderExample(ref),
          
          const SizedBox(height: 20),
          
          // Ejemplo 2: Usar providers específicos
          _buildSpecificProvidersExample(ref),
          
          const SizedBox(height: 20),
          
          // Ejemplo 3: Usar el provider de estadísticas
          _buildStatsProviderExample(ref),
          
          const SizedBox(height: 20),
          
          // Ejemplo 4: Listener para cambios
          _buildListenerExample(ref),
        ],
      ),
    );
  }

  // Ejemplo 1: Usar el provider principal
  Widget _buildMainProviderExample(WidgetRef ref) {
    final donationsState = ref.watch(donationsProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Provider Principal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Estado de carga: ${donationsState.isLoading}'),
            Text('Error: ${donationsState.error ?? "Sin errores"}'),
            Text('Donaciones en especie: ${donationsState.groupedDonations.length}'),
            Text('Donaciones en dinero: ${donationsState.moneyDonations.length}'),
          ],
        ),
      ),
    );
  }

  // Ejemplo 2: Usar providers específicos
  Widget _buildSpecificProvidersExample(WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);
    final error = ref.watch(errorProvider);
    final groupedDonations = ref.watch(groupedDonationsProvider);
    final moneyDonations = ref.watch(moneyDonationsProvider);
    final totalMoney = ref.watch(totalMoneyDonatedProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Providers Específicos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Cargando: $isLoading'),
            Text('Error: ${error ?? "Sin errores"}'),
            Text('Donaciones en especie: ${groupedDonations.length}'),
            Text('Donaciones en dinero: ${moneyDonations.length}'),
            Text('Total donado: \$${totalMoney.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  // Ejemplo 3: Usar el provider de estadísticas
  Widget _buildStatsProviderExample(WidgetRef ref) {
    final stats = ref.watch(donationsStatsProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Provider de Estadísticas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Total en especie: ${stats['totalInKind']}'),
            Text('Total en dinero: ${stats['totalMoney']}'),
            Text('Monto total: \$${stats['totalAmount'].toStringAsFixed(2)}'),
            Text('Total de donaciones: ${stats['totalDonations']}'),
          ],
        ),
      ),
    );
  }

  // Ejemplo 4: Listener para cambios
  Widget _buildListenerExample(WidgetRef ref) {
    // Este widget se reconstruirá solo cuando cambie el estado de carga
    final isLoading = ref.watch(isLoadingProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Listener de Estado',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (isLoading)
              const Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Cargando donaciones...'),
                ],
              )
            else
              const Text('Donaciones cargadas'),
          ],
        ),
      ),
    );
  }
}

/// Ejemplo de cómo usar el provider en un StatefulWidget
class DonationsStatefulExample extends ConsumerStatefulWidget {
  const DonationsStatefulExample({super.key});

  @override
  ConsumerState<DonationsStatefulExample> createState() => _DonationsStatefulExampleState();
}

class _DonationsStatefulExampleState extends ConsumerState<DonationsStatefulExample> {
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
    final donationsState = ref.watch(donationsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('StatefulWidget Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (donationsState.isLoading)
              const CircularProgressIndicator()
            else if (donationsState.error != null)
              Column(
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${donationsState.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(donationsProvider.notifier).loadDonations();
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              )
            else
              Column(
                children: [
                  const Icon(Icons.check_circle, size: 64, color: Colors.green),
                  const SizedBox(height: 16),
                  Text('Donaciones cargadas: ${donationsState.groupedDonations.length}'),
                  Text('Donaciones en dinero: ${donationsState.moneyDonations.length}'),
                ],
              ),
          ],
        ),
      ),
    );
  }
} 