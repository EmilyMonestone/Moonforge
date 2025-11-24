import 'package:flutter/material.dart';

class CombatLogWidget extends StatelessWidget {
  final List<String> log;

  const CombatLogWidget({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Combat Log',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: log.length,
            itemBuilder: (context, index) {
              final logIndex = log.length - 1 - index;
              return ListTile(
                dense: true,
                title: Text(
                  log[logIndex],
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
