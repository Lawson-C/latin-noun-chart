class Tile {
  PVector pos;
  String val = "";
  color c = 255;
  boolean select = false;

  Tile(String val) {
    this.val = val;
    this.pos = new PVector(0, 0, 0);
  }

  Tile(float x, float y, String val) {
    this.val = val;
    this.pos = new PVector();
    this.pos.set(x, y);
  }

  Tile(PVector pos, String val) {
    this.pos = pos;
    this.val = val;
  }

  Tile(Tile other) {
    this.val = other.getVal();
    try {
      this.pos.set(other.pos);
    } 
    catch (NullPointerException e) {
      this.pos = new PVector(0, 0, 0);
    }
  }

  void setPos(PVector pos) {
    setPos(pos.x, pos.y);
  }

  void setPos(float x, float y) {
    this.pos.set(x, y);
  }

  void setVal(String val) {
    this.val = val;
  }

  void setSelect(boolean set) {
    this.select = set;
    isSelected = set;
  }

  String getVal() {
    String output = "";
    int i = 0;
    while (i < this.val.length()) {
      if (val.indexOf(wordEnds[0]) == i) {
        output += "ā";
        i++;
      } else if (val.indexOf(wordEnds[1]) == i) {
        output += "ē";
        i++;
      } else if (val.indexOf(wordEnds[2]) == i) {
        output += "ī";
        i++;
      } else if (val.indexOf(wordEnds[3]) == i) {
        output += "ō";
        i++;
      } else if (val.indexOf(wordEnds[4]) == i) {
        output += "ū";
        i++;
      } else {
        output += ""+val.charAt(i);
      }
      i++;
    }
    return output;
  }

  void display() {
    if (select) {
      fill(c);
      rect(mouseX, mouseY, 100, 50);
      fill(0);
      textSize(25);
      text(getVal(), mouseX+15, mouseY+35);
    } else {
      fill(c);
      rect(pos.x, pos.y, 100, 50);
      fill(0);
      textSize(25);
      text(getVal(), pos.x+15, pos.y+35);
    }
  }

  String toString() {
    return getVal();
  }

  boolean equals(Tile other) {
    return other.pos.x == this.pos.x && other.pos.y == this.pos.y && other.val.equals(this.val);
  }
}
