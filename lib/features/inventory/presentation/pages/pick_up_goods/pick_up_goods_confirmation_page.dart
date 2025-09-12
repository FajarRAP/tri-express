import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/fonts/fonts.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/image_picker_bottom_sheet.dart';

class PickUpGoodsConfirmationPage extends StatefulWidget {
  const PickUpGoodsConfirmationPage({super.key});

  @override
  State<PickUpGoodsConfirmationPage> createState() =>
      _PickUpGoodsConfirmationPageState();
}

class _PickUpGoodsConfirmationPageState
    extends State<PickUpGoodsConfirmationPage> {
  late final TextEditingController _noteController;
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penerima Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Bukti Foto',
              style: label[medium].copyWith(color: black),
            ),
            const SizedBox(height: 12),
            Text(
              'Upload Bukti Foto Di Sini',
              style: label[regular].copyWith(color: gray),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                builder: (context) => ImagePickerBottomSheet(
                  onPicked: (pickedImage) =>
                      setState(() => _pickedImage = pickedImage),
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: graySecondary),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 300,
                width: double.infinity,
                child: _pickedImage == null
                    ? const Icon(Icons.add, color: gray)
                    : Image.file(File(_pickedImage!.path)),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Tambahkan catatan di sini',
                labelText: 'Catatan',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'DD MM YYYY',
                labelText: 'Tanggal Terima',
                suffixIcon: const Icon(Icons.calendar_month),
              ),
              initialValue: DateTime.now().toDDMMMMYYYY,
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              onPressed: () => context
                ..go(menuRoute)
                ..push(pickUpGoodsRoute),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
