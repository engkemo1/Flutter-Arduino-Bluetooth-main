// ignore_for_file: file_names
import 'dart:convert';
import 'dart:typed_data';
import 'package:control_button/control_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:layout/components/ButtonDouble.dart';
import 'package:layout/components/ButtonSingle.dart';

import 'components/VoiceButtonPage.dart';

class ControlePrincipalPage extends StatefulWidget {
  final BluetoothDevice? server;
  const ControlePrincipalPage({this.server});

  @override
  _ControlePrincipalPage createState() => _ControlePrincipalPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ControlePrincipalPage extends State<ControlePrincipalPage> {
  static const clientID = 0;
  BluetoothConnection? connection;
  String? language;

  // ignore: deprecated_member_use
  List<_Message> messages = <_Message>[];
  String _messageBuffer = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  bool isConnecting = true;
  bool get isConnected => connection != null && connection!.isConnected;

  bool isDisconnecting = false;
  bool buttonClicado = false;

  List<String> _languages = ['en_US', 'es_ES', 'pt_BR'];

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server!.address).then((_connection) {
      print('Connected to device');
      connection = _connection;
      setState(() {

        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnected localy!');
        } else {
          print('Disconnected remote!');
        }
        if (mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Failed to connect, something is wrong!');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection!.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(_message.text.trim()),
                style: const TextStyle(color: Colors.white)),
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color:
                    _message.whom == clientID ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const SizedBox(height: 50),

                ControlButton(
                  sectionOffset: FixedAngles.Inclined45,
                  externalDiameter: 300.0,
                  internalDiameter: 120.0,
                  dividerColor: Colors.white,
                  elevation: 2,
                  externalColor: Colors.grey,
                  internalColor: Colors.grey[300],

                  sections: [
                        () => _sendMessage('F'),
                        () => _sendMessage('L'),
                        () => _sendMessage('B'),
                        () => _sendMessage('R'),

                  ],
                ),
                const SizedBox(height: 50),

                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(children: [
                          ButtonSingleComponent(
                            buttonName: "A",
                            comandOn: 'A',
                            colorButton: Color.fromRGBO(238, 57, 61, 1),
                            clientID: clientID,
                            connection: connection,
                          ),
                        ]),
                        const SizedBox(width: 10),
                        Column(children: [
                          ButtonSingleComponent(
                            buttonName: "B",
                            comandOn: 'B',
                            colorButton: Color.fromRGBO(8, 164, 113, 1),
                            clientID: clientID,
                            connection: connection,
                          ),
                        ]),
                        const SizedBox(width: 10),
                        Column(children: [
                          ButtonSingleComponent(
                            buttonName: "C",
                            comandOn: 'C',
                            colorButton: Color.fromRGBO(239, 206, 45, 1),
                            clientID: clientID,
                            connection: connection,
                          ),
                        ]),
                        const SizedBox(width: 10),
                        Column(children: [
                          ButtonSingleComponent(
                            buttonName: "D",
                            comandOn: 'D',
                            colorButton: Color.fromRGBO(49, 86, 188, 1),
                            clientID: clientID,
                            connection: connection,
                          ),


                        ]),
                        const SizedBox(width: 10),

                        ButtonSingleComponent(
                          buttonName: "E",
                          comandOn: 'E',
                          colorButton: Colors.deepPurple,
                          clientID: clientID,
                          connection: connection,
                        ),

                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    for (var byte in data) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    }
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }
  void _sendMessage(String text) async {
    text = text.trim();

      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }

  }
}
