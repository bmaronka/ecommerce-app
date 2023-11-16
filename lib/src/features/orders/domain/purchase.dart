import 'package:equatable/equatable.dart';

class Purchase extends Equatable {
  const Purchase({
    required this.orderId,
    required this.orderDate,
  });

  final String orderId;
  final DateTime orderDate;

  @override
  List<Object?> get props => [
        orderId,
        orderDate,
      ];
}
