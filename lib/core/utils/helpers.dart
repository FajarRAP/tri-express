import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../themes/colors.dart';

class UHFResponse {
  const UHFResponse({
    required this.message,
    required this.statusCode,
  });

  final String message;
  final int statusCode;

  factory UHFResponse.fromJson(Map<String, dynamic> json) =>
      UHFResponse(message: json['message'], statusCode: json['status_code']);
}

class TopSnackbar {
  static late BuildContext _context;

  static void init(BuildContext context) => _context = context;

  static void dangerSnackbar({required String message}) =>
      _showSnackbar(message: message, color: danger);

  static void successSnackbar({required String message}) =>
      _showSnackbar(message: message, color: success);

  static void defaultSnackbar({required String message}) =>
      _showSnackbar(message: message, color: black);

  static void _showSnackbar({required String message, required Color color}) {
    final overlay = Overlay.of(_context);

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.paddingOf(context).top + 32,
        left: 16,
        right: 16,
        child: _buildSnackbar(color: color, text: message)
            .animate()
            .slideY(begin: -2, end: 0)
            .then()
            .slideY(begin: 0.15, end: 0, duration: 200.ms)
            .then()
            .slideY(begin: 0, end: 0.15, duration: 200.ms)
            .then(delay: 1.seconds)
            .slideY(begin: 0, end: -2),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(2.seconds, overlayEntry.remove);
  }

  static Widget _buildSnackbar({required Color color, required String text}) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(minHeight: 40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: color,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 6,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: light,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
