import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:openvibes2/APIs/api.dart';
import 'package:openvibes2/CustomWidgets/download_button.dart';
import 'package:openvibes2/CustomWidgets/image_card.dart';
import 'package:openvibes2/CustomWidgets/snackbar.dart';
import 'package:openvibes2/Screens/Library/show_songs.dart';

class NoEntry extends StatefulWidget {
  const NoEntry({super.key});

  @override
  State<NoEntry> createState() => _NoEntryState();
}

class _NoEntryState extends State<NoEntry> {
  List _songs = [];
  Future<void> fetchData() async {
    // final local = await SaavnAPI().fetchAlbumSongs('22063173');
    // final localSong = local['songs'] as List;
    // ignore: avoid_print
    await SaavnAPI()
        .fetchAlbums(
      searchQuery: 'No Copyright Songs',
      type: 'album',
      // page: page,
    )
        .then((value) {
      final temp = _songs ?? [];
      temp.addAll(value);
      setState(() {
        _songs = temp;
      });
    });

    debugPrint('$_songs');

    // print(_songs);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(221, 87, 87, 87),
            Color.fromARGB(255, 81, 104, 145),
            Color.fromARGB(255, 150, 92, 92),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'OpenVibes',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            centerTitle: true,
          ),
          body: _songs.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No Copyright Songs',
                            style: TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                      NESongsListPage(listItem: _songs[0] as Map),
                      NESongsListPage(listItem: _songs[1] as Map),
                      NESongsListPage(listItem: _songs[3] as Map),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class NESongsListPage extends StatefulWidget {
  final Map listItem;

  const NESongsListPage({
    super.key,
    required this.listItem,
  });

  @override
  _NESongsListPageState createState() => _NESongsListPageState();
}

class _NESongsListPageState extends State<NESongsListPage> {
  int page = 1;
  bool loading = false;
  List songList = [];
  bool fetched = false;

  @override
  void initState() {
    super.initState();
    _fetchSongs();
  }

  void _fetchSongs() {
    loading = true;
    try {
      switch (widget.listItem['type'].toString()) {
        case 'songs':
          SaavnAPI()
              .fetchSongSearchResults(
            searchQuery: widget.listItem['id'].toString(),
            page: page,
          )
              .then((value) {
            setState(() {
              songList.addAll(value['songs'] as List);
              fetched = true;
              loading = false;
            });
            if (value['error'].toString() != '') {
              ShowSnackBar().showSnackBar(
                context,
                'Error: ${value["error"]}',
                duration: const Duration(seconds: 3),
              );
            }
          });
          break;
        case 'album':
          SaavnAPI()
              .fetchAlbumSongs(widget.listItem['id'].toString())
              .then((value) {
            setState(() {
              songList = value['songs'] as List;
              fetched = true;
              loading = false;
            });
            if (value['error'].toString() != '') {
              ShowSnackBar().showSnackBar(
                context,
                'Error: ${value["error"]}',
                duration: const Duration(seconds: 3),
              );
            }
          });
          break;
        case 'playlist':
          SaavnAPI()
              .fetchPlaylistSongs(widget.listItem['id'].toString())
              .then((value) {
            setState(() {
              songList = value['songs'] as List;
              fetched = true;
              loading = false;
            });
            if (value['error'] != null && value['error'].toString() != '') {
              ShowSnackBar().showSnackBar(
                context,
                'Error: ${value["error"]}',
                duration: const Duration(seconds: 3),
              );
            }
          });
          break;
        case 'mix':
          SaavnAPI()
              .getSongFromToken(
            widget.listItem['perma_url'].toString().split('/').last,
            'mix',
          )
              .then((value) {
            setState(() {
              songList = value['songs'] as List;
              fetched = true;
              loading = false;
            });

            if (value['error'] != null && value['error'].toString() != '') {
              ShowSnackBar().showSnackBar(
                context,
                'Error: ${value["error"]}',
                duration: const Duration(seconds: 3),
              );
            }
          });
          break;
        case 'show':
          SaavnAPI()
              .getSongFromToken(
            widget.listItem['perma_url'].toString().split('/').last,
            'show',
          )
              .then((value) {
            setState(() {
              songList = value['songs'] as List;
              fetched = true;
              loading = false;
            });

            if (value['error'] != null && value['error'].toString() != '') {
              ShowSnackBar().showSnackBar(
                context,
                'Error: ${value["error"]}',
                duration: const Duration(seconds: 3),
              );
            }
          });
          break;
        default:
          setState(() {
            fetched = true;
            loading = false;
          });
          ShowSnackBar().showSnackBar(
            context,
            'Error: Unsupported Type ${widget.listItem['type']}',
            duration: const Duration(seconds: 3),
          );
          break;
      }
    } catch (e) {
      setState(() {
        fetched = true;
        loading = false;
      });
      Logger.root.severe(
        'Error in song_list with type ${widget.listItem["type"]}: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: songList.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.transparent,
            child: ListTile(
              title: Text(
                '${songList[index]['title']}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.white),
              ),
              subtitle: Text(
                '${songList[index]['subtitle']}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: DownloadButton(
                data: songList[index] as Map,
                icon: 'Download',
              ),
              leading: imageCard(
                elevation: 8,
                placeholderImage: const AssetImage(
                  'assets/album.png',
                ),
                imageUrl: songList[index]['image'].toString(),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SongsList(
                    data: songList,
                    offline: false,
                  );
                }));
              },
            ),
          );
        });
  }
}
