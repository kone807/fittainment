import processing.serial.*;
import cc.arduino.*;
Arduino arduino;
import processing.sound.*;

SoundFile song;

Square square;
ArrayList<pSquare> pSquares = new ArrayList<pSquare>();
int score2=0 ;
int highScore2=0;
color[] colors = {color(254, 212, 7), color(252, 221, 35), 
  color(247, 231, 73), color(245, 231, 111), 
  color(247, 198, 168), color(251, 160, 196), 
  color(254, 125, 220)};
int colorIndex;
boolean colorDir;
int score3=0;
int highscore3=0;
int score=0;
boolean reset = false;
int tileW, tileH;

PFont font;

int[][] tiles = new int[5][2];

color[] colours = { color(0), color(0, 127, 255), color(0, 255, 127), color(255, 10, 10) };
   
int scrollY;
float scrollSpeed;
int startingSpeed = 2;
float speedIncrease = 0.0005;
int maxSpeed = 25;
PImage main,game1,game2,game3;
boolean started = false;
boolean lost = false;
boolean lostClicked = false,losex=false,losey=false, losez=false, left=true,right=true;
int highscore=0;
int score1=0;
boolean value=true,start=true,value3=true,value2=true,screen1=true;
boolean s1=false,s2=false;
Game g;//build
boolean move=false;//build
int choice=0;
void setup() {
  
   arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(0, Arduino.INPUT);
  arduino.pinMode(1, Arduino.INPUT);
  arduino.pinMode(2, Arduino.INPUT);
  arduino.pinMode(3, Arduino.INPUT);
  arduino.pinMode(4, Arduino.INPUT);
  
  song = new SoundFile(this, "song.wav");
  song.loop();
  
  font=createFont("font.ttf",40);
  
  background(10, 40, 40);
  bid = 0;
  size(1800, 800);
  square = new Square();
  g = new Game();
  resetGame();
  square.x = 0;
  square.y = 760;
  square.wid = 900;
  score = 0;
  highscore = 0;
  noStroke();
  tileW = width / 6;
  tileH = height /4 -10;
  main=loadImage("main.jpg");
  game1=loadImage("game1.jpg");
  game2=loadImage("game2.jpg");
  game3=loadImage("game3.jpg");
}

void draw() {
  backgrnd();
  if(start){
  background(main);
  
  fill(0);
  fontfunc();
  
  if(arduino.analogRead(0)>900){
    choice=1;
    score1 = 0;
    losex=false;
    s1=true;
    start=false;
    screen1=true;
    background(game1);}
   else if(arduino.analogRead(1)>900 && arduino.analogRead(2)>900){

    //stroke(0,0,100);
    choice=2;
    score2=0;
    losey=false;
    s1=true;
    start=false;
}
  else if(arduino.analogRead(3)>900 && arduino.analogRead(4)>900){
    //stroke(0,0,100);
    choice=3;  
    s1=true;
    scrollY=0;
    start=false;
    losez=false;
}
}
    
  else if(start==false && choice==1 ){
    background(game1);
    if(screen1==true){
      }
 else{
  for (pSquare p : pSquares) {
    p.display();
  }
  if(!losex){
  square.update();
  square.display();
  showScores();}
  else if(losex){
  drawLost();
}
}


   
if(arduino.analogRead(0)>900 && value==true && start==false && choice==1 && screen1==false){
    if (square.velocity < 15) {
    square.velocity += 0.5;
  }

  color colorAux = colors[colorIndex];
  if (colorDir) {
    colorIndex++;
  } else {
    colorIndex--;
  }
  if (colorIndex == -1) {
    colorIndex = 1;
    colorDir = true;
  } else if (colorIndex == 7) {
    colorIndex = 5;
    colorDir = false;
  }
  square.click(colorAux);
  if(!losex)
  score1++;
    value=false;
  }

  if(arduino.analogRead(0)>900 && screen1==true)
     screen1=false;
     
   if(arduino.analogRead(0)<900)
  value=true;
}
else if(start==false && choice==2){
    background(game2);
    if(!losey){
  g.play();
   
}
  else if(losey)
    drawLost();
    
    if(arduino.analogRead(1)<900 && arduino.analogRead(2)<900 && choice==2)
    move=true;
    
   if(arduino.analogRead(1)>900 && arduino.analogRead(2)>900 && choice==2)
    move=false;
    
    
}
else if(start==false && choice==3){
 
      if (!losez) {
      background(game3);
        drawGame();
    } else if(losez){
        drawLost();
        resetGame();
    }
     
  
  if(arduino.analogRead(1)>900 && arduino.analogRead(2)>900 && value2==true){
    for (int r = tiles.length-1; r >=0; r--) {
       if(tiles[r][0]==2 || tiles[r][1]==2)
          continue;
       else if(tiles[r][0]==1)
        { tagTile(tiles[r], 0);
         break;}
       else if(tiles[r][0]==0){
           lose();
        losez=true;   
       }
     
    
  }
  value2=false;
}
 if(arduino.analogRead(1)<900 && arduino.analogRead(2)<900)
   value2=true;
   
  if(arduino.analogRead(3)>900 && arduino.analogRead(4)>900 && value3==true && choice==3 ){
    for (int r = tiles.length-1; r >=0; r--) {
       if(tiles[r][0]==2 || tiles[r][1]==2)
          continue;
       else if(tiles[r][1]==1){
         tagTile(tiles[r], 1);
         break;}
       else if(tiles[r][1]==0)
        {   lose();
        losez=true;}
  }
  value3=false;
  }
  if(arduino.analogRead(3)<900 && arduino.analogRead(4)<900)
    value3=true;
    
 
   
}}

