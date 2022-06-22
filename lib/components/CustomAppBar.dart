import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:layout/HomePage.dart';
import 'package:layout/provider/StatusConexaoProvider.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? Title;
  final bool? isBluetooth;
  final bool? isDiscovering;
  final Function? onPress;

  const CustomAppBar({
    Key? key,
    @required this.Title,
    this.isBluetooth,
    this.isDiscovering,
    this.onPress,
  }) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    DisconnectarBluetooth() {
      Provider.of<StatusConexaoProvider>(context, listen: false)
          .setDevice(null);
    }

    return AppBar(
      elevation: 0,
leading: Padding(padding: EdgeInsets.only(left: 10),child: Image.asset('images/logo.jpeg'),),
      title: new Center(
          child: Row(
        children: [
          new Text(Title!, textAlign: TextAlign.center,style: TextStyle(color: Colors.black),),
        ],
      )),
      backgroundColor: Colors.white,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            height: 50,
            width: 50,
            child: Consumer<StatusConexaoProvider>(
                builder: (context, StatusConnectionProvider, widget) {
              return (isBluetooth!
                  ? ElevatedButton(
                      onPressed: StatusConnectionProvider.device != null
                          ? () {
                              Provider.of<StatusConexaoProvider>(context,
                                      listen: false)
                                  .setDevice(null);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      settings: const RouteSettings(name: '/'),
                                      builder: (context) =>
                                          const HomePage())); // push it back in
                            }
                          : onPress!(),
                      child: Icon(StatusConnectionProvider.device != null
                          ? Icons.bluetooth_connected
                          : Icons.bluetooth_disabled,color: Colors.blue,),
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          primary: StatusConnectionProvider.device != null
                              ? Colors.white
                              : Colors.white),
                    )
                  : SizedBox.shrink());
            }),
          ),
        )
      ],
    );
  }
}
