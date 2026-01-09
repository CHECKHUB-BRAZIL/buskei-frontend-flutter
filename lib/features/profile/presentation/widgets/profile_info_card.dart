import 'package:buskei/features/profile/presentation/widgets/info_row.dart' show InfoRow;
import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  final DateTime? createdAt;
  final bool isActive;

  const ProfileInfoCard({
    super.key,
    this.createdAt,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            InfoRow(
              label: 'Status',
              value: isActive ? 'Ativo' : 'Inativo',
              valueColor: isActive ? Colors.green : Colors.red,
            ),
            const Divider(height: 32),
            InfoRow(
              label: 'Criado em',
              value: createdAt != null
                  ? '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}'
                  : '-',
            ),
          ],
        ),
      ),
    );
  }
}