void keyPressed()
{ } 

void keyReleased()
{
  if(key==ENTER )
  value=true;
  
  
} 
void fontfunc()
{
  textFont(font, 40);
  text("Press Hand", 10, 200);
  text("Gripper for", 10, 260);
  text("Stack the Tiles", 10, 310);
  text("Step on Left", 624, 330);
  text("Platform for", 620, 390);
  text("Naruto Jump!", 620, 450);
  text("Step on Right", 1550, 130);
  text("Platform for", 1550, 190);
  text("Konoha Tiles", 1550, 250);
  textSize(100);
  text("FITTAINMENT", 570, 750);
  
} 
class Square {
  float x;
  float y;
  float wid;
  float velocity = 5;
  boolean direction;
  void display() {
    fill(colors[colorIndex]);
    rect(x, y, wid, 40);
  }
  void update() {
    if (x - velocity <= 0) {
      direction = true;
    }
    if (x + velocity + wid >= width) {
      direction = false;
    }
    if (direction) {
      x += velocity;
    } else {
      x -= velocity;
    }
  }
  void click(color colour) {
    if(!losex){
    boolean reset = false;
    pSquare newSquare = new pSquare();
    newSquare.colour = colour;
    if (pSquares.size() > 0) {
      pSquare prev = pSquares.get(pSquares.size() - 1);
      if (x > prev.x) {
        if (x > prev.x + prev.wid) {
            losex=true;
            
            
            restart();

          reset=true;
        } else {
          newSquare.wid = dist(x, 0, prev.x + prev.wid, 0);
          wid = dist(x, 0, prev.x + prev.wid, 0);
          newSquare.x = x;
        }
      } else if (x < prev.x) {
        if (x + wid < prev.x) {
          restart();
         // reset = true;
        } else {
          newSquare.wid = dist(prev.x, 0, x + wid, 0);
          wid = dist(prev.x, 0, x + wid, 0);
          newSquare.x = prev.x;
        }
      } else {
        newSquare.wid = wid + 30;
        newSquare.x = x - 15;
        wid += 30;
        velocity = 6.5;
        if(!losex)
        score1 += 4;
        newSquare.perfect = true;
      }
    } else {
      newSquare.wid = wid;
      newSquare.x = x;
    }
    if (!reset) {
      newSquare.y = y;
      pSquares.add(newSquare);
      if (pSquares.size() == 8) {
        pSquares.remove(pSquares.get(0));
      }
      if (y >=500) {
        y -= 40;
      } else {
        for (pSquare p : pSquares) {
          p.y += 40;
        }
      }
    }
    }
  }
}
class pSquare {
  float x;
  float y;
  float wid;
  color colour;
  boolean perfect;
  void display() {
    fill(colour);
    rect(x, y, wid, 40);
    if (perfect){
      fill(0, 100);
     star(x + wid/2, y + 20, 7, 15, 5);  
    }
  }
}

