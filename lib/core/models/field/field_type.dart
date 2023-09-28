///
enum FieldType {
  int,
  real,
  string,
  date;
  const FieldType();
  factory FieldType.from(String value) {
    return switch(value) {
      "int" => FieldType.int,
      "real" => FieldType.real,
      "date" => FieldType.date,
      _ => FieldType.string,
    };
  }
}