import java.io.*;

Tile[][] tileGroup = new Tile[8][10];
Tile[][] complete = new Tile[8][10];
Tile[][] tiles = new Tile[8][10];

File endings = new File("C:\\Users\\lawso\\Desktop\\Processing Projects\\noun_chart\\data\\endings");
File letters = new File("C:\\Users\\lawso\\Desktop\\Processing Projects\\noun_chart\\data\\conversion");
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
    System.out.println("x: " + xSelect + " y: " + ySelect);
    System.out.println(tileGroup[xSelect][ySelect]);
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
    ySelect = (int) (mouseY - (height/2 + 100)) / 50 + tileGroup.length / 2;
    System.out.println("x: " + xSelect + " y: " + ySelect);
    System.out.println(tileGroup[xSelect][ySelect]);
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
    tiles[xSelect][ySelect].select = true;
  }
}

void mouseReleased() {
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
    tiles[xSelect][ySelect].select = false;
    tileGroup[xSelect][ySelect].select = false;
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

int[][] checkCorrect() {
  ArrayList<Integer[]> output = new ArrayList<Integer[]>();
  for (int x = 0; x < tileGroup.length; x++) {
    for (int y = 0; y < tileGroup[x].length; y++) {
      if (!tileGroup[x][y].val.equals(complete[x][y].val)) {
        output.add(new Integer[] {x, y});
      }
    }
  }
  return (int[][]) output.toArray();
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
