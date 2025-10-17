import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../fonts/fonts.dart';
import '../themes/colors.dart';
import 'constants.dart';

class TopSnackbar {
  static late BuildContext _context;

  static void init(BuildContext context) => _context = context;

  static void dangerSnackbar({required String message}) =>
      _showSnackbar(message: message, color: danger);

  static void successSnackbar({required String message}) =>
      _showSnackbar(message: message, color: success);

  static void defaultSnackbar({required String message}) =>
      _showSnackbar(message: message, color: black);

  static void iconedSnackbar({required String message, required Widget icon}) =>
      _showIconedSnackbar(message: message, color: black, icon: icon);

  static void hasInternetSnackbar() => TopSnackbar.iconedSnackbar(
      message: 'Kamu sudah terhubung kembali',
      icon: SvgPicture.asset(connectionOnSvgPath,
          colorFilter: const ColorFilter.mode(success, BlendMode.srcIn),
          width: 24));

  static void noInternetSnackbar() => TopSnackbar.iconedSnackbar(
      message: 'Oops! Koneksi kamu terputus',
      icon: SvgPicture.asset(connectionOffSvgPath,
          colorFilter: const ColorFilter.mode(danger, BlendMode.srcIn),
          width: 24));

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
            .then(delay: 800.ms)
            .slideY(begin: 0, end: -3),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(2.seconds, overlayEntry.remove);
  }

  static void _showIconedSnackbar(
      {required String message, required Color color, required Widget icon}) {
    final overlay = Overlay.of(_context);

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.paddingOf(context).top + 32,
        left: 16,
        right: 16,
        child: _buildIconedSnackbar(color: color, text: message, icon: icon)
            .animate()
            .slideY(begin: -2, end: 0)
            .then()
            .slideY(begin: 0.15, end: 0, duration: 200.ms)
            .then()
            .slideY(begin: 0, end: 0.15, duration: 200.ms)
            .then(delay: 800.ms)
            .slideY(begin: 0, end: -3),
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
        constraints: const BoxConstraints(minHeight: 40),
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
          style: label[medium].copyWith(color: light),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  static Widget _buildIconedSnackbar(
      {required Color color, required String text, required Widget icon}) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints(minHeight: 40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: color,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 6,
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 4),
            Text(
              text,
              style: label[medium].copyWith(color: light),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
