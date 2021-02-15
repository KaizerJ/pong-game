import processing.sound.*;


// board limits
int xMinLimit;
int xMaxLimit;
int yMinLimit;
int yMaxLimit;

// ball coordinates
int bx;
int by;
int bradius;

// ball movement vector
float mx;
float my;


// players bars
int barLengthx = 10;
int barLengthy = 40;

int bar1x;
int bar1y;

int bar2x;
int bar2y;

// bar step size
int barStep = 5;


// scores
int score1;
int score2;

//sounds
SoundFile winSound, reboundSound, barReboundSound;

//keyStates
// w, s, UP, DOWN
boolean[] keysPressed = {false, false, false, false};

void setup(){
  size(500,500);
  
  xMinLimit = 0;
  xMaxLimit = 500;
  yMinLimit = 0;
  yMaxLimit = 500;
  
  reset();
  
  score1 = 0;
  score2 = 0;
  
  fill(0,0,0);
  textAlign(CENTER, CENTER);
  textSize(18);
  text("Pulse ENTER para empezar", width/2, height/2);
  fill(96);
  text("Controles:\n Jugador 1: w - subir y s - bajar \n Jugador 2: flecha arriba y flecha abajo", width/2, height/2 + 100);
  while(true){
    if(keyPressed && key == ENTER) break;
    noLoop();
  }
  loop();
  fill(255);
  
  winSound = new SoundFile ( this , "./winSound.wav" ) ;
  reboundSound = new SoundFile ( this , "./reboundSound.wav" ) ;
  barReboundSound = new SoundFile ( this , "./barReboundSound.wav" ) ;
  
}


void draw(){
  background(128);
  textSize(30);
  text(score1, width/4, 40);
  text(score2, 3*width/4, 40);
  circle(bx, by, bradius);
  line(width/2, 0, width/2, height);
  rect(bar1x, bar1y, barLengthx, barLengthy);
  rect(bar2x, bar2y, barLengthx, barLengthy);
  
  // checks if ball hit player's 1 bar
  if( bx - bradius/2 <= bar1x + barLengthx && (by >= bar1y && by <= bar1y + barLengthy)){
    mx = mx < 0? -mx : mx;
    bx += mx;
    thread("SuenaReboundBar");
  }
  
  // checks if ball hit player's 2 bar
  if( bx + bradius/2 >= bar2x && (by >= bar2y && by <= bar2y + barLengthy)){
    mx = mx > 0? -mx : mx;
    bx += mx;
    thread("SuenaReboundBar");
  }
  
  // check if player 1 scores
  if(bx + bradius/2 >= xMaxLimit){
    score1++;
    reset();
    thread("SuenaScore");
    delay(100);
  }
  
  // check if player 2 scores
  if(bx - bradius/2 <= xMinLimit){
    score2++;
    reset();
    thread("SuenaScore");
    delay(100);
  }
  
  // check y borders rebounds
  if(by + bradius/2 >= yMaxLimit){
    my = -my;
    by = yMaxLimit - bradius - 2;
    thread("SuenaRebote");
  }
  
  // check y borders rebounds
  if(by - bradius/2 <= yMinLimit){
    my = -my;
    by = yMinLimit + bradius + 2;
    thread("SuenaRebote");
  }
  
  // update bars pos
  if( keysPressed[0] && bar1y > 0){
    bar1y = bar1y - barStep;
  }
  
  if( keysPressed[1] && bar1y < yMaxLimit - barLengthy){
    bar1y = bar1y + barStep;
  }
  
  if( keysPressed[2] && bar2y > 0){
    bar2y = bar2y - barStep;
  }
  
  if( keysPressed[3] && bar2y < yMaxLimit - barLengthy){
    bar2y = bar2y + barStep;
  }
  
  // update ball position
  bx += mx;
  by += my;
}

void reset(){
  bx = width/2;
  by = height/2;
  bradius = 10;
  
  mx = -3;
  my = 3*random(-1, 1);
  
  while(abs(my) < 0.7){
    my = 3*random(-1, 1);
  }
  
  bar1x = xMinLimit + 10;
  bar1y = ((yMaxLimit - yMinLimit) / 2) - barLengthy/2;
  
  bar2x = xMaxLimit - 10 - barLengthx;
  bar2y = ((yMaxLimit - yMinLimit) / 2) - barLengthy/2;
}

void keyPressed(){
  if(key == 'w'){
    keysPressed[0] = true;
  }
  
  if(key == 's'){
    keysPressed[1] = true;
  }
  
  if(keyCode == UP){
    keysPressed[2] = true;
  }
  
  if(keyCode == DOWN){
    keysPressed[3] = true;
  }
}

void keyReleased(){
  if(key == 'w'){
    keysPressed[0] = false;
  }
  
  if(key == 's'){
    keysPressed[1] = false;
  }
  
  if(keyCode == UP){
    keysPressed[2] = false;
  }
  
  if(keyCode == DOWN){
    keysPressed[3] = false;
  }
}
  

void SuenaRebote( ){
  reboundSound.play();
}

void SuenaScore( ){
  winSound.play();
}

void SuenaReboundBar(){
  barReboundSound.play();
}
