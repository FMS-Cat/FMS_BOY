void body(){
  
  // Box
  fill(130);
  pushMatrix();
  translate(0,0);
  noStroke();
  beginShape(QUAD_STRIP);
  vertex(-100+10,-160,-30);vertex(-100+10,-160,30);
  vertex(-100,-160+10,-30);vertex(-100,-160+10,30);
  vertex(-100,160-10,-30);vertex(-100,160-10,30);
  vertex(-100+10,160,-30);vertex(-100+10,160,30);
  vertex(100-72,160,-30);vertex(100-72,160,30);
  vertex(100-10,160-20,-30);vertex(100-10,160-20,30);
  vertex(100,160-30,-30);vertex(100,160-30,30);
  vertex(100,-160+10,-30);vertex(100,-160+10,30);
  vertex(100-10,-160,-30);vertex(100-10,-160,30);
  vertex(-100+10,-160,-30);vertex(-100+10,-160,30);
  endShape();
  beginShape();
  vertex(-100+10,-160,-30);
  vertex(-100,-160+10,-30);
  vertex(-100,160-10,-30);
  vertex(-100+10,160,-30);
  vertex(100-72,160,-30);
  vertex(100-10,160-20,-30);
  vertex(100,160-30,-30);
  vertex(100,-160+10,-30);
  vertex(100-10,-160,-30);
  vertex(-100+10,-160,-30);
  endShape(CLOSE);
  beginShape();
  vertex(-100+10,-160,30);
  vertex(-100,-160+10,30);
  vertex(-100,160-10,30);
  vertex(-100+10,160,30);
  vertex(100-72,160,30);
  vertex(100-10,160-20,30);
  vertex(100,160-30,30);
  vertex(100,-160+10,30);
  vertex(100-10,-160,30);
  vertex(-100+10,-160,30);
  endShape(CLOSE);
  fill(0);
  beginShape();
  vertex(-60,-161,-30);
  vertex(60,-161,-30);
  vertex(60,-161,-10);
  vertex(-60,-161,-10);
  endShape();
  popMatrix();
  
  // Display BG
  noStroke();
  fill(127);
  pushMatrix();
  translate(0,-70,31);
  rect(0,0,180,150,6,6,24,6);
  popMatrix();
  
  // Display
  noStroke();
  pushMatrix();
  translate(0,-70,32);
  fill(191,255,0);
  rect(0,0,124,112,2);
  popMatrix();
  
  // Logo
  fill(17,0,127);
  pushMatrix();
  translate(-50,15,31);
  textAlign(CENTER,CENTER);
  textFont(fontL,12);
  text("Meiji FMS BOY",0,0);
  popMatrix();
  
  // Joypad
  fill(51);
  noStroke();
  pushMatrix();
  translate(-60,70,30);
  rotateX(-vAni*0.1);
  rotateY(hAni*0.1);
  box(40,12,10);
  box(12,40,10);
  popMatrix();
  
  // AB
  fill(153,0,102);
  noStroke();
  for(int cB=0;cB<=1;cB++){
    pushMatrix();
    translate(70-30*cB,60+14*cB,35-aAni*3*(1-cB)-bAni*3*cB);
    ellipse(0,0,24,24);
    beginShape(QUAD_STRIP);
    for(float cT=0;cT<=PI*2.1;cT+=PI/8){
      vertex(12*sin(cT),12*cos(cT),0);
      vertex(12*sin(cT),12*cos(cT),-10);
    }
    endShape();
    popMatrix();
  }
  
  // StartSelect
  fill(119);
  for(int cS=0;cS<=1;cS++){
    pushMatrix();
    translate(-20+25*cS,110,30-selectAni*(1-cS)-startAni*cS);
    rotateZ(-PI/8);
    translate(-7,0,0);
    for(int c=0;c<14;c++){
      sphere(3);
      translate(1,0);
    }
    popMatrix();
  }
  
  // powerlight
  noStroke();
  fill(71+184*power,0,0);
  pushMatrix();
  translate(-72,-85,32);
  ellipse(0,0,5,5);
  popMatrix();
  
  // Speaker
  noStroke();
  fill(80);
  pushMatrix();
  translate(20,135,31);
  for(int c=0;c<6;c++){
    translate(10,-4);
    beginShape();
    vertex(-4-2,-10+1);
    bezierVertex(-4-2-1,-10+1-2,-4+2-1,-10-1-2,-4+2,-10-1);
    vertex(4+2,10-1);
    bezierVertex(4+2+1,10-1+2,4-2+1,10+1+2,4-2,10+1);
    endShape();
  }
  popMatrix();
}
