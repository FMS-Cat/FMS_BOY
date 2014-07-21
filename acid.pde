void aci(){
  gD.fill(0,71);
  gD.rectMode(CORNER);
  gD.rect(0,0,10,144);
  gD.rect(20,0,10,144);
  gD.rect(40,0,10,144);
  gD.rect(60,0,10,144);
  
  gD.textFont(fontF);
  gD.textAlign(LEFT,TOP);
  for(int c=0;c<16;c++){
    gD.fill(0);
    if(c<10){gD.text(c,1,16+8*c);}
    else{gD.text(char(c+55),1,16+8*c);}
    gD.text("C 4",81,17+8*c);
  }
}
