import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class InfoBox extends StatelessWidget {
  const InfoBox(this._info, {super.key});

  final String _info;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Html(
        data: _info,
        style: {
          'body': Style(
            color: theme.colorScheme.onSecondaryContainer,
            fontSize: FontSize(theme.textTheme.bodyLarge!.fontSize!),
          ),
        },
      ),
    );
  }
}
