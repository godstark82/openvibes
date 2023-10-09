/*
 *  This file is part of openvibes2 (https://github.com/Sangwan5688/openvibes2).
 * 
 * openvibes2 is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * openvibes2 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with openvibes2.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Copyright (c) 2021-2023, Ankit Sangwan
 */

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:openvibes2/Screens/Home/home.dart';
import 'package:openvibes2/Screens/Library/downloads.dart';
import 'package:openvibes2/Screens/Library/nowplaying.dart';
import 'package:openvibes2/Screens/Library/playlists.dart';
import 'package:openvibes2/Screens/Library/recent.dart';
import 'package:openvibes2/Screens/Library/stats.dart';
import 'package:openvibes2/Screens/Login/auth.dart';
import 'package:openvibes2/Screens/Login/pref.dart';
import 'package:openvibes2/Screens/Settings/new_settings_page.dart';

Widget initialFuntion() {
  return Hive.box('settings').get('userId') != null ? HomePage() : AuthScreen();
}

final Map<String, Widget Function(BuildContext)> namedRoutes = {
  '/': (context) => initialFuntion(),
  '/pref': (context) => const PrefScreen(),
  '/setting': (context) => const NewSettingsPage(),
  // '/about': (context) => AboutScreen(),
  '/playlists': (context) => PlaylistScreen(),
  '/nowplaying': (context) => NowPlaying(),
  '/recent': (context) => RecentlyPlayed(),
  '/downloads': (context) => const Downloads(),
  '/stats': (context) => const Stats(),
};

final Map<String, Widget Function(BuildContext)> namedRoutesForNoInternet = {
  // '/': (context) => initialFuntion(),
  '/pref': (context) => const PrefScreen(),
  '/setting': (context) => const NewSettingsPage(),
  // '/about': (context) => AboutScreen(),
  '/playlists': (context) => PlaylistScreen(),
  '/nowplaying': (context) => NowPlaying(),
  '/recent': (context) => RecentlyPlayed(),
  '/': (context) => const Downloads(),
  '/stats': (context) => const Stats(),
};
