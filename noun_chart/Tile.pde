class Tile {
  static final int xSize = 100, ySize = 50;
  PVector pos;
  PVector prevSelect;
  private String val = "";
  color c = 255;
  boolean select = false;

  Tile(String val) {
    this(0.0, 0.0, val);
  }

  Tile(float x, float y, String val) {
    this.val = val;
    this.pos = new PVector(x, y);
    this.prevSelect = new PVector(-1, -1);
  }

  Tile(PVector pos, String val) {
    this(pos.x, pos.y, val);
  }

  Tile(Tile other) {
    this(other.pos, other.val);
  }

  void setTile(Tile[][] g, int xLo, int yLo, int xMa, int yMa, int xLo2, int yLo2, int xMa2, int yMa2) {
    boolean isSecond = pos.x >= xLo2 && pos.x < xMa2 && pos.y >= yLo2 && pos.y < yMa2;
    int xL, xM;
    int yL, yM;
    if (!isSecond) {
      xL = xLo;
      yL = yLo;
      xM = xMa;
      yM = yMa;
    } else {
      xL = xLo2;
      yL = yLo2;
      xM = xMa2; //<>//
      yM = yMa2;
    }
    if (prevSelect.x > -1 && prevSelect.y > -1 && pos.x/10 != (int) prevSelect.x/10 && pos.y/10 != (int) prevSelect.y/10) {
      g[(int) prevSelect.x][(int) prevSelect.y].setVal("[ ]");
      prevSelect.set(-1, -1);
    }
    if (pos.x >= xL && pos.x < xM && pos.y >= yL && pos.y < yM) {
      if (!select) {
        prevSelect.set((pos.x - xL) / Tile.xSize, (pos.y - yL) / Tile.ySize);
        if (isSecond) {
          prevSelect.y += 5;
        }
        g[(int) prevSelect.x][(int) prevSelect.y].setVal(undoVal());
      }
    } else if (prevSelect.x > -1 && prevSelect.y > -1) {
      g[(int) prevSelect.x][(int) prevSelect.y].setVal("[ ]");
      prevSelect.set(-1, -1);
    }
  }

  void setPos(PVector pos) {
    setPos(pos.x, pos.y);
  }

  void setPos(float x, float y) {
    this.pos.set(x, y);
  }

  void setVal(String v) {
    this.val = v;
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
      pos.set(mouseX, mouseY);
      fill(c);
      rect(pos.x, pos.y, 100, 50);
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
    boolean out = other.pos.x == this.pos.x && other.pos.y == this.pos.y && other.undoVal().equals(this.undoVal());
    return out;
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
      } else if (val.charAt(i) != ENTER && val.charAt(i) != RETURN) {
        output += ""+val.charAt(i);
      }
      i++;
    }
    return output;
  }
}
