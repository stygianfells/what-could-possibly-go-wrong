
//wlecome to NON-GARFIELD'S ROOM OF BLOOD
//the mouse wraparound only works in one direction
//also it spawns your mouse at the top right corner of the screen
//i have no idea why and i dont have time to fix it
//also the code for the colour dependent textures is here i just don't have a map with more than two colours

import java.awt.Robot;
Robot r2;

boolean wkey, akey, skey, dkey;
float eyex, eyey, eyez, focusx, focusy, focusz, tiltx, tilty, tiltz;
float lrheadangle, udheadangle;

color black = #000000;
color white = #FFFFFF;
color blue;

int gridsize;
PImage map, texture1, texture2;

void setup() {
  size(displayWidth, displayHeight, P3D);
  textureMode(NORMAL);
  wkey = akey = skey = dkey = false;

  eyex = width/2;
  eyey = height/2+200;
  eyez = height/2;
  focusx = width/2;
  focusy = height/2;
  focusz = 10;
  tiltx = 0;
  tilty = 1;
  tiltz = 0;
  lrheadangle = radians(90);

  try {
    r2 = new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }

  map = loadImage("map.png");
  gridsize = 100;

  texture1 = loadImage("garfield.png");
  texture2 = loadImage("garfield3.png");
}

void draw() {
  background(0);
  pointLight(255, 0, 0, eyex, eyey, eyez);
  camera(eyex, eyey, eyez, focusx, focusy, focusz, tiltx, tilty, tiltz);
  
  drawFloor();
  drawFloor(-2000, 2000, height, 100);
  drawFocalPoint();
  controlCamera();
  drawMap();
}

void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);
      if (c == black) {
        texturedCube(x*gridsize-2000, height-gridsize, y*gridsize-2000, texture1, gridsize);
        texturedCube(x*gridsize-2000, height-gridsize-100, y*gridsize-2000, texture1, gridsize);
        texturedCube(x*gridsize-2000, height-gridsize-200, y*gridsize-2000, texture1, gridsize);
      }
      if (c == blue) {
        texturedCube(x*gridsize-2000, height-gridsize, y*gridsize-2000, texture2, gridsize);
        texturedCube(x*gridsize-2000, height-gridsize-100, y*gridsize-2000, texture2, gridsize);
        texturedCube(x*gridsize-2000, height-gridsize-200, y*gridsize-2000, texture2, gridsize);
      }
    }
  }
}

void drawFloor() {
  for (int i = -2000; i <=2000; i+=100) {
    stroke(255);
    line(i, height, -2000, i, height, 2000);
    line(-2000, height, i, 2000, height, i);
  }
}

void drawFloor(int start, int end, int level, int gap) {
  stroke(255);
  strokeWeight(1);
  int x = start;
  int z = start;
  while (z < end) {
    texturedCube(x, level, z, texture2, gap);
    x += gap;
    if (x > end) {
      x = start;
      z += gap;
    }
  }
}

void drawFocalPoint() {
  pushMatrix();
  translate(focusx, focusy, focusz);
  sphere(5);
  popMatrix();
}

void controlCamera() {
  if (wkey) {
    eyex += cos(lrheadangle) * 10;
    eyez += sin(lrheadangle) * 10;
  }
  if (skey) {
    eyex -= cos(lrheadangle) * 10;
    eyez -= sin(lrheadangle) * 10;
  }
  if (akey) {
    eyex -= cos(lrheadangle + radians(90)) * 10;
    eyez -= sin(lrheadangle + radians(90)) * 10;
  }
  if (dkey) {
    eyex += cos(lrheadangle + radians(90)) * 10;
    eyez += sin(lrheadangle + radians(90)) * 10;
  }

  lrheadangle += (mouseX - pmouseX) * 0.005;
  udheadangle += (mouseY - pmouseY) * 0.005;
  if (udheadangle > PI/2.5) udheadangle = -PI/2.5;

  focusx = eyex + cos(lrheadangle) * 300;
  focusz = eyez + sin(lrheadangle) * 300;
  focusy = eyey + tan(udheadangle) * 300;

  if (mouseX > width-2) r2.mouseMove(2, mouseY);
  if (mouseX < 2) r2.mouseMove(width-2, mouseY);

  //println(eyex, eyey, eyez);
}

void keyPressed() {
  if (key == 'W' || key == 'w') wkey = true;
  if (key == 'A' || key == 'a') akey = true;
  if (key == 'S' || key == 's') skey = true;
  if (key == 'D' || key == 'd') dkey = true;
}

void keyReleased() {
  if (key == 'W' || key == 'w') wkey = false;
  if (key == 'A' || key == 'a') akey = false;
  if (key == 'S' || key == 's') skey = false;
  if (key == 'D' || key == 'd') dkey = false;
}
