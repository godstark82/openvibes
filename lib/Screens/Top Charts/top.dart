import 'package:flutter/material.dart';
import 'package:openvibes2/APIs/api.dart';
import 'package:openvibes2/Screens/others/my_songs_list.dart';

class TopCharts extends StatefulWidget {
  const TopCharts({super.key});

  @override
  State<TopCharts> createState() => _TopChartsState();
}

class _TopChartsState extends State<TopCharts> {
// Hindi Top 50 id: 1134543272

//Internation ID: 61969868
// Playlist id: 61969868

  List localSongs = [];
  List globalSongs = [];
  Future<void> fetchData() async {
    final local = await SaavnAPI().fetchPlaylistSongs('1134543272');
    final global = await SaavnAPI().fetchPlaylistSongs('61969868');
    final localSong = local['songs'] as List;
    final globalSong = global['songs'] as List;

    setState(() {
      localSongs = localSong;
      globalSongs = globalSong;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(159, 63, 4, 0),
          Color.fromARGB(159, 0, 32, 59),
        ], begin: Alignment.topLeft, end: Alignment.topRight)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: const Text('Top Charts'),
              centerTitle: true,
              bottom: TabBar(
                tabs: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Center(child: Text('Local')),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Center(child: Text('Global')),
                  ),
                ],
                indicatorSize: TabBarIndicatorSize.label,
              ),
            ),
            body: localSongs.isNotEmpty
                ? TabBarView(
                    children: [
                      MySongsList(
                        data: localSongs,
                      ),
                      MySongsList(
                        data: globalSongs,
                      ),
                    ],
                  )
                : const LinearProgressIndicator()),
      ),
    );
  }
}
