import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../fonts/fonts.dart';
import '../themes/colors.dart';
import 'handle_bar.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  const ImagePickerBottomSheet({
    super.key,
    required this.onPicked,
  });

  final void Function(XFile pickedImage) onPicked;

  @override
  Widget build(BuildContext context) {
    final imagePicker = ImagePicker();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const HandleBar(),
          const SizedBox(height: 20),
          Text(
            'Pilih Gambar',
            style: paragraphMedium[bold].copyWith(color: black),
          ),
          const SizedBox(height: 20),
          ListTile(
            onTap: () async {
              final pickedImage = await imagePicker.pickImage(
                imageQuality: 60,
                source: ImageSource.camera,
              );

              if (pickedImage == null) return;
              if (!context.mounted) return;
              context.pop();
              onPicked(pickedImage);
            },
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: primary50,
              ),
              child: const Icon(
                Icons.camera_alt,
                color: primary,
              ),
            ),
            subtitle: const Text('Buat foto baru'),
            title: const Text('Ambil dari Kamera'),
          ),
          const Divider(),
          ListTile(
            onTap: () async {
              final pickedImage = await imagePicker.pickImage(
                imageQuality: 60,
                source: ImageSource.camera,
              );

              if (pickedImage == null) return;
              if (!context.mounted) return;
              context.pop();
              onPicked(pickedImage);
            },
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: success50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.photo_library,
                color: success,
              ),
            ),
            subtitle: const Text('Pilih foto yang sudah ada'),
            title: const Text('Pilih dari Galeri'),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: context.pop,
              style: TextButton.styleFrom(
                foregroundColor: danger,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Batal'),
            ),
          ),
        ],
      ),
    );
  }
}
