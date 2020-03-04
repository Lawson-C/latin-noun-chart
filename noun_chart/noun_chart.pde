import java.io.*;

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

void setup() {
  fullScreen();
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
      String s = "";
      for (int j = 0; j < 6; j++) {
        if (i+j < line.length()) {
          if (line.charAt(i+j) != TAB && line.charAt(i+j) != ENTER && line.charAt(i+j) != RETURN && line.charAt(i+j) != ';') {
            s += line.charAt(i+j);
          } else {
            i += j;
            break;
          }
        }
      }
      if (s.indexOf(TAB) == -1 && s.indexOf(RETURN) == -1 && s.indexOf(ENTER) == -1 && s.indexOf(";") == -1) {
        complete[ind][ty] = new Tile(s);
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

void draw() {
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

void mousePressed() {
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

void mouseReleased() {
  if (mouseX > width/2 - 400 && mouseX < width/2 + 400 && mouseY > height/2 - 350 && mouseY < height/2 - 100 && xSelect > -1 && ySelect > -1) {
    Tile select = tileGroup[(int) (mouseX - (width/2 - 400)) / 100][(int) (mouseY - (height/2 - 350)) / 50];
    if (select.val.equals("[ ]")) {
      tiles[xSelect][ySelect].pos.set(select.pos);
      select.val = tiles[xSelect][ySelect].undoVal();
    } else {
      tiles[xSelect][ySelect].pos.set(select.pos);
      select.val = tiles[xSelect][ySelect].undoVal();
      int[] ind = getTile(tiles, select);
      if (ind[0] < tiles.length/2) {
        tiles[ind[0]][ind[1]].pos.set(100 + ind[0] * 100, height/2 - 250 + ind[1] * 50);
      } else {
        tiles[ind[0]][ind[1]].pos.set(width - 500 + (ind[0] - tiles.length/2) * 100, height/2 - 250 + ind[1]*50);
      }
    }
    select.val = tiles[xSelect][ySelect].undoVal();
  } else if (mouseX > width/2 - 400 && mouseX < width/2 + 400 && mouseY > height/2 + 100 && mouseY < height/2 + 350 && xSelect > -1 && ySelect > -1) {
    Tile select = tileGroup[(int) (mouseX - (width/2 - 400)) / 100][(int) (mouseY - (height/2 + 100)) / 50 + tiles[0].length/2];
    if (select.val.equals("[ ]")) {
      tiles[xSelect][ySelect].pos.set(select.pos);
      select.val = tiles[xSelect][ySelect].undoVal();
    } else {
      tiles[xSelect][ySelect].pos.set(select.pos);
      select.val = tiles[xSelect][ySelect].undoVal();
      int[] ind = getTile(tiles, select);
      if (ind[0] < tiles.length/2) {
        tiles[ind[0]][ind[1]].pos.set(100 + ind[0] * 100, height/2 - 250 + ind[1] * 50);
      } else {
        tiles[ind[0]][ind[1]].pos.set(width - 500 + (ind[0] - tiles.length/2) * 100, height/2 - 250 + ind[1]*50);
      }
    }
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

int[] getTile(Tile[][] ta, Tile t) {
  for (int i = 0; i < ta.length; i++) {
    for (int j = 0; j < ta[i].length; j++) {
      if (ta[i][j].equals(t)) {
        return new int[] {i, j};
      }
    }
  }
  return new int[] {-1, -1};
}

ArrayList<int[]> checkCorrect() {
  ArrayList<int[]> output = new ArrayList<int[]>();
  for (int x = 0; x < tileGroup.length; x++) {
    for (int y = 0; y < tileGroup[x].length; y++) {
      if ((tiles[x][y].pos.x >= width/2 - 400 && tiles[x][y].pos.x <= width/2 + 400 &&
        tiles[x][y].pos.y >= height/2 - 350 && tiles[x][y].pos.y <= height/2 - 100) ||
        (tiles[x][y].pos.x >= width/2 - 400 && tiles[x][y].pos.x <= width/2 + 400 &&
        tiles[x][y].pos.y >= height/2 + 100 && tiles[x][y].pos.y <= height/2 + 350)) {
        System.out.println("incp: " + tileGroup[x][y].undoVal());
        System.out.println("cp: " + complete[x][y].undoVal());
        if (!tileGroup[x][y].undoVal().equals(complete[x][y].undoVal())) {
          output.add(new int[] {x, y, color(255, 0, 0)});
        } else {
          output.add(new int[] {x, y, color(0, 255, 0)});
        }
      } else {
        output.add(new int[] {x, y, color(255)});
      }
    }
  }
  return output;
}

String readLine(BufferedReader reader) {
  try {
    return reader.readLine();
  } 
  catch (Exception e) {
    return "";
  }
}

void reset(BufferedReader reader) {
  try {
    reader.reset();
  } 
  catch (Exception e) {
    System.out.println(e);
  }
}

void mark(BufferedReader reader, int n) {
  try {
    reader.mark(n);
  } 
  catch (Exception e) {
    System.out.println(e);
  }
}
