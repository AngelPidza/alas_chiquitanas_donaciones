import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/donations_provider.dart';

class DonationsStatsWidget extends ConsumerWidget {
  const DonationsStatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(donationsStatsProvider);
    
    // Paleta de colores consistente
    const Color primaryDark = Color(0xFF0D1B2A);
    const Color primaryBlue = Color(0xFF1B263B);
    const Color lightBlue = Color(0xFF778DA9);
    const Color white = Color(0xFFFFFFFE);
    const Color accent = Color(0xFFFFB700);
    const Color successColor = Color(0xFF2A9D8F);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryDark, primaryBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryDark.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tu Impacto',
                      style: TextStyle(
                        color: white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Resumen de todas tus contribuciones',
                      style: TextStyle(color: lightBlue, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildStatContainer(
                  value: '${stats['totalInKind']}',
                  label: 'Donaciones\nen Especie',
                  icon: Icons.inventory_2_rounded,
                  color: accent,
                ),
              ),
              Container(
                height: 60,
                width: 1,
                color: white.withOpacity(0.2),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(
                child: _buildStatContainer(
                  value: '${stats['totalMoney']}',
                  label: 'Donaciones\nen Dinero',
                  icon: Icons.attach_money_rounded,
                  color: successColor,
                ),
              ),
              Container(
                height: 60,
                width: 1,
                color: white.withOpacity(0.2),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(
                child: _buildStatContainer(
                  value: '\$${stats['totalAmount'].toStringAsFixed(0)}',
                  label: 'Total\nDonado',
                  icon: Icons.volunteer_activism_rounded,
                  color: accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatContainer({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    const Color lightBlue = Color(0xFF778DA9);
    const Color white = Color(0xFFFFFFFE);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: lightBlue,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
} 