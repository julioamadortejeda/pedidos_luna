import 'package:equatable/equatable.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class InitialOrderState extends OrderState {

}

class Loading extends OrderState {}

class Charged extends OrderState {}

class Error extends OrderState {}