void restart() {
  losex=false;
  pSquares = new ArrayList<pSquare>();
  square.x = 0;
  square.y = 760;
  square.wid = 900;
  square.velocity = 5;
  if (score1 > highscore) {
    highscore = score1;
  }
  losex=true;
  

}

void backgrnd() {
  int[] c1 = {72, 132, 130};
  int[] c2 = {174, 211, 163};
  for (int i = 0; i < height; i++) {
    float t = 0.002 * i;
    float[] cIndex = new float[3];
    cIndex[0] = (1 - t) * c1[0] + t * c2[0];
    cIndex[1] = (1 - t) * c1[1] + t * c2[1];
    cIndex[2] = (1 - t) * c1[2] + t * c2[2];
    fill(cIndex[0] - 20, cIndex[1] - 20, cIndex[2] - 20);
    rect(0, i, width, 1);

  }
}

void showScores() {
  fill(255);
  textAlign(CENTER);
  
  textSize(45);
  text("Score: " + score1, width/2, 70);
  textSize(20);
  text("Highscore: " + highscore, width/2, 100);

}



void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a + radians(45)) * radius2;
    float sy = y + sin(a + radians(45)) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle + radians(45)) * radius1;
    sy = y + sin(a+halfAngle + radians(45)) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

boolean isBetween(float x , float l ,float r){
    return ( x>= l && x<=r);
}
int bid ;

class Building{
 
  PVector pos;
  float w,h;
 
  float velocity;
 
  color fill_ , stroke_;
  int id;
 
  Building(float x , float y , float w_ ,float v  ){
   
    pos = new PVector(x,y);  
    w = w_*3/4;
    h = (height - y + 20);
    velocity = v;

    int c = (int)random(0,100);
    fill_ = color(c,100,100);
    stroke_ = color(90,60,22);
    id = ++bid ;
 
  }
 
  void display(){
   
      if(pos.x<width){
        fill(fill_);
        stroke(stroke_);
        rect(pos.x , pos.y ,w,h);
      }
  }
 
  void update(){
   
     pos.x -= velocity/frameRate ;
  }
 
  void run(){

    update();
    display();
  }

}
class Game{

  Engine e;
  int seen ;

  Game(){
    e = new Engine();
    seen = 0;
    highScore2 = 0;
  }

  void play(){
    if(seen==0){
      //strartscren
      startScreen();
    }
    else if(seen == 1){
      //install
      score = 0;
      e.clear();
      e.start();

      seen = 2;
    }
    else if(seen == 2){
      //play screen
      e.run();
      fill(0);
      textSize(50);
      text((int)score2,8*width/10, height / 10 );
      score2 ++;

      if(e.p.pos.y > height){
        seen = 3;
      }

  }
    else if(seen == 3){
      //end screen;
      seen=0;

      resetGame();
      endScreen();

    }

  }

  void startScreen(){

   
    fill(34,100,50);
    stroke(34,100,100);
    ellipse(width/2,height/2,height/2.5,height/2.5);
   
    stroke(0,0,100);
    fill(0,0,100);
    triangle(width/2 - 30, height/2 + 30 , width/2 -30 , height/2 -30 , width/2 +30, height/2);


      if(move)
        seen = 1;
   
  }

