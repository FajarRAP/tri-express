part of 'receipt_number_cubit.dart';

class ReceiptNumberState extends Equatable {
  const ReceiptNumberState({
    required BatchEntity batch,
    required this.goods,
  }) : _batch = batch;

  ReceiptNumberState copyWith({
    BatchEntity? batch,
    List<GoodEntity>? goods,
  }) {
    return ReceiptNumberState(
      batch: batch ?? this._batch,
      goods: goods ?? this.goods,
    );
  }

  final BatchEntity _batch;
  final List<GoodEntity> goods;

  @override
  List<Object?> get props => [_batch, goods];
}
