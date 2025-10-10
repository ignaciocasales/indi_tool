import 'package:flutter/material.dart';
import 'package:indi_tool/consts.dart';

AppBar indiAppBar({required BuildContext context}) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    elevation: 0,
    centerTitle: false,
    title: Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(6),
          child: Icon(
            Icons.bolt,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            kAppName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
