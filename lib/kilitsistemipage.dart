import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:kilitsistemi/bluetoothManager.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';

class KilitKontrolPage extends StatefulWidget {
  const KilitKontrolPage({Key? key}) : super(key: key);

  @override
  _KilitKontrolPageState createState() => _KilitKontrolPageState();
}

class _KilitKontrolPageState extends State<KilitKontrolPage> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool isConnected = false;
  bool isLocked = true;
  final bluetoothManager = BluetoothManager();

  void _connectToBluetoothDevice() async {
    List<BluetoothDevice> devices = await bluetoothManager.getBondedDevices();
    try {
      BluetoothDevice hc06 =
          devices.firstWhere((device) => device.name == 'HC-06');
      await bluetoothManager.connectToDevice(hc06);
      setState(() {
        isConnected = true;
      });
    } catch (e) {
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hata'),
          content: Text('HC-06 cihazı bulunamadı.'),
          actions: [
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void kilidiAc() {
    bluetoothManager.sendData("KilidiAc");
    setState(() {
      isLocked = false;
    });
  }

  void kilitle() {
    bluetoothManager.sendData("Kilitle");
    setState(() {
      isLocked = true;
    });
  }

  Future<void> authenticate({required bool unlock}) async {
    bool authenticated = false;
    if (unlock) {
      try {
        authenticated = await _localAuth.authenticate(
          localizedReason: 'Kilidi açmak için parmak izinizi okutunuz!',
        );
      } catch (e) {
        print(e);
      }
      if (authenticated) {
        kilidiAc();
      }
    } else {
      kilitle();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Lottie.asset(isLocked
              ? 'assets/animations/kilitlendianimasyonu.json'
              : 'assets/animations/kilitacildianimasyonu.json'),
          ElevatedButton(
            onPressed: () => authenticate(unlock: isLocked),
            child: Text(isLocked ? 'Kilidi Aç' : 'Kilitle'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                isLocked ? Color.fromARGB(255, 7, 189, 68) : Colors.red,
              ),
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              elevation: MaterialStateProperty.all(5),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: isConnected ? null : _connectToBluetoothDevice,
            child: Text('Bağlan'),
          ),
        ],
      ),
    );
  }
}
