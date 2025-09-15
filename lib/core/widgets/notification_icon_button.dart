import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/router.dart';
import '../themes/colors.dart';

class NotificationIconButton extends StatelessWidget {
  const NotificationIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(notificationRoute),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: graySecondary),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(10),
        child: Icon(
          Icons.notifications_outlined,
          color: black,
        ),
      ),
    );

    // return GestureDetector(
    //   onTap: () => context.push(notificationRoute),
    //   child: Container(
    //     alignment: Alignment.center,
    //     padding: const EdgeInsets.all(10),
    //     decoration: BoxDecoration(
    //       shape: BoxShape.circle,
    //       color: Colors.white, // Warna dasar untuk container
    //       gradient: RadialGradient(
    //         colors: [
    //           Colors.white, // Warna di tengah (sesuaikan dengan warna dasar)
    //           Colors.grey.shade400, // Warna bayangan di tepi
    //         ],
    //         center: Alignment.center,
    //         stops: const [0.8, 1.0], // Mengatur ketebalan bayangan di tepi
    //       ),
    //     ),
    //     child: Icon(
    //       Icons.notifications_outlined,
    //       color: Colors.black, // Variabel 'black' dari kode Anda
    //     ),
    //   ),
    // );
  }
}
