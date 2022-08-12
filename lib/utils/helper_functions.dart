import 'package:intl/intl.dart';

String getFormattedDate(DateTime dt, String format) =>
    DateFormat(format).format(dt);