import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

//custom imports
import 'package:pedidos_luna/src/auth/bloc.dart';
import 'package:pedidos_luna/src/models/order.dart';
import 'package:pedidos_luna/src/order/bloc/bloc.dart';
import 'package:pedidos_luna/src/pages/customer/order_not_available.dart';
import 'package:pedidos_luna/src/repositories/order_repository.dart';
import 'package:pedidos_luna/src/pages/loading_page.dart';
import 'package:pedidos_luna/src/widgets/request_status_card_widget.dart';

class CustomerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final OrderBloc orderBloc = BlocProvider.of<OrderBloc>(context);
    //final UserRepository userRepository = Provider.of<UserRepository>(context);

    //orderBloc.add(LoadOrder());

    final OrderRepository orderRepository = orderBloc.getOrderRepository;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: orderRepository.getOrder(),
          builder: (context, AsyncSnapshot<QuerySnapshot> data) {
            if (data.hasData) {
              if(data.data.documents.length == 0) {
                return OrderNotAvailablePage();
              }

              orderRepository.mapToUserModel(data.data);

              return Stack(children: <Widget>[
                _renderBackground(orderRepository),
                _renderCards(context, orderRepository),
              ]);
            }

            return Center(
              child: LoadingWidget(),
            );
          }),
    );

//    return BlocBuilder<OrderBloc, OrderState>(
//        builder: (BuildContext context, OrderState state) {
//      if (state is Loading)
//        return LoadingWidget();
//      else {
//        return Scaffold(
//          body: StreamBuilder<QuerySnapshot>(
//              stream: orderRepository.getOrder(),
//              builder: (context, AsyncSnapshot<QuerySnapshot> data) {
//                if (data.hasData) {
//                  orderRepository.mapToUserModel(data.data);
//
//                  return Stack(children: <Widget>[
//                    _renderBackground(orderRepository),
//                    _renderCards(context, orderRepository),
//                  ]);
//                }
//
//                return Center(
//                  child: LoadingWidget(),
//                );
//              }),
//        );
//      }
//    });
  }

  Widget _renderBackground(OrderRepository orderRepository) {
    return Positioned.fill(
        child: Container(
      decoration:
          BoxDecoration(gradient: orderRepository.orderModel.background),
    ));
  }

  Widget _renderCards(BuildContext context, OrderRepository orderRepository) {
    final size = MediaQuery.of(context).size;
    final bool smallScreen = size.height < 600;

    return Column(
      children: <Widget>[
        Expanded(
          flex: smallScreen ? 2 : 2,
          child: _renderAppName(context, size),
        ),
        Expanded(
          flex: smallScreen ? 10 : 8,
          child: Padding(
            padding: EdgeInsets.only(top: (smallScreen ? 0 : 15.0)),
            child: _renderOrderCard(context, size, orderRepository.orderModel),
          ),
        ),
        Expanded(
          flex: smallScreen ? 2 : 3,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: smallScreen ? 5.0 : 50.0),
              child: _renderRequestStatus(orderRepository)),
        ),
        Expanded(
          flex: smallScreen ? 1 : 1,
          child: _renderCardMessage(context, size, orderRepository.orderModel),
        )
      ],
    );
  }

  Widget _renderAppName(BuildContext context, Size size) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Spacer(),
          Expanded(
            child: Container(),
          ),
          Container(
            //color: Colors.yellow,
            margin: EdgeInsets.only(top: size.height * 0.02),
            child: Text(
              'PEDIDOS SHEIN',
              style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Spacer(),
          IconButton(
            padding: EdgeInsets.only(top: 15.0),
            onPressed: () {
              _showDialog(context);
            },
            icon: Icon(Icons.exit_to_app),
            iconSize: 30.0,
            color: Colors.white,
            tooltip: 'Salir',
          )
        ],
      ),
    );
  }

  Widget _renderOrderCard(BuildContext context, Size size, OrderModel orderModel) {
//    print(size.width);
//    print(size.height);

    return Container(
      width: size.width,
      padding: EdgeInsets.only(
        left: 50.0,
        right: 50.0,
      ),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 20),
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 25.0,
              ),
              Container(
                child: Text(
                  'PEDIDO #${orderModel.orderNumber}',
                  style: TextStyle(
                      color: orderModel.color,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                child: Text(
                  orderModel.status,
                  style: TextStyle(
                      color: orderModel.color,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: FadeInImage(
                  width: size.width * (size.width > 400 ? 0.5 : 0.4),
                  image: AssetImage(orderModel.image),
                  placeholder: AssetImage('assets/images/loader.gif'),
                  fadeInDuration: Duration(milliseconds: 100),
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Container(
                child: Text(
                  'Termina el:',
                  style: TextStyle(
                      fontSize: size.width < 400 ? 22 : 32,
                      fontWeight: FontWeight.w300,
                      color: orderModel.color),
                ),
              ),
              Text(
                DateFormat('dd/MMM/yyyy - hh:mm a').format(orderModel.endDate),
                style: TextStyle(
                    fontSize: size.width < 400 ? 22 : 32,
                    fontWeight: FontWeight.bold,
                    color: orderModel.color.withAlpha(200)),
              ),
              SizedBox(
                height: 10.0,
              ) //
            ]),
      ),
    );
  }

  Widget _renderRequestStatus(OrderRepository orderRepository) {
    return RequestStatusCard(orderRepository: orderRepository);
  }

  Widget _renderCardMessage(BuildContext context, Size size, OrderModel orderModel) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
          color: Colors.white),
      //height: size.height * 0.1,------
      child: Material(
        color: Colors.transparent,
        borderOnForeground: false,
        child: InkWell(
          splashColor: orderModel.color.withAlpha(100),
          onTap: () {
            Navigator.pushNamed(context, 'messages');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  'Mensajes',
                  style: TextStyle(
                      fontSize: 30.0,
                      color: orderModel.color,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 8.0, left: 5.0),
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    '5',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Cerrar Sesion"),
          content: new Text("Estas seguro de que quieres salir?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(
                  LoggedOut(),
                );
                Navigator.of(context).pop();
              },
              child: Text('Si'),
            )
          ],
        );
      },
    );
  }
}
