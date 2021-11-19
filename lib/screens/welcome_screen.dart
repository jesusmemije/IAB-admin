import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _crearAppBar(context),
      body: infoWelcome(),
    );
  }

  PreferredSize _crearAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark
        ),
        centerTitle: true,
        title: Column(
          children: const [
            Text('IAB Admin',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
          ],
        ),
        elevation: 2.0,
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget infoWelcome() {
    return Container(
        margin: const EdgeInsets.only(top: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Text(
                  "Invitación a boda.com",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 6.0),
                const Text(
                  "COMPARTIMOS TUS EMOCIONES",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontStyle: FontStyle.italic
                  ),
                ),
                const SizedBox(height: 24.0),
                Card(
                  child: Image.asset(
                    'assets/img/welcome.png',
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
