part of text;

class Line {
  /**
   * Unicode characters.
   */
  final List<int> characters;

  /**
   * Line number.
   */
  final int number;

  /**
   * Start position.
   */
  final int start;

  Line(this.characters, this.number, this.start);

  /**
   * End position.
   */
  int get end => start + length;

  /**
   * Line length.
   */
  int get length => characters.length;
}

class Location {
  /**
   * Column number.
   */
  final int column;

  /**
   * Line number.
   */
  final int line;

  Location(this.line, this.column);
}

class Text {
  List<int> _characters;

  SparseList<Line> _lines;

  Text(String text) {
    if (text == null) {
      throw new ArgumentError("text: $text");
    }

    _initialize(text);
  }

  /**
   * Unicode characters.
   */
  List<int> get characters => new UnmodifiableListView<int>(_characters);

  /**
   * Number of Unicode characters.
   */
  int get length => _characters.length;

  /**
   * Number of lines.
   */
  int get lineCount => _lines.groupCount;

  /**
   * Returns an Unicode character at the specified [position].
   *
   * Example:
   *     text.characterAt(0);
   */
  int characterAt(int position) {
    return _characters[position];
  }

  /**
   * Returns the lines at specified [index].
   *
   * Example:
   *     var lineNumber = 1;
   *     text.line(lineNumber - 1);
   */
  Line line(int index) {
    return _lines.groups[index].key;
  }

  /**
   * Returns the collection of text lines.
   *
   * Example:
   *     var lines = text.lines;
   */
  Iterable<Line> lines() {
    return _lines.groups.map((group) => group.key);
  }

  /**
   * Returns the line at specified character [position].
   */
  Line lineAt(int position) {
    return _lines[position];
  }

  /**
   * Returns the location at specified character [position].
   */
  Location locationAt(int position) {
    var line = this.lineAt(position);
    return new Location(line.number, position - line.start + 1);
  }

  /**
   * Returns the character position at specified [location].
   */
  int position(Location location) {
    return line(location.line - 1).start + location.column - 1;
  }

  void _initialize(String text) {
    _characters = <int>[];
    _lines = new SparseList<Line>();
    var c = -1;
    var lineNumber = 1;
    var column = 1;
    var length = text.length;
    var codePoints = <int>[];
    var i = 0;
    var pos = 0;
    var start = 0;
    _characters.length = length;
    for ( ; i < length; pos++) {
      c = text.codeUnitAt(i);
      i++;
      if ((c & 0xFC00) == 0xD800 && i < length) {
        var c2 = text.codeUnitAt(i);
        if ((c2 & 0xFC00) == 0xDC00) {
          c = 0x10000 + ((c & 0x3FF) << 10) + (c2 & 0x3FF);
          _characters[pos] = c;
          codePoints.add(c);
          i++;
        } else {
          _characters[pos] = c;
          codePoints.add(c);
        }
      } else {
        _characters[pos] = c;
        codePoints.add(c);
      }

      if (c == 13) {
        if (i < length) {
          c = text.codeUnitAt(i);
          if (c == 10) {
            _characters[++pos] = c;
            codePoints.add(c);
            i++;
          }
        }

        codePoints = new UnmodifiableListView<int>(codePoints);
        var end = i - 1;
        var line = new Line(codePoints, lineNumber, start);
        var group = new GroupedRangeList<Line>(start, end, line);
        _lines.addGroup(group);
        lineNumber++;
        column = 1;
        start = i;
        codePoints = <int>[];
      } else if (c == 10) {
        codePoints = new UnmodifiableListView<int>(codePoints);
        var end = i - 1;
        var line = new Line(codePoints, lineNumber, start);
        var group = new GroupedRangeList<Line>(start, end, line);
        _lines.addGroup(group);
        codePoints = <int>[];
        lineNumber++;
        column = 1;
        start = i;
      } else {
        column++;
      }
    }

    if (column != 1) {
      codePoints = new UnmodifiableListView<int>(codePoints);
      var line = new Line(codePoints, lineNumber, start);
      var group = new GroupedRangeList<Line>(start, i, line);
      _lines.addGroup(group);
    }

    _characters.length = i;
    _lines.freeze();
  }
}
