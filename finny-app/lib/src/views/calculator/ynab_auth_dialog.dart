import 'package:flutter/material.dart';
import 'package:finny/src/providers/ynab_provider.dart';

class YnabAuthDialog extends StatelessWidget {
  final YNABProvider ynabService;

  const YnabAuthDialog({
    super.key,
    required this.ynabService,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('True Expense'),
      content: const Text(
        'To use your true annual expense data from YNAB, authorize Finny to access your YNAB account.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await ynabService.authorize();
            if (context.mounted) {
              Navigator.of(context).pop(true);
            }
          },
          child: const Text('Authorize YNAB'),
        ),
      ],
    );
  }
}
