import java.io.*;

TileBoard slots;
TileBoard options;

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
  slots = new TileBoard(width/2 - 4*Tile.xSize, 
    height/2 - 100 - 5*Tile.ySize, 
    width/2 - 4*Tile.xSize, 
    height/2 + 100, 
    8, 
    5);
  options = new TileBoard(100, 
    height/2 - Tile.ySize*5, 
    width - 5*Tile.xSize, 
    height/2 - Tile.ySize*5, 
    4, 
    10);
  System.out.println(slots);
  System.out.println(options);
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
    System.out.println(str);
  }
  reset(endingReader);
  for (int x = 0; x < tileGroup.length; x++) {
    for (int y = 0; y < tileGroup[x].length/2 + 1; y++) {
      tileGroup[x][y] = new Tile(new PVector(slots.getX(0) + x * Tile.xSize, slots.getY(0) + y * Tile.ySize), "[ ]");
    }
    for (int y = tileGroup[x].length/2; y < tileGroup[x].length; y++) {
      tileGroup[x][y] = new Tile(new PVector(slots.getX(1) + x * Tile.xSize, slots.getY(1) + (y - tileGroup.length/2 - 1) * Tile.ySize), "[ ]");
    }
  }
  for (int x = 0; x < tiles.length/2 + 1; x++) {
    for (int y = 0; y < tiles[x].length; y++) {
      tiles[x][y] = new Tile(new PVector(options.getX(0) + x * Tile.xSize, options.getY(0) + y * Tile.ySize), complete[x][y].getVal());
    }
  }
  for (int x = tiles.length/2; x < tiles.length; x++) {
    for (int y = 0; y < tiles[x].length; y++) {
      tiles[x][y] = new Tile(new PVector(options.getX(1) + (x - tiles.length/2) * Tile.xSize, options.getY(1) + y * Tile.ySize), complete[x][y].getVal());
    }
  }
  for (int x = 0; x < tiles.length; x++) {
    for (int y = 0; y < tiles[x].length; y++) {
      int randX = (int) random(0, tiles.length);
      while (randX == x) {
        randX = (int) random(0, tiles.length);
      }
      int randY = (int) random(0, tiles[x].length);
      while (randY == y) {
        randY = (int) random(0, tiles[x].length);
      }
      String temp = tiles[x][y].val;
      tiles[x][y].val = tiles[randX][randY].val;
      tiles[randX][randY].val = temp;
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
  rect(width/2 - 100, height - 150, 200, 100);
  fill(255);
  textSize(50);
  text("check", width/2 - 75, height - 80);
}

void mousePressed() {
  if (mouseX > options.getX(0) && mouseX < options.getX(0) + options.getXLen() && mouseY > options.getY(0) && mouseY < options.getY(0) + options.getYLen()) {
    xSelect = (mouseX - options.getX(0)) / Tile.xSize;
    ySelect = (mouseY - options.getY(0)) / Tile.ySize;
    if (tiles[xSelect][ySelect].pos.x != (float) ((int) mouseX / Tile.xSize) * Tile.xSize && tiles[xSelect][ySelect].pos.y != (float) ((int) mouseY / Tile.ySize) * Tile.ySize) {
      xSelect = -1;
      ySelect = -1;
    }
  } else if (mouseX > options.getX(1) && mouseX < options.getX(1) + options.getXLen() && mouseY > options.getY(1) && mouseY < options.getY(1) + options.getYLen()) {
    xSelect = (mouseX - options.getX(1)) / Tile.xSize + 4;
    ySelect = (mouseY - options.getY(1)) / Tile.ySize;
    if (tiles[xSelect][ySelect].pos.x != (float) ((int) mouseX / Tile.xSize) * Tile.xSize + 20 && tiles[xSelect][ySelect].pos.y != (float) ((int) mouseY / Tile.ySize) * Tile.ySize - 10) {
      xSelect = -1;
      ySelect = -1;
    }
  } else if (mouseX > slots.getX(0) && mouseX < slots.getX(0) + slots.getXLen() && mouseY > slots.getY(0) && mouseY < slots.getY(0) + slots.getYLen()) {
    xSelect = (mouseX - slots.getX(0)) / Tile.xSize;
    ySelect = (mouseY - slots.getY(0)) / Tile.ySize;
    if (!tileGroup[xSelect][ySelect].val.equals("[ ]")) {
      int[] tileIndex = getTile(tiles, tileGroup[xSelect][ySelect]);
      tileGroup[xSelect][ySelect].val = "[ ]";
      xSelect = tileIndex[0];
      ySelect = tileIndex[1];
    } else {
      xSelect = -1;
      ySelect = -1;
    }
  } else if (mouseX > slots.getX(1) && mouseX < slots.getX(1) + slots.getXLen() && mouseY > slots.getY(1) && mouseY < slots.getY(1) + slots.getYLen()) {
    xSelect = (int) (mouseX - slots.getX(1)) / Tile.xSize;
    ySelect = (int) (mouseY - slots.getY(1)) / Tile.ySize + 5;
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
  if (!isSelected && mouseX > width/2 - 100 && mouseX < width/2 + 100 && mouseY > height - 150 && mouseY < height - 50) {
    ArrayList<int[]> incorrect = checkCorrect();
    for (int i = 0; i < incorrect.size(); i++) {
      tiles[incorrect.get(i)[0]][incorrect.get(i)[1]].c = incorrect.get(i)[2];
    }
  }
}

void mouseReleased() {
  if (mouseX > slots.getX(0) && mouseX < slots.getX(0) + slots.getXLen() && mouseY > slots.getY(0) && mouseY < slots.getY(0) + slots.getYLen() && xSelect > -1 && ySelect > -1) {
    Tile select = tileGroup[(int) (mouseX - slots.getX(0)) / Tile.xSize][(int) (mouseY - slots.getY(0)) / Tile.ySize];
    if (select.val.equals("[ ]")) {
      tiles[xSelect][ySelect].pos.set(select.pos);
      select.setVal(tiles[xSelect][ySelect].getVal());
    } else {
      tiles[xSelect][ySelect].pos.set(select.pos);
      select.setVal(tiles[xSelect][ySelect].getVal());
      int[] ind = getTile(tiles, select);
      System.out.println(ind[0] + ", " + ind[1]);
      if (ind[0] < tiles.length/2) {
        tiles[ind[0]][ind[1]].pos.set(options.getX(0) + ind[0] * Tile.xSize, options.getY(0) + ind[1] * Tile.ySize);
      } else {
        tiles[ind[0]][ind[1]].pos.set(options.getX(1) + (ind[0] - 4) * Tile.xSize, options.getY(1) + ind[1] * Tile.ySize);
      }
    }
  } else if (mouseX > slots.getX(1) && mouseX < slots.getX(1) + slots.getXLen() && mouseY > slots.getY(1) && mouseY < slots.getY(1) + slots.getYLen() && xSelect > -1 && ySelect > -1) {
    Tile select = tileGroup[((int) mouseX - slots.getX(1)) / Tile.xSize][((int) mouseY - slots.getY(1)) / Tile.ySize + 5];
    if (select.getVal().equals("[ ]")) {
      tiles[xSelect][ySelect].pos.set(select.pos);
      select.setVal(tiles[xSelect][ySelect].getVal());
    } else {
      tiles[xSelect][ySelect].pos.set(select.pos);
      select.setVal(tiles[xSelect][ySelect].getVal());
      int[] ind = getTile(tiles, select);
      if (ind[0] < tiles.length/2) {
        tiles[ind[0]][ind[1]].pos.set(options.getX(0) + ind[0] * Tile.xSize, options.getY(0) + ind[1] * Tile.ySize);
      } else {
        tiles[ind[0]][ind[1]].pos.set(options.getX(1) + (ind[0] - 4) * Tile.xSize, options.getY(1) + ind[1] * Tile.ySize);
      }
    }
  } else if (xSelect > -1 && ySelect > -1) {
    if (xSelect < tiles.length/2) {
      tiles[xSelect][ySelect].pos.set(options.getX(0) + xSelect * Tile.xSize, options.getY(0) + ySelect * Tile.ySize);
    } else {
      tiles[xSelect][ySelect].pos.set(options.getX(1) + xSelect * Tile.xSize, options.getY(1) + ySelect * Tile.ySize);
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
      if ((tiles[x][y].pos.x >= slots.getX(0) && tiles[x][y].pos.x < slots.getX(0) + slots.getXLen() &&
        tiles[x][y].pos.y >= slots.getY(0) && tiles[x][y].pos.y < slots.getY(0) + slots.getYLen()) ||
        (tiles[x][y].pos.x >= slots.getX(1) && tiles[x][y].pos.x < slots.getX(1) + slots.getXLen() &&
        tiles[x][y].pos.y >= slots.getY(1) && tiles[x][y].pos.y < slots.getY(1) + slots.getYLen())) {
        System.out.println(tileGroup[x][y].undoVal());
        System.out.println(complete[x][y].undoVal());
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