  void endScreen(){
      highScore2 = max(highScore2,score2);
      e.run();
      noStroke();
      fill(0,0,100,80);    
      rect(0,0,width,height);
      fill(0,0,0);
      text("High Score "+highScore2 , width/2, height - 50 );
     
      fill(34,100,50);
      stroke(34,100,100);
      ellipse(width/2,height/2 - 20,height/2.5,height/2.5);
   
      stroke(0,0,100);
      fill(0,0,100);
      triangle(width/2 - 30, height/2 + 30 -20 , width/2 -30 , height/2 -30 -20 , width/2 +30, height/2-20);

      if( dist(mouseX,mouseY,width/2,height/2-20) < height/5 ){
        stroke(34,100,100);
        fill(0,0,100);
        ellipse(width/2,height/2-20,height/2.5,height/2.5);
     
        stroke(34,100,100);
        fill(34,100,100);
        triangle(width/2 - 30, height/2 + 30-20 , width/2 -30 , height/2 -30-20 , width/2 +30, height/2-20);

      if(mousePressed)
        seen = 1;

    }

  }

}
class Engine {

  Player p;
  ArrayList<Building> b;
  float v, a , inv ;
  int minWidth, maxWidth, minHeight = 100, maxHeight = 150 ;
  float midLevel;

  int seen ;

  Engine() {

    p = new Player();
    b = new ArrayList<Building>();

    minWidth = 30*p.size/4 ;
    maxWidth = 40*p.size/4 ;

    midLevel = height/2;

    seen = 0 ;

    inv = width/4;
  }


  void start() {

    v = inv;
    a = 3;

    p.onReady();

    addBuilding(-10, midLevel, 1200);
    addBuilding();
    addBuilding();
    addBuilding();
    addBuilding();
  }

  void run() {

    int l = b.size();

    for (int i = 0; i < l; i++ ) {
      Building bl = b.get(i);
      bl.run();
      if (bl.pos.x + bl.w < -500) {
        addBuilding();

        b.remove(i);
      }
    }

    p.run();

    if (p.pos.y > height ) {
      seen = 2;
    }

    collision();

    v += a/frameRate ;
  }

  void clear(){
    b.clear();
  }


  void collision() {
    boolean flag = true;

    int l = b.size();

    for (int i = 0; i < l; i++) {

      Building bl = b.get(i);

      float px = p.pos.x;
      float py = p.pos.y;
      float pw = p.size;
      float bx = bl.pos.x;
      float by = bl.pos.y;
      float bw = bl.w;

      if (isBetween( px, bx, bx + bw) || isBetween( px + pw, bx, bx + bw)  ) {
        //Building is in scop
        if (isBetween(py+pw, by, by+10 )) {
          p.grounded = true;
          p.pos.y = by - pw ;
          flag = false;
          break;
        }
      } else {
        //building is not in scop
        continue ;
      }
    }//end of collision loop

    if (flag) {
      p.grounded = false;

    }
  }


  void addBuilding() {

    float x = b.get(b.size() - 1).pos.x + b.get(b.size() - 1).w + random( 5*p.size + sqrt(v) , 9*p.size + sqrt(v) );
    float y = random(midLevel - 80, midLevel + 80);
    float w = random( 30*p.size/4 + sqrt(v) , 40*p.size/4 + sqrt(v)  );

    b.add(new Building(x, y, w, v));
  }

  void addBuilding(float x, float y, float w) {
    b.add(new Building(x, y, w, v));
  }
}
class Player{

  PVector pos;
  int size;

  float gravity = 750;
  float velocity ; // = 0;

  float jumpVel = 375;
  float onAirJump = 605;

  boolean grounded = false ;
  int level;

  Player(){
    pos = new PVector(width/10,200);
    size = min(width,height)/15;
  }

  void onReady(){
    velocity = 0;
   pos.y=200;
  }
  void display(){

    pushStyle();

      stroke(0);
      fill(0);
     
      rect(pos.x,pos.y,size,size);
    popStyle();
  }

  void update(){

    velocity += gravity/frameRate ;
    if(grounded)velocity = 0;
    pos.y += velocity/frameRate ;

  }

  void run(){

    update();
    jump();
    display();
  }

  void jump(){

    if(move){

      if(grounded){
        pos.y -= 1;
        velocity = -jumpVel;
      }
      else{
        velocity -= onAirJump/frameRate;
      }

    }
  }

}
void resetGame() {
    setupTiles();
    losey=true;
    scrollY = 0;
    scrollSpeed = 0;
    lost = false;
    lostClicked = false;
}

