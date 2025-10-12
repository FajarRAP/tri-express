part of 'scanner_cubit.dart';

class ScannerState extends Equatable {
  const ScannerState({
    this.isFromQRScanner = false,
    this.isFromUHFReader = false,
    required this.uhfResults,
  });

  factory ScannerState.initial() => const ScannerState(uhfResults: []);

  final bool isFromQRScanner;
  final bool isFromUHFReader;
  final List<UHFResultEntity> uhfResults;

  ScannerState copyWith({
    bool? isFromUHFReader,
    bool? isFromQRScanner,
    List<UHFResultEntity>? uhfResults,
  }) {
    return ScannerState(
      isFromQRScanner: isFromQRScanner ?? this.isFromQRScanner,
      isFromUHFReader: isFromUHFReader ?? this.isFromUHFReader,
      uhfResults: uhfResults ?? this.uhfResults,
    );
  }

  @override
  List<Object> get props => [isFromQRScanner, isFromUHFReader, uhfResults];
}
