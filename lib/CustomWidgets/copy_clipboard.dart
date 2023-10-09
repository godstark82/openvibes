import 'package:openvibes2/CustomWidgets/snackbar.dart';
// ignore: directives_ordering
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

void copyToClipboard({
  required BuildContext context,
  required String text,
  String? displayText,
}) {
  Clipboard.setData(
    ClipboardData(text: text),
  );
  ShowSnackBar().showSnackBar(
    context,
    displayText ?? 'Copied',
  );
}
