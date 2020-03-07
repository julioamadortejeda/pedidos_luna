import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pedidos_luna/src/repositories/order_repository.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;

  OrderBloc({@required OrderRepository orderRepository})
  : assert(orderRepository != null),
  _orderRepository = orderRepository;


  @override
  OrderState get initialState => Loading();

  @override
  Stream<OrderState> mapEventToState(
    OrderEvent event,
  ) async* {
    if(event is LoadingOrder) {
      yield Loading();
    }

    if(event is LoadOrder) {
      //await Future.delayed(Duration(seconds: 2));
      _orderRepository.getOrder();
      yield Charged();
    }

    if(event is ChargedOrder) {
      yield Charged();
    }
  }

  OrderRepository get getOrderRepository => _orderRepository;
}
