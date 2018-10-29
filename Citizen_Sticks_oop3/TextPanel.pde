/*
_-_-_-_-_-_-_-_-_-_-_-_
 Onscreen Data readout
-_-_-_-_-_-_-_-_-_-_-_-
*/

/*
TO-DO
-add font stylings
-maybe adjust positions relative to eachother 
*/

class TextPanel {
  int x,y;
  color c;
  StringBuilder redStrBuilder = new StringBuilder();
  StringBuilder greenStrBuilder = new StringBuilder();
  StringBuilder blueStrBuilder = new StringBuilder();
  
    TextPanel(int _x, int _y ) {
      x = _x;
      y = _y+14;
    }
    
    void buildString(float[][] r, float[][] g, float[][] b, color c ) {  
      fill(c);
      
      float participants = 18;
      float total = r.length + g.length + b.length;
      float percent = total*100/participants;
      
      //format the percentage string to 2 decimal places
      text("Participation: "+String.format("%.2f", percent)+"%", x,y);
      text( "Red: "+r.length, x, y+40);
      text( "Green: "+g.length, x+120, y+40);
      text( "Blue: "+b.length, x+240, y+40);
      
      for(int i=0; i<r.length; i++) {
        for( int j=0; j<r[i].length; j++) {
          if( j==r[i].length-1){
            redStrBuilder.append((int)r[i][j]+";\n");
          }else{
            redStrBuilder.append((int)r[i][j]+",");
          }
        }
      }
      
      for(int i=0; i<g.length; i++) {
        for( int j=0; j<g[i].length; j++) {
          if( j==g[i].length-1){
            greenStrBuilder.append((int)g[i][j]+";\n");
          }else{
            greenStrBuilder.append((int)g[i][j]+",");
          }
        }
      }
      
      for(int i=0; i<b.length; i++) {
        for( int j=0; j<b[i].length; j++) {
          if( j==b[i].length-1){
            blueStrBuilder.append((int)b[i][j]+";\n");
          }else{
            blueStrBuilder.append((int)b[i][j]+",");
          }
        }
      }
      
      String redString = redStrBuilder.toString();
      String greenString = greenStrBuilder.toString();
      String blueString = blueStrBuilder.toString();
      text( redString, x, y+80);
      text( greenString, x+120, y+80);
      text( blueString, x+240, y+80);
      //clear the stringBuilder object for next cycle
      redStrBuilder.setLength(0);
      greenStrBuilder.setLength(0);
      blueStrBuilder.setLength(0); 
    }
  
  void pushToScreen() {
    buildString(dsRed.data, dsGreen.data, dsBlue.data, color(255,255,255));
  }
    
}
