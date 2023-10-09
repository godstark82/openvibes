

import 'package:audio_service/audio_service.dart';
import 'package:openvibes2/CustomWidgets/snackbar.dart';
import 'package:openvibes2/Screens/Player/audioplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

void addToNowPlaying({
  required BuildContext context,
  required MediaItem mediaItem,
  bool showNotification = true,
}) {
  final AudioPlayerHandler audioHandler = GetIt.I<AudioPlayerHandler>();
  final MediaItem? currentMediaItem = audioHandler.mediaItem.value;
  if (currentMediaItem != null &&
      currentMediaItem.extras!['url'].toString().startsWith('http')) {
    if (audioHandler.queue.value.contains(mediaItem) && showNotification) {
      ShowSnackBar().showSnackBar(
        context,
       'Already in Queue',
      );
    } else {
      audioHandler.addQueueItem(mediaItem);

      if (showNotification) {
        ShowSnackBar().showSnackBar(
          context,
          'Added to Queue',
        );
      }
    }
  } else {
    if (showNotification) {
      ShowSnackBar().showSnackBar(
        context,
        currentMediaItem == null
            ? 'Nothing Playing'
            : 'Can not add to Queue',
      );
    }
  }
}

void playNext(
  MediaItem mediaItem,
  BuildContext context,
) {
  final AudioPlayerHandler audioHandler = GetIt.I<AudioPlayerHandler>();
  final MediaItem? currentMediaItem = audioHandler.mediaItem.value;
  if (currentMediaItem != null &&
      currentMediaItem.extras!['url'].toString().startsWith('http')) {
    final queue = audioHandler.queue.value;
    if (queue.contains(mediaItem)) {
      audioHandler.moveQueueItem(
        queue.indexOf(mediaItem),
        queue.indexOf(currentMediaItem) + 1,
      );
    } else {
      audioHandler.addQueueItem(mediaItem).then(
            (value) => audioHandler.moveQueueItem(
              queue.length,
              queue.indexOf(currentMediaItem) + 1,
            ),
          );
    }

    ShowSnackBar().showSnackBar(
      context,
      '"${mediaItem.title}" ${'Will Play Next'}',
    );
  } else {
    ShowSnackBar().showSnackBar(
      context,
      currentMediaItem == null
          ? 'Nothing Playing'
          : 'Can not add to Queue',
    );
  }
}
