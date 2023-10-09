import 'dart:io';
import 'package:openvibes2/Screens/Library/liked.dart';
import 'package:openvibes2/Screens/LocalMusic/downed_songs.dart';
import 'package:openvibes2/Screens/LocalMusic/downed_songs_desktop.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        AppBar(
          title: Text(
            'Library',
            style: TextStyle(
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        // LibraryTile(
        //   title: 'Now Playing',
        //   icon: Icons.queue_music_rounded,
        //   onTap: () {
        //     Navigator.pushNamed(context, '/nowplaying');
        //   },
        // ),
        LibraryTile(
          title: 'Favorites',
          icon: Icons.favorite_rounded,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LikedSongs(
                  playlistName: 'Favorite Songs',
                  showName: 'Favorite Songs',
                ),
              ),
            );
          },
        ),
        LibraryTile(
          title: 'My Musc',
          icon: MdiIcons.folderMusic,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
                        ? const DownloadedSongsDesktop()
                        : const DownloadedSongs(
                            showPlaylists: true,
                          ),
              ),
            );
          },
        ),
        LibraryTile(
          title: 'Downloads',
          icon: Icons.download_done_rounded,
          onTap: () {
            Navigator.pushNamed(context, '/downloads');
          },
        ),
        LibraryTile(
          title: 'Playlists',
          icon: Icons.playlist_play_rounded,
          onTap: () {
            Navigator.pushNamed(context, '/playlists');
          },
        ),
        // LibraryTile(
        //   title: 'Stats',
        //   icon: Icons.auto_graph_rounded,
        //   onTap: () {
        //     Navigator.pushNamed(context, '/stats');
        //   },
        // ),
      ],
    );
  }
}

class LibraryTile extends StatelessWidget {
  const LibraryTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).iconTheme.color,
        ),
      ),
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
      onTap: onTap,
    );
  }
}
