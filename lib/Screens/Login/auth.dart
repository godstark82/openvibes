import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:openvibes2/Helpers/backup_restore.dart';
import 'package:openvibes2/Helpers/config.dart';
import 'package:uuid/uuid.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController controller = TextEditingController();
  Uuid uuid = const Uuid();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future _addUserData(String name) async {
    await Hive.box('settings').put('name', name.trim());

    final String userId = uuid.v1();
    await Hive.box('settings').put('userId', userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        await restore(context);
                        GetIt.I<MyTheme>().refresh();
                        Navigator.popAndPushNamed(context, '/');
                      },
                      child: Text(
                        'Restore',
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.7),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _addUserData(
                          'Guest',
                        );
                        Navigator.popAndPushNamed(context, '/pref');
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            'Welcome to',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 5),
                          DefaultTextStyle(
                            style: TextStyle(
                              shadows: <Shadow>[
                                Shadow(
                                    blurRadius: 20.0,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.5)),
                                Shadow(
                                    blurRadius: 20.0,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.5)),
                              ],
                              height: 0.97,
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            child: AnimatedTextKit(
                              totalRepeatCount: 10,
                              animatedTexts: [
                                ColorizeAnimatedText('OpenVibes',
                                    textStyle: TextStyle(
                                      shadows: <Shadow>[
                                        Shadow(
                                            blurRadius: 20.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withOpacity(0.5)),
                                        Shadow(
                                            blurRadius: 20.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withOpacity(0.5)),
                                      ],
                                      height: 0.97,
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    colors: [
                                      Theme.of(context).colorScheme.secondary,
                                      Colors.orange,
                                      Colors.red,
                                      Colors.yellow,
                                      Colors.blue,
                                      // Colors.tealAccent,
                                      Colors.pinkAccent,
                                      Theme.of(context).colorScheme.secondary
                                      
                                    ],

                                    speed: const Duration(milliseconds: 1000)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 5,
                                  left: 10,
                                  right: 10,
                                ),
                                height: 57.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[900],
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 5.0,
                                      offset: Offset(0.0, 3.0),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: controller,
                                  textAlignVertical: TextAlignVertical.center,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.5,
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    border: InputBorder.none,
                                    hintText: 'Enter Your Name',
                                    hintStyle: const TextStyle(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  onSubmitted: (String value) async {
                                    if (value.trim() == '') {
                                      await _addUserData(
                                        'Guest',
                                      );
                                    } else {
                                      await _addUserData(value.trim());
                                    }
                                    Navigator.popAndPushNamed(
                                      context,
                                      '/pref',
                                    );
                                  },
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (controller.text.trim() == '') {
                                    await _addUserData('Guest');
                                  } else {
                                    await _addUserData(
                                      controller.text.trim(),
                                    );
                                  }
                                  Navigator.popAndPushNamed(context, '/pref');
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                  ),
                                  height: 55.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.deepOrange.withOpacity(0.5),
                                        blurRadius: 5.0,
                                      ),
                                      BoxShadow(
                                        color:
                                            Colors.deepOrange.withOpacity(0.5),
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Next',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                ),
                                child: Text(
                                  '${''} ${''}',
                                  style: TextStyle(
                                    color: Colors.grey.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
