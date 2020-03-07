import 'package:flutter/material.dart';
import 'package:pedidos_luna/src/models/message.dart';
import 'package:pedidos_luna/src/models/messages.dart';

class MessagesPage extends StatelessWidget {
  final List<Message> messages = Messages.messages;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 246, 246, 1.0),
      body: CustomScrollView(
        // Add the app bar and list of items as slivers in the next steps.
          slivers: <Widget>[
            _renderAppbar(size),
            SliverPadding(
              padding: EdgeInsets.only(top: size.height * 0.02),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                // The builder function returns a ListTile with a title that
                // displays the index of the current item.
                    (context, index) => _renderCardItem(index),
                // Builds 1000 ListTiles
                childCount: messages.length,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: size.height * 0.02),
            ),
          ]),
    );
  }

  Widget _renderLeading(int index) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image(
          height: 40.0,
          width: 40.0,
          image: AssetImage(messages[index].imageType),
        ));
  }

  Widget _renderAppbar(Size size) {
    return SliverAppBar(
      elevation: 5.0,
      backgroundColor: Colors.pink,
      expandedHeight: size.height * 0.15,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          'Mensajes',
          style: TextStyle(
              color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _renderCardItem(int index) {
    return Container(
      //color: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        margin: EdgeInsets.only(bottom: 10.0),
        child: Card(
            color: Colors.white,
            //elevation: 3.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: _renderLeading(index),
                    title: Text(
                      messages[index].title,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    contentPadding: EdgeInsets.only(bottom: 15.0, top: 5.0),
                    subtitle: Text(
                      messages[index].message,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ],
              ),
            )));
  }
// Widget _crearLista(BuildContext context) {
//   return ListView.separated(
//     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//     itemCount: messages.length,
//     itemBuilder: (BuildContext context, int index) {
//       return Material(
//         color: Colors.transparent,
//         child: ListTile(
//           title: Text('Entry ${messages[index].title}'),
//           subtitle: Text(messages[index].subTitle),
//           trailing:
//               Icon(Icons.keyboard_arrow_right, color: messages[index].color),
//           leading: ClipRRect(
//               borderRadius: BorderRadius.circular(10.0),
//               child: Image(
//                 height: 40.0,
//                 width: 40.0,
//                 image: AssetImage(messages[index].imageType),
//               )),
//           onTap: () {
//             print(messages[index].message);
//           },
//         ),
//       );
//     },
//     separatorBuilder: (BuildContext context, int index) => Divider(
//       color: Colors.transparent,
//       height: 0.0,
//     ),
//   );
// }
}
