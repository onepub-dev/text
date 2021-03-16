import 'package:text/text.dart';
import 'package:test/test.dart';

void main() {
  test('Text', () {
    {
      var text = Text(string);
      expect(text.lineCount, 4, reason: 'Text.lineCount');
    }
    //
    {
      var str = string.replaceAll('\n', '\r\n');
      var text = Text(str);
      expect(text.lineCount, 4, reason: 'Text.lineCount');
    }
    //
    {
      var text = Text('');
      expect(text.lineCount, 1, reason: 'Text.lineCount');
    }
    //
    {
      var text = Text('\r');
      expect(text.lineCount, 1, reason: 'Text.lineCount');
    }
    //
    {
      var text = Text('\r ');
      expect(text.lineCount, 2, reason: 'Text.lineCount');
    }
    //
    {
      var str = string.replaceAll('\n', '\r\n');
      var text = Text(str);
      var length = text.length;
      for (var position = 0; position < length; position++) {
        var line = text.lineAt(position)!;
        expect(position >= line.start, true, reason: 'Line.start');
        expect(position <= line.end, true, reason: 'Line.end');
      }
    }
    //
    {
      var str = string.replaceAll('\n', '\r\n');
      var text = Text(str);
      var length = text.length;
      for (var position = 0; position < length; position++) {
        var line = text.lineAt(position)!;
        var location = text.locationAt(position);
        expect(location.line, line.number, reason: 'Line.locationAt');
        expect(location.column, position - line.start + 1,
            reason: 'Line.locationAt');
      }
    }
    //
    {
      var str = string.replaceAll('\n', '\r\n');
      var text = Text(str);
      var length = text.length;
      for (var position = 0; position < length; position++) {
        var location = text.locationAt(position);
        var position2 = text.position(location);
        expect(position2, position, reason: 'Line.position');
      }
    }
  });
}

String string = '''
П
h
￠
a
''';
