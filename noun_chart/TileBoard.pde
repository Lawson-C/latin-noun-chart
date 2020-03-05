class TileBoard {
  private int[] x = new int[2], y = new int[2];
  private int xLen, yLen;

  TileBoard(int x, int y, int x2, int y2) {
    this.x = new int[] {x, x2};
    this.y = new int[] {y, y2};
    this.xLen = Tile.xSize*4;
    this.yLen = Tile.ySize*5;
  }

  int getX(int i) {
    return this.x[i];
  }
  
  int getY(int i) {
    return this.y[i];
  }
  
  int getXLen() {
    return xLen;
  }
  
  int getYLen() {
    return yLen;
  }
}
