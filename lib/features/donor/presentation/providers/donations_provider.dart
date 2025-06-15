import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Estado de las donaciones
class DonationsState {
  final List<Map<String, dynamic>> groupedDonations;
  final List<dynamic> moneyDonations;
  final bool isLoading;
  final String? error;

  const DonationsState({
    this.groupedDonations = const [],
    this.moneyDonations = const [],
    this.isLoading = false,
    this.error,
  });

  DonationsState copyWith({
    List<Map<String, dynamic>>? groupedDonations,
    List<dynamic>? moneyDonations,
    bool? isLoading,
    String? error,
  }) {
    return DonationsState(
      groupedDonations: groupedDonations ?? this.groupedDonations,
      moneyDonations: moneyDonations ?? this.moneyDonations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifier para manejar las donaciones
class DonationsNotifier extends StateNotifier<DonationsState> {
  DonationsNotifier() : super(const DonationsState());

  Future<void> loadDonations() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final prefs = await SharedPreferences.getInstance();
      final donanteId = prefs.getInt('donante_id');
      final token = prefs.getString('token');

      print('donanteId: $donanteId, token: $token');

      if (donanteId == null || token == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'No se encontró información de sesión',
        );
        return;
      }

      // Cargar donaciones en especie
      final especieResponse = await http.get(
        Uri.parse(
          'https://backenddonaciones.onrender.com/api/donantes/$donanteId/donaciones',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Cargar donaciones en dinero
      final dineroResponse = await http.get(
        Uri.parse(
          'https://backenddonaciones.onrender.com/api/donaciones-en-dinero/getAllById/$donanteId',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      List<Map<String, dynamic>> groupedDonations = [];
      List<dynamic> moneyDonations = [];

      // Procesar donaciones en especie
      if (especieResponse.statusCode == 200) {
        final rawDonations = json.decode(especieResponse.body);
        groupedDonations = _groupDonations(rawDonations);
      } else {
        throw Exception(
          'Error al cargar donaciones en especie: ${especieResponse.statusCode}',
        );
      }

      // Procesar donaciones en dinero
      if (dineroResponse.statusCode == 200) {
        final rawMoneyDonations = json.decode(dineroResponse.body);
        print('rawMoneyDonations: $rawMoneyDonations');
        moneyDonations = rawMoneyDonations is List ? rawMoneyDonations : [];
      } else if (dineroResponse.statusCode != 404) {
        // 404 significa que no hay donaciones en dinero, lo cual es válido
        throw Exception(
          'Error al cargar donaciones en dinero: ${dineroResponse.statusCode}',
        );
      }

      state = state.copyWith(
        groupedDonations: groupedDonations,
        moneyDonations: moneyDonations,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar donaciones: ${e.toString()}',
      );
    }
  }

  List<Map<String, dynamic>> _groupDonations(List<dynamic> rawDonations) {
    Map<int, Map<String, dynamic>> grouped = {};

    for (var donation in rawDonations) {
      int donationId = donation['id_donacion_especie'];

      if (!grouped.containsKey(donationId)) {
        grouped[donationId] = {
          'id_donacion_especie': donationId,
          'nombre_articulo':
              donation['nombre_articulo'] ?? 'Artículo sin nombre',
          'cantidad_total': donation['cantidad'] ?? 0,
          'cantidad_restante_total': donation['cantidad_restante'] ?? 0,
          'distribuciones': <Map<String, dynamic>>[],
          'has_distributions': false,
        };
      }

      // Si tiene paquete, es una distribución
      if (donation['nombre_paquete'] != null && donation['ubicacion'] != null) {
        grouped[donationId]!['has_distributions'] = true;

        // Verificar si ya existe esta distribución para evitar duplicados
        bool distributionExists =
            (grouped[donationId]!['distribuciones'] as List).any(
              (dist) =>
                  dist['nombre_paquete'] == donation['nombre_paquete'] &&
                  dist['ubicacion'] == donation['ubicacion'],
            );

        if (!distributionExists) {
          (grouped[donationId]!['distribuciones'] as List).add({
            'nombre_paquete': donation['nombre_paquete'],
            'ubicacion': donation['ubicacion'],
            'cantidad_restante': donation['cantidad_restante'] ?? 0,
          });
        }
      }
    }

    return grouped.values.toList();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void refresh() {
    loadDonations();
  }
}

// Provider principal
final donationsProvider =
    StateNotifierProvider<DonationsNotifier, DonationsState>((ref) {
      return DonationsNotifier();
    });

// Providers específicos para cada tipo de donación
final groupedDonationsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(donationsProvider).groupedDonations;
});

final moneyDonationsProvider = Provider<List<dynamic>>((ref) {
  return ref.watch(donationsProvider).moneyDonations;
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(donationsProvider).isLoading;
});

final errorProvider = Provider<String?>((ref) {
  return ref.watch(donationsProvider).error;
});

// Provider para el total de dinero donado
final totalMoneyDonatedProvider = Provider<double>((ref) {
  final moneyDonations = ref.watch(moneyDonationsProvider);
  return moneyDonations.fold(0.0, (sum, donation) {
    return sum + (donation['monto'] ?? 0.0);
  });
});

// Provider para estadísticas generales
final donationsStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final groupedDonations = ref.watch(groupedDonationsProvider);
  final moneyDonations = ref.watch(moneyDonationsProvider);
  final totalMoney = ref.watch(totalMoneyDonatedProvider);

  return {
    'totalInKind': groupedDonations.length,
    'totalMoney': moneyDonations.length,
    'totalAmount': totalMoney,
    'totalDonations': groupedDonations.length + moneyDonations.length,
  };
});
