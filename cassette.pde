void cassette(PImage label){
  // Box
  fill(180);
  pushMatrix();
  translate(0,0);
  noStroke();
  box(120,120,20);
  popMatrix();
  
  // FMS BOY
  noStroke();
  pushMatrix();
  fill(127);
  translate(0,-40,11);
  rect(0,0,90,20,10);
  translate(0,0,1);
  fill(180);
  textAlign(CENTER,CENTER);
  textFont(fontL,10);
  text("Meiji FMS BOY",0,0);
  popMatrix();
  
  // Triangle
  noStroke();
  pushMatrix();
  fill(127);
  translate(0,45,11);
  triangle(-10,0,10,0,0,10);
  popMatrix();
  
  // Label
  noStroke();
  pushMatrix();
  fill(0);
  translate(0,7,11);
  image(label,0,0,90,65);
  popMatrix();
}
