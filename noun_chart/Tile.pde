class Tile {
  static final int xSize = 100, ySize = 50;
  PVector pos;
  private String val = "";
  color c = 255;
  boolean select = false;

  Tile(String val) {
    this.val = val;
    this.pos = new PVector(0, 0, 0);
  }

  Tile(float x, float y, String val) {
    this.val = val;
    this.pos = new PVector(x, y);
  }

  Tile(PVector pos, String val) {
    this.pos = new PVector();
    this.pos.set(pos);
    this.val = val;
  }

  Tile(Tile other) {
    this.val = other.val;
    this.pos = new PVector();
    this.pos.set(other.pos);
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

  void set(Tile t) {
    this.val = t.val;
    setPos(t.pos);
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

  String undoVal() {
    String output = "";
    int i = 0;
    while (i < this.val.length()) {
      if (val.indexOf("ā") == i) {
        output += wordEnds[0];
        i++;
      } else if (val.indexOf("ē") == i) {
        output += wordEnds[1];
        i++;
      } else if (val.indexOf("ī") == i) {
        output += wordEnds[2];
        i++;
      } else if (val.indexOf("ō") == i) {
        output += wordEnds[3];
        i++;
      } else if (val.indexOf("ū") == i) {
        output += wordEnds[4];
        i++;
      } else if (val.charAt(i) != TAB && val.charAt(i) != ENTER && val.charAt(i) != RETURN) {
        output += ""+val.charAt(i);
      }
      i++;
    }
    return output;
  }
}
