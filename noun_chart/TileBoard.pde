class TileBoard {
  private int[] x = new int[2], y = new int[2];
  private int xLen, yLen;

  TileBoard(int x, int y, int x2, int y2, int xSize, int ySize) {
    this.x = new int[] {x, x2};
    this.y = new int[] {y, y2};
    this.xLen = Tile.xSize * xSize;
    this.yLen = Tile.ySize * ySize;
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

  String toString() {
    return "{ x: { " + this.x[0] + ", " + this.x[1] + " }, y: { "
      + this.y[0] + ", " + this.y[1] + " } }, { xLen: "
      + this.xLen + ", yLen: " + yLen + " }";
  }
}
