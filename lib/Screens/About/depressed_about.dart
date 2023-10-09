// import 'package:flutter/material.dart';
// import 'package:openvibes2/CustomWidgets/gradient_containers.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

// class AboutScreen extends StatefulWidget {
//   @override
//   _AboutScreenState createState() => _AboutScreenState();
// }

// class _AboutScreenState extends State<AboutScreen> {
//   String? appVersion;

//   @override
//   void initState() {
//     main();
//     super.initState();
//   }

//   Future<void> main() async {
//     final PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     setState(() {
//       appVersion = packageInfo.version;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double separationHeight = MediaQuery.of(context).size.height * 0.035;

//     return GradientContainer(
//       child: Stack(
//         children: [
//           Positioned(
//             left: MediaQuery.of(context).size.width / 2,
//             top: MediaQuery.of(context).size.width / 5,
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width,
//               child: const Image(
//                 fit: BoxFit.fill,
//                 image: AssetImage(
//                   'assets/icon-white-trans.png',
//                 ),
//               ),
//             ),
//           ),
//           const GradientContainer(
//             child: null,
//             opacity: true,
//           ),
//           Scaffold(
//             appBar: AppBar(
//               backgroundColor: Theme.of(context).brightness == Brightness.dark
//                   ? Colors.transparent
//                   : Theme.of(context).colorScheme.secondary,
//               elevation: 0,
//               title: const Text(
//                 'About',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               centerTitle: true,
//             ),
//             backgroundColor: Colors.transparent,
//             body: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     children: [
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Card(
//                         elevation: 15,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(100.0),
//                         ),
//                         clipBehavior: Clip.antiAlias,
//                         child: const SizedBox(
//                           width: 150,
//                           child: Image(
//                             image: AssetImage('assets/ic_launcher.png'),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       const Text(
//                         'Open Vibes 2.0',
//                         style: TextStyle(
//                           fontSize: 35,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text('v$appVersion'),
//                     ],
//                   ),
//                   SizedBox(
//                     height: separationHeight,
//                   ),
//                   SizedBox(
//                     height: separationHeight,
//                   ),
//                   Column(
//                     children: [
//                       TextButton(
//                         style: TextButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           foregroundColor: Colors.transparent,
//                         ),
//                         onPressed: () {
//                           launchUrl(
//                             Uri.parse(
//                               'https://www.buymeacoffee.com/venom82',
//                             ),
//                             mode: LaunchMode.externalApplication,
//                           );
//                         },
//                         child: SizedBox(
//                           width: MediaQuery.of(context).size.width / 2,
//                           child: const Image(
//                             image: AssetImage('assets/black-button.png'),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: separationHeight,
//                   ),
//                   const SafeArea(
//                     child: Padding(
//                       padding: EdgeInsets.fromLTRB(5, 30, 5, 20),
//                       child: Center(
//                         child: Text(
//                           'Made by VENOM',
//                           style: TextStyle(fontSize: 12),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
