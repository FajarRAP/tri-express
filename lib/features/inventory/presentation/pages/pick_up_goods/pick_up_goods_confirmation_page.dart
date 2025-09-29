import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/fonts/fonts.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../core/utils/top_snackbar.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/image_picker_bottom_sheet.dart';
import '../../cubit/inventory_cubit.dart';

class PickUpGoodsConfirmationPage extends StatelessWidget {
  const PickUpGoodsConfirmationPage({
    super.key,
    required this.selectedCodes,
  });

  final Map<String, Set<String>> selectedCodes;

  @override
  Widget build(BuildContext context) {
    return _Tari(selectedCodes);
    return _Claude(selectedCodes: selectedCodes);
    return _Gemini(selectedCodes: selectedCodes);
  }
}

class _Tari extends StatefulWidget {
  const _Tari(this.selectedCodes);

  final Map<String, Set<String>> selectedCodes;

  @override
  State<_Tari> createState() => _TariState();
}

class _TariState extends State<_Tari> {
  late final InventoryCubit _inventoryCubit;
  late final TextEditingController _noteController;
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _inventoryCubit = context.read<InventoryCubit>();
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
        child: SingleChildScrollView(
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
                  clipBehavior: Clip.antiAlias,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: graySecondary),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 300,
                  width: double.infinity,
                  child: _pickedImage == null
                      ? const Icon(Icons.add, color: gray)
                      : Image.file(
                          File(_pickedImage!.path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  hintText: 'Tambahkan catatan di sini',
                  labelText: 'Catatan',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'DD MM YYYY',
                  labelText: 'Tanggal Terima',
                  suffixIcon: const Icon(Icons.calendar_month),
                ),
                initialValue: DateTime.now().toDDMMMMYYYY,
                readOnly: true,
              ),
              const SizedBox(height: 12),
              BlocConsumer<InventoryCubit, InventoryState>(
                buildWhen: (previous, current) => current is CreateShipments,
                listenWhen: (previous, current) => current is CreateShipments,
                listener: (context, state) {
                  if (state is CreateShipmentsLoaded) {
                    TopSnackbar.successSnackbar(message: state.message);
                    context
                      ..go(menuRoute)
                      ..push(pickUpGoodsRoute);
                  }

                  if (state is CreateShipmentsError) {
                    TopSnackbar.dangerSnackbar(message: state.message);
                  }
                },
                builder: (context, state) {
                  final onPressed = switch (state) {
                    CreateShipmentsLoading() => null,
                    _ => () {
                        if (_pickedImage == null) {
                          return TopSnackbar.dangerSnackbar(
                              message: 'Bukti foto diperlukan');
                        }

                        _inventoryCubit.createPickedUpGoods(
                            selectedCodes: widget.selectedCodes,
                            note: _noteController.text,
                            pickedImagePath: _pickedImage!.path);
                      },
                  };

                  return PrimaryButton(
                    onPressed: onPressed,
                    child: const Text('Simpan'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Gemini extends StatefulWidget {
  const _Gemini({
    required this.selectedCodes,
  });

  final Map<String, Set<String>> selectedCodes;

  @override
  State<_Gemini> createState() => _GeminiState();
}

class _GeminiState extends State<_Gemini> {
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
    final entries = widget.selectedCodes.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Penerimaan Barang'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // ======================================================
              // BAGIAN 1: INFORMASI BARANG YANG DITERIMA
              // ======================================================
              Text(
                'Barang yang Diterima',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              // Gunakan ListView.separated untuk daftar dengan pemisah
              ListView.separated(
                shrinkWrap: true, // Wajib di dalam SingleChildScrollView
                physics: const NeverScrollableScrollPhysics(), // Non-scrollable
                itemCount: entries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final receipt = entries[index];

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tampilkan Nomor Resi
                          Text(
                            receipt.key,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Divider(height: 20),
                          // Tampilkan daftar kode unik menggunakan Chip
                          Wrap(
                            spacing: 8.0, // Jarak horizontal antar chip
                            runSpacing: 4.0, // Jarak vertikal antar baris chip
                            children: receipt.value
                                .map((code) => Chip(
                                    label: Text(code),
                                    backgroundColor: primary50,
                                    labelStyle:
                                        const TextStyle(color: primary800)))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // ======================================================
              // BAGIAN 2: BUKTI PENERIMAAN
              // ======================================================
              Text(
                'Bukti Penerimaan',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              // --- UPLOAD FOTO ---
              Text('Bukti Foto',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
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
                child: _pickedImage == null
                    ? Container(
                        // Desain ulang area upload
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey.shade400,
                                style: BorderStyle.solid)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined,
                                color: Colors.grey.shade600, size: 40),
                            const SizedBox(height: 8),
                            Text('Ketuk untuk mengambil foto',
                                style: TextStyle(color: Colors.grey.shade600)),
                          ],
                        ),
                      )
                    : ClipRRect(
                        // Tampilkan gambar yang dipilih
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_pickedImage!.path),
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(height: 16),

              // --- CATATAN ---
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Catatan (Opsional)',
                  hintText: 'Tambahkan catatan jika ada...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // --- TANGGAL TERIMA (INTERAKTIF) ---
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tanggal Terima',
                  suffixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(),
                ),
                readOnly: true, // Keyboard tidak akan muncul
                initialValue: DateTime.now().toDDMMMMYYYY,
              ),
              const SizedBox(height: 32),

              // ======================================================
              // BAGIAN 3: TOMBOL AKSI
              // ======================================================
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  // Logika untuk menyimpan:
                  // 1. Validasi apakah foto sudah diupload.
                  // 2. Kumpulkan semua data: _pickedImage, _noteController.text, _selectedDate
                  // 3. Kirim data ke BLoC/Cubit/Provider untuk diproses.
                },
                child: const Text('Simpan Bukti Penerimaan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Claude extends StatefulWidget {
  const _Claude({required this.selectedCodes});

  final Map<String, Set<String>> selectedCodes;

  @override
  State<_Claude> createState() => _ClaudeState();
}

class _ClaudeState extends State<_Claude> {
  late final TextEditingController _noteController;
  late final TextEditingController _receiverNameController;
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    _receiverNameController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _receiverNameController.dispose();
    super.dispose();
  }

  // void _toggleKodeUnik(String nomorResi, String kodeUnik) {
  //   setState(() {
  //     if (selectedKodeUnik[nomorResi]!.contains(kodeUnik)) {
  //       selectedKodeUnik[nomorResi]!.remove(kodeUnik);
  //     } else {
  //       selectedKodeUnik[nomorResi]!.add(kodeUnik);
  //     }
  //   });
  // }

  int get totalSelectedItems {
    return widget.selectedCodes.values
        .map((list) => list.length)
        .fold(0, (sum, count) => sum + count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Penerimaan Barang'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$totalSelectedItems item',
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Summary Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.green[700],
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Resi Dipilih',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${widget.selectedCodes.length} Resi',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Item Dipilih',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '$totalSelectedItems Item',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Resi Selection Section
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.assignment_outlined,
                                color: Colors.blue[700]),
                            const SizedBox(width: 8),
                            const Text(
                              'Pilih Item per Resi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...widget.selectedCodes.entries
                            .map((resi) => _buildResiCard(resi)),
                      ],
                    ),
                  ),

                  // Receiver Information Section
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person_outline, color: Colors.blue[700]),
                            const SizedBox(width: 8),
                            const Text(
                              'Informasi Penerima',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _receiverNameController,
                          decoration: InputDecoration(
                            labelText: 'Nama Penerima',
                            hintText: 'Masukkan nama penerima',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[50],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Colors.blue),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tanggal Terima',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    DateTime.now().toDDMMMMYYYY,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Photo Evidence Section
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.camera_alt_outlined,
                                color: Colors.blue[700]),
                            const SizedBox(width: 8),
                            const Text(
                              'Bukti Foto Penerimaan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              ' *',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Upload foto bukti penerimaan barang',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
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
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _pickedImage == null
                                    ? Colors.grey[300]!
                                    : Colors.green[300]!,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: _pickedImage == null
                                  ? Colors.grey[50]
                                  : Colors.white,
                            ),
                            child: _pickedImage == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[100],
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Icon(
                                          Icons.add_a_photo,
                                          size: 32,
                                          color: Colors.blue[700],
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Tap untuk upload foto',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'JPG, PNG max 5MB',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Stack(
                                      children: [
                                        Image.file(
                                          File(_pickedImage!.path),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Notes Section
                  Container(
                    margin: const EdgeInsets.only(bottom: 100),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.note_outlined, color: Colors.blue[700]),
                            const SizedBox(width: 8),
                            const Text(
                              'Catatan Tambahan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _noteController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText:
                                'Tambahkan catatan mengenai kondisi barang, lokasi penerimaan, atau informasi lainnya...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Fixed Bottom Button
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Validation Info
              if (totalSelectedItems == 0 || _pickedImage == null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.orange[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          totalSelectedItems == 0
                              ? 'Pilih minimal 1 item untuk dilanjutkan'
                              : 'Upload bukti foto diperlukan',
                          style: TextStyle(
                            color: Colors.orange[700],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (totalSelectedItems > 0 && _pickedImage != null)
                      ? () {
                          // Implement save functionality
                          context
                            ..go(menuRoute)
                            ..push(pickUpGoodsRoute);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Simpan Penerimaan ($totalSelectedItems Item)',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResiCard(MapEntry<String, Set<String>> selectedCode) {
    final isExpanded =
        widget.selectedCodes[selectedCode.key]?.isNotEmpty ?? false;
    final selectedCount = widget.selectedCodes[selectedCode.key]?.length ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isExpanded ? Colors.blue[300]! : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Resi Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isExpanded ? Colors.blue[50] : Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    selectedCode.key,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   resi.namaPenerima ?? 'Penerima tidak diketahui',
                      //   style: const TextStyle(
                      //     fontWeight: FontWeight.w500,
                      //     fontSize: 14,
                      //   ),
                      // ),
                      Text(
                        '${selectedCode.value.length} item tersedia',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: selectedCount > 0
                        ? Colors.green[100]
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$selectedCount dipilih',
                    style: TextStyle(
                      color: selectedCount > 0
                          ? Colors.green[700]
                          : Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Kode Unik List
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih item yang diterima:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedCode.value.map((kode) {
                    final isSelected = widget.selectedCodes[selectedCode.key]
                            ?.contains(kode) ??
                        false;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue[700] : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? Colors.blue[700]!
                              : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected) ...[
                            const Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            kode,
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white : Colors.grey[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
