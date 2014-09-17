import "package:text/text.dart";
import "package:unittest/unittest.dart";

void main() {
  var text = new Text(string);
  expect(text.lineCount, 5, reason: "Text.lineCount");
  //
  var string2 = string.replaceAll("\n", "\r\n");
  var text2 = new Text(string2);
  expect(text2.lineCount, 5, reason: "Text.lineCount");
  //
  var length = text2.length;
  for (var position = 0; position < length; position++) {
    var line = text2.lineAt(position);
    expect(position >= line.start, true, reason: "Line.start");
    expect(position <= line.end, true, reason: "Line.end");
  }
  //
  length = text2.length;
  for (var position = 0; position < length; position++) {
    var line = text2.lineAt(position);
    var location = text2.locationAt(position);
    expect(location.line, line.number, reason: "Line.locationAt");
    expect(location.column, position - line.start + 1, reason: "Line.locationAt");
  }

  //
  length = text2.length;
  for (var position = 0; position < length; position++) {
    var location = text2.locationAt(position);
    var position2 = text2.position(location);
    expect(position2, position, reason: "Line.position");
  }
}

String string = '''
П
h
￠
a
''';
