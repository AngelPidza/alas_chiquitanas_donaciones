import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/colors.dart';
import '../../domain/entities/donation.dart';

class DonationCard extends StatelessWidget {
  final Donation donation;
  final int index;
  final Function(String) onStatusUpdate;
  final VoidCallback onTap;

  const DonationCard({
    super.key,
    required this.donation,
    required this.index,
    required this.onStatusUpdate,
    required this.onTap,
  });

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'validado':
        return AppColors.successColor;
      case 'pendiente':
        return AppColors.accent;
      case 'rechazado':
        return AppColors.errorColor;
      default:
        return AppColors.lightBlue;
    }
  }

  IconData _getDonationIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'dinero':
        return Icons.attach_money_rounded;
      case 'especie':
        return Icons.inventory_2_rounded;
      default:
        return Icons.volunteer_activism_rounded;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            if (donation.type.trim() == 'especie') {
              onTap();
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getDonationIcon(donation.type),
                    color: AppColors.accent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Donación #${donation.id}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                donation.validationStatus,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _getStatusColor(
                                  donation.validationStatus,
                                ).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              donation.validationStatus.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: _getStatusColor(
                                  donation.validationStatus,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tipo: ${donation.type.toUpperCase()}',
                        style: const TextStyle(
                          color: AppColors.accentBlue,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Fecha: ${_formatDate(donation.donationDate)}',
                        style: const TextStyle(
                          color: AppColors.lightBlue,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Campaña: #${donation.campaignId ?? 'N/A'} • Donante: #${donation.donorId ?? 'N/A'}',
                        style: const TextStyle(
                          color: AppColors.lightBlue,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: onStatusUpdate,
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'pendiente',
                      child: Row(
                        children: [
                          Icon(
                            Icons.pending,
                            color: AppColors.accent,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text('Pendiente'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'validado',
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.successColor,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text('Validado'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'rechazado',
                      child: Row(
                        children: [
                          Icon(
                            Icons.cancel,
                            color: AppColors.errorColor,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text('Rechazado'),
                        ],
                      ),
                    ),
                  ],
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.more_vert,
                      color: AppColors.lightBlue,
                      size: 16,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
