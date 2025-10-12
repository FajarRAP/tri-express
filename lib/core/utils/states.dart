import 'package:equatable/equatable.dart';

import '../../features/inventory/domain/entities/batch_entity.dart';
import '../failure/failure.dart';

abstract class ReusableState<T> extends Equatable {
  const ReusableState();

  @override
  List<Object?> get props => [];
}

class Initial<T> extends ReusableState<T> {}

class Loading<T> extends ReusableState<T> {}

class Loaded<T> extends ReusableState<T> {
  const Loaded({
    required this.data,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isPaginating = false,
  });

  final T data;
  final int currentPage;
  final bool hasReachedMax;
  final bool isPaginating;

  Loaded<T> copyWith({
    T? data,
    int? currentPage,
    bool? hasReachedMax,
    bool? isPaginating,
  }) {
    return Loaded<T>(
      data: data ?? this.data,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isPaginating: isPaginating ?? this.isPaginating,
    );
  }

  @override
  List<Object?> get props => [data, currentPage, hasReachedMax, isPaginating];
}

class Empty<T> extends ReusableState<T> {}

class Error<T> extends ReusableState<T> {
  const Error(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

abstract class ActionState<T> extends ReusableState<T> {
  const ActionState();
}

class ActionInProgress<T> extends ActionState<T> {}

class ActionSuccess<T> extends ActionState<T> {
  const ActionSuccess(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ActionFailure<T> extends ActionState<T> {
  const ActionFailure(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

abstract interface class BatchSearchableState extends Equatable {
  List<BatchEntity> get allBatches;
  List<BatchEntity> get filteredBatches;

  BatchSearchableState copyWithFiltered({
    List<BatchEntity>? allBatches,
    required List<BatchEntity> filteredBatches,
  });
}