void setupTiles() {
    for (int r = 0; r < tiles.length; r++) {
      if(r==4){
      tiles[r][0]=0;
      tiles[r][1]=1;
      }
      
      else
        randomInRow(r);
    }
}

void randomInRow(int r) {
    
    
    int rand = (int) (Math.random() * (tiles[0].length));
    for (int c = 0; c < tiles[r].length; c++) {
        if (c == rand) {
            tiles[r][c] = 1;
        } else {
            tiles[r][c] = 0;
        }
    }
    
}

void start() {
    started = true;
}

void lose() {
    lost = true;
    
}
void drawStart() {
    fill(colours[1]);
    textSize(width / 12);
    text("Welcome to Piano Tiles\n\nClick to begin", width / 2, height / 2);
}

void drawGame() {
    drawTiles();

    fill(colours[1]);
    textSize(100);
    float tY = textWidth("00") / 3;
    text(score3, width-50, tY);
    tY *= 2;

    fill(colours[2]);
    if (score > highscore) {
        fill(colours[3]);
    }
    textSize(width / 16);
    tY += textWidth("00") / 3;
    tY = height - textWidth("00") / 3;
    fill(colours[1]);
        
    scrollTiles();
}

void drawTiles() {
    int y = scrollY - tileH;
    for (int r = 0; r < tiles.length; r++) {
        int x = 625;
        for (int c = 0; c < tiles[r].length; c++) {
            if (tiles[r][c] == 1) {
                fill(250, 104, 0);
            } else if (tiles[r][c] == 2) {
                fill(180);
            } else {
                fill(255);
            }
            stroke(108, 255, 10);
            rect(x, y, tileW, tileH);
            
            x += tileW;
        }
        y += tileH;
    }
}

void scrollTiles() {
    if (scrollSpeed > 0) {
        scrollY += scrollSpeed;
        scrollSpeed = Math.min(maxSpeed, scrollSpeed + speedIncrease);
    }
    if(scrollY>=200)
    {
      lose();
      losez=true;
      started=false;
    }  
    if (scrollY >= tileH) {
        if (clicked(tiles.length - 1)) {
            for (int r = tiles.length - 1; r > 0; r--) {
                for (int c = 0; c < tiles[r].length; c++) {
                    tiles[r][c] = tiles[r - 1][c];
                }
            }
            randomInRow(0);
            scrollY = 0;
        } else {
            lose();
        }
    }
}

boolean clicked(int r) {
    for (int c = 0; c < tiles[r].length; c++) {
        if (tiles[r][c] == 2)
            return true;
    }
    
    return false;
}

void drawLost() {
    fill(colours[1]);
    textSize(60);
    if(choice==1)
    text("\nYour score: " + score1 + "\nYour highscore: " + highscore + "\n\nClick to start over", 850, 300);
    else if(choice==2){
           fill(0);
           text("\nYour score: " + score2 + "\nYour highscore: " + highScore2 + "\n\nClick to start over", 900, 535);}
     else if(choice==3){
       background(game3);
           highscore3=max(highscore3,score3);
           text("\nYour score: " + score3 + "\nYour highscore: " + highscore3 + "\nClick to start over", 750, 300);      } 
}




 

int[] lastUnfilledRow() {
    int[] unfilled = tiles[tiles.length - 1];
    for (int r = tiles.length - 1; r > 0; r--) {
        for (int c : tiles[r]) {
            if (c == 2) {
                unfilled = tiles[r - 1];
            }
        }
    }

    return unfilled;
}
void tagTile(int[] row, int col) {
    row[col] = 2;
    if(!losez)
    score3 += 1;
    left=true;
    right=true;
    if (scrollSpeed == 0) {
        scrollSpeed = startingSpeed;
    }
}
void mousePressed(){
  if(losex==true && choice==1)
   start=true;
   
   if(losey==true && choice==2)
   start=true;
   
     if(losez==true && choice==3){
    started=false;
  start=true;}
}
       
