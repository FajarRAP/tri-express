part of 'receipt_number_cubit.dart';

class ReceiptNumberState extends Equatable {
  const ReceiptNumberState({
    required this.batch,
    required this.goods,
  });

  ReceiptNumberState copyWith({
    BatchEntity? batch,
    List<GoodEntity>? goods,
  }) {
    return ReceiptNumberState(
      batch: batch ?? this.batch,
      goods: goods ?? this.goods,
    );
  }

  final BatchEntity batch;
  final List<GoodEntity> goods;

  @override
  List<Object?> get props => [batch, goods];
}
