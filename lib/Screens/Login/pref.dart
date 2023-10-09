import 'package:openvibes2/CustomWidgets/gradient_containers.dart';
import 'package:openvibes2/CustomWidgets/snackbar.dart';
import 'package:openvibes2/Helpers/backup_restore.dart';
import 'package:openvibes2/Helpers/config.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

class PrefScreen extends StatefulWidget {
  const PrefScreen({super.key});

  @override
  _PrefScreenState createState() => _PrefScreenState();
}

class _PrefScreenState extends State<PrefScreen> {
  List<String> languages = [
    'Hindi',
    'English',
    'Punjabi',
    'Tamil',
    'Telugu',
    'Marathi',
    'Gujarati',
    'Bengali',
    'Kannada',
    'Bhojpuri',
    'Malayalam',
    'Urdu',
    'Haryanvi',
    'Rajasthani',
    'Odia',
    'Assamese',
  ];
  List<String> languageBackgrounds = [
    'https://image.winudf.com/v2/image/Y29tLnZpcnR1YWxzb2Z0ZWNoLmxhdGFtYW5nZXNoa2FyX2ljb25fMTUzNDY3ODk2OF8wNDA/icon.png?w=340&fakeurl=1', //HINDI
    'https://www.pngplay.com/wp-content/uploads/13/XXXTentacion-PNG-Clipart-Background.png', //ENGLISH
    'https://i.pinimg.com/originals/4b/72/cc/4b72cc8ef49932551fa61a3cac8ccb80.png', //PUNJABI
    'https://spbindia.com/wp-content/uploads/2018/11/spb-profile-03-n.png', //TAMIL
    'https://static.vecteezy.com/system/resources/previews/001/200/753/original/music-note-png.png', // TELUGU
    'https://pluspng.com/img-png/mohiniyattam-png-bharathanjali-323.png', //MARATHI
    'https://cdni.iconscout.com/illustration/premium/thumb/gujarati-couple-playing-raas-garba-2775548-2319260.png', // GUJARATI
    'https://static.vecteezy.com/system/resources/previews/001/200/753/original/music-note-png.png', // BANGALi
    'https://static.vecteezy.com/system/resources/previews/001/200/753/original/music-note-png.png', //KANNA
    'https://static.vecteezy.com/system/resources/previews/001/200/753/original/music-note-png.png', //BHOJ
    'https://th.bing.com/th/id/R.a706abd9438bb1042e5c2cb646f754ff?rik=MM%2fo%2bkNTnIccGg&riu=http%3a%2f%2fimages.onlinelabels.com%2fimages%2fclip-art%2fnicubunu%2fnicubunu_Musical_note.png&ehk=JNE20XHLGZJkHk%2brAFlAgD4Uca6NH%2byEA4XqQ22kGD4%3d&risl=&pid=ImgRaw&r=0', //MALA
    'https://static.vecteezy.com/system/resources/previews/001/200/753/original/music-note-png.png', //URDU
    'https://cdni.iconscout.com/illustration/premium/thumb/haryanvi-woman-stand-wearing-sun-glasses-and-wood-stick-2660269-2224928.png', //HARYADA
    'https://cdni.iconscout.com/illustration/free/thumb/rajasthani-male-2885398-2394042.png', //RAJASZTHAN
    'https://netodisha.in/wp-content/uploads/2020/10/PicsArt_10-04-10.56.29.png', //ODIA
    'https://th.bing.com/th/id/R.a706abd9438bb1042e5c2cb646f754ff?rik=MM%2fo%2bkNTnIccGg&riu=http%3a%2f%2fimages.onlinelabels.com%2fimages%2fclip-art%2fnicubunu%2fnicubunu_Musical_note.png&ehk=JNE20XHLGZJkHk%2brAFlAgD4Uca6NH%2byEA4XqQ22kGD4%3d&risl=&pid=ImgRaw&r=0', //ASSE
  ];
  List<Color> bgColors = [
    Colors.blueGrey,
    Colors.blue,
    Colors.redAccent,
    Colors.green,
    Colors.teal,
    Colors.purple,
    Colors.lime,
    Colors.lightBlue,
    Colors.deepPurpleAccent,
    Colors.amber,
    Colors.purpleAccent,
    Colors.teal,
    Colors.green,
    Colors.redAccent,
    Colors.blue,
    Colors.blueGrey,
  ];
  List<bool> isSelected = [true, false];
  List preferredLanguage = Hive.box('settings')
      .get('preferredLanguage', defaultValue: ['Hindi'])?.toList() as List;
  String region =
      Hive.box('settings').get('region', defaultValue: 'India') as String;
  bool useProxy =
      Hive.box('settings').get('useProxy', defaultValue: false) as bool;

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                          Navigator.popAndPushNamed(context, '/');
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.075,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 40.0, bottom: 10),
                      child: Text('Choose your languages ',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (preferredLanguage.isEmpty) {
                                ShowSnackBar().showSnackBar(
                                  context,
                                  'No language Selected',
                                );
                              }
                              Navigator.popAndPushNamed(
                                context,
                                '/',
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              height: 50.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Theme.of(context).colorScheme.secondary,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 5.0,
                                    offset: Offset(0.0, 3.0),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  'Finish',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          languageCard(context),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),
                          // languageCard()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget languageCard(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return StatefulBuilder(
      builder: (context, setState) {
        final List checked = List.from(preferredLanguage);
        return GridView.builder(
          physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: languages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, idx) {
              return Container(
                margin: EdgeInsets.all(height * 0.02),
                decoration: BoxDecoration(
                    color: bgColors[idx],
                    border: Border.all(color: bgColors[idx]),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: <BoxShadow>[
                      BoxShadow(blurRadius: 10, color: bgColors[idx]),
                      BoxShadow(blurRadius: 10, color: bgColors[idx]),
                    ]),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        Checkbox(
                          activeColor:
                              Theme.of(context).colorScheme.secondary,
                          value: checked.contains(
                            languages[idx],
                          ),
                          onChanged: (
                            bool? value,
                          ) {
                            value!
                                ? checked.add(
                                    languages[idx],
                                  )
                                : checked.remove(
                                    languages[idx],
                                  );
                            setState(() {});
                            setState(() {
                              preferredLanguage = checked;

                              Hive.box(
                                'settings',
                              ).put(
                                'preferredLanguage',
                                checked,
                              );
                            });
                          },
                        )
                      ],
                    ),
                    // Center(
                    //     child: Image.network(
                    //   languageBackgrounds[idx],
                    //   height: 100,
                    //   width: 100,
                    //   fit: BoxFit.cover,
                    // )),
                    Center(
                      child: Text(languages[idx],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
              );
            });
      },
    );
    // return ListView.builder(
    //     shrinkWrap: true,
    //     itemCount: languages.length,
    //     itemBuilder: (context, idx) {
    //       final List checked = List.from(preferredLanguage);
    //       return StatefulBuilder(builder: (context, setStt) {
    //         return Card(
    //             margin: const EdgeInsets.all(10),
    //             child: ListTile(
    //               enableFeedback: true,
    //               style: ListTileStyle.drawer,
    //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    //               leading: Image.network(languageBackgrounds[idx], width: 60,),
    //               tileColor: bgColors[idx],
    //               trailing: Checkbox(
    //                 activeColor: Theme.of(context).colorScheme.secondary,
    //                   value: checked.contains(
    //                     languages[idx],
    //                   ),
    //                   onChanged: (
    //                     bool? value,
    //                   ) {
    //                     value!
    //                         ? checked.add(
    //                             languages[idx],
    //                           )
    //                         : checked.remove(
    //                             languages[idx],
    //                           );
    //                     setStt(() {});
    //                     setState(() {
    //                       preferredLanguage = checked;

    //                       Hive.box(
    //                         'settings',
    //                       ).put(
    //                         'preferredLanguage',
    //                         checked,
    //                       );
    //                     });
    //                   },
    //                 ),
    //               title: Text(
    //                 languages[idx],
    //                 style: const TextStyle(fontSize: 20),
    //               ),
    //             ));
    //       });
    //     });
  }
}
