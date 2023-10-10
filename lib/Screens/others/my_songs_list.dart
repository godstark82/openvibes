import 'package:openvibes2/CustomWidgets/download_button.dart';
import 'package:openvibes2/CustomWidgets/image_card.dart';
import 'package:openvibes2/Services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MySongsList extends StatefulWidget {
  final List data;
  const MySongsList({
    super.key,
    required this.data,
  });
  @override
  _MySongsListState createState() => _MySongsListState();
}

class _MySongsListState extends State<MySongsList> {
  List _songs = [];
  List original = [];
  bool offline = false;
  bool added = false;
  bool processStatus = false;
  int sortValue = Hive.box('settings').get('sortValue', defaultValue: 1) as int;
  int orderValue =
      Hive.box('settings').get('orderValue', defaultValue: 1) as int;

  Future<void> getSongs() async {
    added = true;
    _songs = widget.data;
    if (!offline) original = List.from(_songs);

    processStatus = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!added) {
      getSongs();
    }
    return Container(
     
      child: !processStatus
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              shrinkWrap: true,
              itemCount: _songs.length,
              itemExtent: 70.0,
              itemBuilder: (context, index) {
                return _songs.isEmpty
                    ? const SizedBox()
                    : ListTile(
                        leading: imageCard(
                          localImage: offline,
                          imageUrl: offline
                              ? _songs[index]['image'].toString()
                              : _songs[index]['image'].toString(),
                        ),
                        title: Text(
                          ' ${_songs[index]['title']}',
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          ' ${_songs[index]['artist']}',
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        
                        onTap: () {
                          PlayerInvoke.init(
                            songsList: _songs,
                            index: index,
                            isOffline: offline,
                            fromDownloads: offline,
                            recommend: !offline,
                          );
                        },
                      );
              },
            ),
    );
  }
}
