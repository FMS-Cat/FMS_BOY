void game(){
  gD.beginDraw();
  gD.background(127,255,0);
  if(power==1){
    splash();
  }
  if(power==2&&insert==1){
    if(cassetteSelect==0){
      if(arkDemoSw==1){
        arkDemo();
      }else{
        ark();
      }
    }
    if(cassetteSelect==1){
        con();
    }
    if(cassetteSelect==2){
        aci();
    }
  }
  gD.endDraw();
}

void gameDisplay(){
  // Display
  noStroke();
  pushMatrix();
  translate(0,-70,34);
  image(gD,0,0,120,108);
  popMatrix();
}
