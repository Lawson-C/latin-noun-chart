import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.io.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class noun_chart extends PApplet {



Tile[][] tileGroup = new Tile[8][10];
Tile[][] complete = new Tile[8][10];
Tile[][] tiles = new Tile[8][10];

File endings = new File("C:\\Users\\lawso\\OneDrive\\Documents\\github\\latin-noun-chart\\noun_chart\\data\\endings");
File letters = new File("C:\\Users\\lawso\\OneDrive\\Documents\\github\\latin-noun-chart\\noun_chart\\data\\conversion");
BufferedReader reader;
BufferedReader endingReader;

int xSelect = -1, ySelect = -1;
String[] wordEnds = new String[5];
boolean isSelected = false;

public void setup() {
  
  try {
    reader = new BufferedReader(new FileReader(endings));
  }
  catch (Exception e) {
    System.out.println("no file found line 13");
  }
  try {
    endingReader = new BufferedReader(new FileReader(letters));
  }
  catch (Exception e) {
    System.out.println("no file found line 13");
  }
  mark(reader, 357);
  String line = readLine(reader);
  int ty = 0;
  while (line.charAt(0) != '#') {
    int i = 0;
    int ind = 0;
    while (i < line.length()) {
      String c = "";
      for (int j = 0; j < 6; j++) {
        if (i+j < line.length()) {
          if (line.charAt(i+j) != TAB && line.charAt(i+j) != ENTER && line.charAt(i+j) != RETURN && line.charAt(i+j) != ';') {
            c += line.charAt(i+j);
          } else {
            i += j;
            break;
          }
        }
      }
      if (c.indexOf(TAB) == -1 && c.indexOf(RETURN) == -1 && c.indexOf(ENTER) == -1 && c.indexOf(";") == -1) {
        complete[ind][ty] = new Tile(c);
        ind++;
      }
      i++;
    }
    line = readLine(reader);
    ty++;
  }
  reset(reader);
  mark(endingReader, 9);
  for (int i = 0; i < 5; i++) {
    String str = readLine(endingReader);
    wordEnds[i] = str;
  }
  reset(endingReader);
  for (int x = 0; x < tileGroup.length; x++) {
    for (int y = 0; y < tileGroup[x].length/2 + 1; y++) {
      tileGroup[x][y] = new Tile(new PVector(width/2 - 400 + x * 100, height/2 - 350 + y * 50), "[ ]");
    }
    for (int y = tileGroup[x].length/2; y < tileGroup[x].length; y++) {
      tileGroup[x][y] = new Tile(new PVector(width/2 - 400 + x * 100, height/2 + 100 + (y - tileGroup.length/2 - 1) * 50), "[ ]");
    }
  }
  for (int x = 0; x < tiles.length/2 + 1; x++) {
    for (int y = 0; y < tiles[x].length; y++) {
      tiles[x][y] = new Tile(new PVector(100 + x*100, height/2 - 250 + y*50), complete[x][y].getVal());
    }
  }
  for (int x = tiles.length/2; x < tiles.length; x++) {
    for (int y = 0; y < tiles[x].length; y++) {
      tiles[x][y] = new Tile(new PVector(width - 500 + (x - tiles.length/2) * 100, height/2 - 250 + y*50), complete[x][y].getVal());
    }
  }
}

public void draw() {
  background(127);
  for (Tile[] t1 : tileGroup) {
    for (Tile t : t1) {
      t.display();
    }
  }
  for (Tile[] t1 : tiles) {
    for (Tile t : t1) {
      t.display();
    }
  }
  fill(0);
  rect(width/2 - 100, height/2 - 50, 200, 100);
  fill(255);
  textSize(50);
  text("check", width/2 - 75, height/2 + 20);
}

public void mousePressed() {
  if (mouseX > 100 && mouseX < 500 && mouseY > height/2 - 250 && mouseY < height/2 + 250) {
    xSelect = (mouseX - 100) / 100;
    ySelect = (mouseY - (height/2 - 250)) / 50;
    if (tiles[xSelect][ySelect].pos.x != (float) ((int) mouseX / 100) * 100 && tiles[xSelect][ySelect].pos.y != (float) ((int) mouseY / 50) * 50) {
      xSelect = -1;
      ySelect = -1;
    }
  } else if (mouseX > width - 500 && mouseX < width - 100 && mouseY > height/2 - 250 && mouseY < height/2 + 250) {
    xSelect = (mouseX - (width - 500)) / 100 + tiles.length / 2;
    ySelect = (mouseY - (height/2 - 250)) / 50;
    if (tiles[xSelect][ySelect].pos.x != (float) ((int) mouseX / 100) * 100 + 20 && tiles[xSelect][ySelect].pos.y != (float) ((int) mouseY / 50) * 50 - 10) {
      xSelect = -1;
      ySelect = -1;
    }
  } else if (mouseX > width/2 - 400 && mouseX < width/2 + 400 && mouseY > height/2 - 350 && mouseY < height/2 - 100) {
    xSelect = (mouseX - (width/2 - 400)) / 100;
    ySelect = (mouseY - (height/2 - 350)) / 50;
    if (!tileGroup[xSelect][ySelect].val.equals("[ ]")) {
      int[] tileIndex = getTile(tiles, tileGroup[xSelect][ySelect]);
      tileGroup[xSelect][ySelect].val = "[ ]";
      xSelect = tileIndex[0];
      ySelect = tileIndex[1];
    } else {
      xSelect = -1;
      ySelect = -1;
    }
  } else if (mouseX > width/2 - 400 && mouseX < width/2 + 400 && mouseY > height/2 + 100 && mouseY < height/2 + 350) {
    xSelect = (int) (mouseX - (width/2 - 400)) / 100;
    ySelect = (int) (mouseY - (height/2 + 100)) / 50 + tileGroup.length / 2 + 1;
    if (!tileGroup[xSelect][ySelect].val.equals("[ ]")) {
      int[] tileIndex = getTile(tiles, tileGroup[xSelect][ySelect]);
      tileGroup[xSelect][ySelect].val = "[ ]";
      xSelect = tileIndex[0];
      ySelect = tileIndex[1];
    } else {
      xSelect = -1;
      ySelect = -1;
    }
  }
  if (xSelect > -1 && ySelect > -1) {
    tiles[xSelect][ySelect].setSelect(true);
  }
  if (!isSelected) {
    if (mouseX > width/2 - 100 && mouseX < width/2 + 100 && mouseY > height/2 - 50 && mouseY < height/2 + 50) {
      ArrayList<int[]> incorrect = checkCorrect();
      for (int i = 0; i < incorrect.size(); i++) {
        tiles[incorrect.get(i)[0]][incorrect.get(i)[1]].c = incorrect.get(i)[2];
      }
    }
  }
}

public void mouseReleased() {
  if (mouseX > width/2 - 400 && mouseX < width/2 + 400 && mouseY > height/2 - 350 && mouseY < height/2 - 100 && xSelect > -1 && ySelect > -1) {
    Tile select = tileGroup[(int) (mouseX - (width/2 - 400)) / 100][(int) (mouseY - (height/2 - 350)) / 50];
    if (select.val.equals("[ ]")) {
      tiles[xSelect][ySelect].pos.set(select.pos);
    } else {
      tiles[xSelect][ySelect].pos.set(select.pos);
      int[] ind = getTile(tiles, select);
      if (ind[0] < tiles.length/2) {
        tiles[ind[0]][ind[1]].pos.set(100 + ind[0] * 100, height/2 - 250 + ind[1] * 50);
      } else {
        tiles[ind[0]][ind[1]].pos.set(width - 500 + (ind[0] - tiles.length/2) * 100, height/2 - 250 + ind[1]*50);
      }
    }
    select.val = tiles[xSelect][ySelect].val;
  } else if (mouseX > width/2 - 400 && mouseX < width/2 + 400 && mouseY > height/2 + 100 && mouseY < height/2 + 350 && xSelect > -1 && ySelect > -1) {
    Tile select = tileGroup[(int) (mouseX - (width/2 - 400)) / 100][(int) (mouseY - (height/2 + 100)) / 50 + tiles[0].length/2];
    if (select.val.equals("[ ]")) {
      tiles[xSelect][ySelect].pos.set(select.pos);
    } else {
      tiles[xSelect][ySelect].pos.set(select.pos);
      int[] ind = getTile(tiles, select);
      if (ind[0] < tiles.length/2) {
        tiles[ind[0]][ind[1]].pos.set(100 + ind[0] * 100, height/2 - 250 + ind[1] * 50);
      } else {
        tiles[ind[0]][ind[1]].pos.set(width - 500 + (ind[0] - tiles.length/2) * 100, height/2 - 250 + ind[1]*50);
      }
    }
    select.val = tiles[xSelect][ySelect].val;
  } else if (xSelect > -1 && ySelect > -1) {
    if (xSelect < tiles.length/2) {
      tiles[xSelect][ySelect].pos.set(100 + xSelect * 100, height/2 - 250 + ySelect * 50);
    } else {
      tiles[xSelect][ySelect].pos.set(width - 500 + (xSelect - tiles.length/2) * 100, height/2 - 250 + ySelect * 50);
    }
  }
  if (xSelect > -1 && ySelect > -1) {
    tiles[xSelect][ySelect].setSelect(false);
    tileGroup[xSelect][ySelect].setSelect(false);
    xSelect = -1;
    ySelect = -1;
  }
}

public int[] getTile(Tile[][] ta, Tile t) {
  for (int i = 0; i < ta.length; i++) {
    for (int j = 0; j < ta[i].length; j++) {
      if (ta[i][j].equals(t)) {
        return new int[] {i, j};
      }
    }
  }
  return new int[] {-1, -1};
}

public ArrayList<int[]> checkCorrect() {
  ArrayList<int[]> output = new ArrayList<int[]>();
  for (int x = 0; x < tileGroup.length; x++) {
    for (int y = 0; y < tileGroup[x].length; y++) {
      if (!tileGroup[x][y].val.equals(complete[x][y].val)) {
        if ((tiles[x][y].pos.x > width/2 - 400 && tiles[x][y].pos.x < width/2 + 400 &&
          tiles[x][y].pos.y > height/2 - 350 && tiles[x][y].pos.y < height/2 - 100) ||
          (tiles[x][y].pos.x > width/2 - 400 && tiles[x][y].pos.x < width/2 + 400 &&
          tiles[x][y].pos.y > height/2 + 100 && tiles[x][y].pos.y < height/2 + 350)) {
          output.add(new int[] {x, y, color(255, 0, 0)});
        }
      } else {
        output.add(new int[] {x, y, color(0, 255, 0)});
      }
    }
  }
  return output;
}

public String readLine(BufferedReader reader) {
  try {
    return reader.readLine();
  } 
  catch (Exception e) {
    return "";
  }
}

public void reset(BufferedReader reader) {
  try {
    reader.reset();
  } 
  catch (Exception e) {
    System.out.println(e);
  }
}

public void mark(BufferedReader reader, int n) {
  try {
    reader.mark(n);
  } 
  catch (Exception e) {
    System.out.println(e);
  }
}
class Tile {
  PVector pos;
  String val = "";
  int c = 255;
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

  public void setPos(PVector pos) {
    setPos(pos.x, pos.y);
  }

  public void setPos(float x, float y) {
    this.pos.set(x, y);
  }

  public void setVal(String val) {
    this.val = val;
  }

  public void setSelect(boolean set) {
    this.select = set;
    isSelected = set;
  }

  public String getVal() {
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

  public void display() {
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

  public String toString() {
    return getVal();
  }

  public boolean equals(Tile other) {
    return other.pos.x == this.pos.x && other.pos.y == this.pos.y && other.val.equals(this.val);
  }
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "noun_chart" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
