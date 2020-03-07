import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pedidos_luna/src/auth/bloc.dart';
import 'package:pedidos_luna/src/models/order.dart';
import 'package:pedidos_luna/src/models/request.dart';
import 'package:pedidos_luna/src/order/bloc/bloc.dart';
import 'package:pedidos_luna/src/repositories/order_repository.dart';
import 'package:pedidos_luna/src/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final OrderBloc orderBloc = BlocProvider.of<OrderBloc>(context);
    orderBloc.add(LoadOrder());
    final OrderRepository orderRepository = orderBloc.getOrderRepository;
    orderRepository.getCustomer().listen((onData) {
      final e = CustomerRequest.fromSnapshot(onData);
      //print(e);
    });

//    final OrderRepository orderRepository =
//        Provider.of<OrderRepository>(context);

    return BlocBuilder<OrderBloc, OrderState>(
        builder: (BuildContext context, OrderState state) {
      if (state is Loading)
        return Center(
          child: LoadingWidget(),
        );
      else {
        return Scaffold(
          body: StreamBuilder<QuerySnapshot>(
              stream: orderRepository.getOrder(),
              builder: (context, AsyncSnapshot<QuerySnapshot> data) {
                if (data.hasData) {
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
      }
    });
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
            child: _renderRequestStatus(context, orderRepository.orderModel),
          ),
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
    //final bool smallScreen = size.height < 600;
    print(size.width);
    print(size.height);
    //final UserRepository _userRepository = Provider.of<UserRepository>(context);
    return Container(
      width: size.width,
      //color: Colors.red,
      padding: EdgeInsets.only(
        left: 50.0,
        right: 50.0,
        //top: size.height * 0.05,
      ),
      //height: size.height * (size.height < 600 ? 0.65 : 0.60),---------
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
              //Text(_userRepository.getDisplayName()),
              Container(
                //padding: EdgeInsets.only(top: size.height * 0.01),
                child: Text(
                  'PEDIDO #${orderModel.orderNumber}',
                  style: TextStyle(
                      color: orderModel.color,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w400),
                ),
              ),
              //Expanded(child: Container(),),
              Container(
                //padding: EdgeInsets.only(top: size.height * 0.01),
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
              //Expanded(child: Container()),
              Container(
                //margin: EdgeInsets.symmetric(horizontal: .0),
                //margin: EdgeInsets.only(top: size.height * 0.01),-----
                child: Text(
                  'Termina el:',
                  style: TextStyle(
                      fontSize: size.width < 400 ? 22 : 32,
                      fontWeight: FontWeight.w300,
                      color: orderModel.color),
                ),
              ),
              //SizedBox(height: size.height * 0.01,),
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

  Widget _renderRequestStatus(BuildContext context, OrderModel orderModel) {
    return Container(
      //color: Colors.red,
      padding: EdgeInsets.only(
        left: 50.0,
        right: 50.0,
        //top: size.height * 0.05,
      ),
      //height: size.height * (size.height < 600 ? 0.65 : 0.60),---------
      child: Card(
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: InkWell(
          splashColor: orderModel.color.withAlpha(100),
          onTap: () {
            Navigator.pushNamed(context, 'order_detail');
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
//                  Container(
//                    //padding: EdgeInsets.only(top: size.height * 0.02),
//                    child: Text(
//                      'Estatus de tu order',
//                      style: TextStyle(
//                          color: order.color,
//                          fontSize: 24.0,
//                          fontWeight: FontWeight.w600),
//                    ),
//                  ),
                  //Expanded(child: Container()),
                  Container(
                    //margin: EdgeInsets.only(top: 10.0),
                    //padding: EdgeInsets.only(top: size.height * 0.01),
                    child: Text(
                      'En validacion',
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  //SizedBox(height: 15.0,),
                ]),
          ),
        ),
      ),
    );
  }

  Widget _renderCardMessage(
      BuildContext context, Size size, OrderModel orderModel) {
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
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Cerrar Sesion"),
          content: new Text("Estas seguro de que quieres salir?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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
