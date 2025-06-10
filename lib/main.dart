import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_donaciones_1/features/app/presentation/donation_app_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: DonationsApp(),
    ),
  );
}
