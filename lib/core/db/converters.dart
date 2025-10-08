import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class UuidValueConverter extends TypeConverter<UuidValue, String> {
  const UuidValueConverter();

  @override
  UuidValue fromSql(String fromDb) {
    return UuidValue.fromString(fromDb);
  }

  @override
  String toSql(UuidValue value) {
    return value.toString();
  }
}

class TimestampConverter extends TypeConverter<DateTime, int> {
  const TimestampConverter();

  @override
  DateTime fromSql(int fromDb) {
    return DateTime.fromMillisecondsSinceEpoch(fromDb);
  }

  @override
  int toSql(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}
