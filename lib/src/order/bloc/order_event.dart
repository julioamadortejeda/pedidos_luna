import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoadingOrder extends OrderEvent {}

class ChargedOrder extends OrderEvent {}

class LoadOrder extends OrderEvent {}


