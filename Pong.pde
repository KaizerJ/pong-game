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
int barStep = 15;


// scores
int score1;
int score2;

//sounds
SoundFile winSound, reboundSound, barReboundSound;

void setup(){
  size(500,500);
  
  xMinLimit = 0;
  xMaxLimit = 500;
  yMinLimit = 0;
  yMaxLimit = 500;
  
  reset();
  
  score1 = 0;
  score2 = 0;
  
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
    mx = -mx;
    bx += mx;
    thread("SuenaReboundBar");
  }
  
  // checks if ball hit player's 2 bar
  if( bx + bradius/2 >= bar2x && (by >= bar2y && by <= bar2y + barLengthy)){
    mx = -mx;
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
  
  if(by + bradius/2 >= yMaxLimit){
    my = -my;
    by = yMaxLimit - bradius;
    thread("SuenaRebote");
  }
  
  // check y borders rebounds
  if(by - bradius/2 <= yMinLimit){
    my = -my;
    by = yMinLimit + bradius;
    thread("SuenaRebote");
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
  
  bar1x = xMinLimit + 10;
  bar1y = ((yMaxLimit - yMinLimit) / 2) - barLengthy/2;
  
  bar2x = xMaxLimit - 10 - barLengthx;
  bar2y = ((yMaxLimit - yMinLimit) / 2) - barLengthy/2;
}

void keyPressed(){
  if(key == 'w' && bar1y > 0){
    bar1y = bar1y - barStep;
  }
  
  if(key == 's' && bar1y < yMaxLimit - barLengthy){
    bar1y = bar1y + barStep;
  }
  
  if(keyCode == UP && bar2y > 0){
    bar2y = bar2y - barStep;
  }
  
  if(keyCode == DOWN && bar2y < yMaxLimit - barLengthy){
    bar2y = bar2y + barStep;
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
