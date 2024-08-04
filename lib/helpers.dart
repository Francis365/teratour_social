import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> showToast(Object message,
    {Toast toastLength = Toast.LENGTH_SHORT}) {
  return Fluttertoast.showToast(
      msg: "$message", toastLength: toastLength, gravity: ToastGravity.BOTTOM);
}
