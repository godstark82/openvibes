// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:openvibes2/CustomWidgets/gradient_containers.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

// class AboutPage extends StatefulWidget {
//   const AboutPage({super.key});

//   @override
//   State<AboutPage> createState() => _AboutPageState();
// }

// class _AboutPageState extends State<AboutPage> {
//   String? appVersion;

//   @override
//   void initState() {
//     main();
//     super.initState();
//   }

//   Future<void> main() async {
//     final PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     appVersion = packageInfo.version;
//     setState(
//       () {},
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GradientContainer(
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           centerTitle: true,
//           title: Text(
//             AppLocalizations.of(
//               context,
//             )!
//                 .about,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Theme.of(context).iconTheme.color,
//             ),
//           ),
//           iconTheme: IconThemeData(
//             color: Theme.of(context).iconTheme.color,
//           ),
//         ),
//         body: CustomScrollView(
//           physics: const BouncingScrollPhysics(),
//           slivers: [
//             SliverList(
//               delegate: SliverChildListDelegate([
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(
//                     10.0,
//                     10.0,
//                     10.0,
//                     10.0,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ListTile(
//                         title: Text(
//                           AppLocalizations.of(
//                             context,
//                           )!
//                               .likedWork,
//                         ),
//                         subtitle: Text(
//                           AppLocalizations.of(
//                             context,
//                           )!
//                               .buyCoffee,
//                         ),
//                         dense: true,
//                         onTap: () {
//                           launchUrl(
//                             Uri.parse(
//                               'https://www.buymeacoffee.com/venom82',
//                             ),
//                             mode: LaunchMode.externalApplication,
//                           );
//                         },
//                       ),
//                       ListTile(
//                         title: Text(
//                           AppLocalizations.of(
//                             context,
//                           )!
//                               .moreInfo,
//                         ),
//                         dense: true,
//                         onTap: () {
//                           Navigator.pushNamed(context, '/about');
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ]),
//             ),
//             const SliverFillRemaining(
//               hasScrollBody: false,
//               child: Column(
//                 children: <Widget>[
//                   Spacer(),
//                   SafeArea(
//                     child: Padding(
//                       padding: EdgeInsets.fromLTRB(5, 30, 5, 20),
//                       child: Center(
//                         child: Text(
//                           'Made by VENOM',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
