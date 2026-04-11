import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:verify/app/shared/extensions/date_time.dart';

class PixTransactionTileWidget extends StatelessWidget {
  final String clientName;
  final double value;
  final DateTime date;
  const PixTransactionTileWidget({
    super.key,
    required this.clientName,
    required this.value,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (value >= 0 ? Colors.green : Colors.red).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              value >= 0 ? Icons.add_rounded : Icons.remove_rounded,
              color: value >= 0 ? Colors.green : Colors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clientName.toUpperCase(),
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _formattedDateTime(),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _brazilianValue(),
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: value >= 0 ? Colors.green[700] : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  String _brazilianValue() {
    final prefix = value >= 0 ? '+ ' : '';
    final brazilianValue = UtilBrasilFields.obterReal(value.abs());
    return '$prefix$brazilianValue';
  }

  String _formattedDateTime() {
    final dateTime = date.toBrazilianTimeZone();
    final formattedDate = DateFormat('HH:mm').format(dateTime);
    return formattedDate;
  }
}
