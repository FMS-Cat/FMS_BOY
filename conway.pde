int conTrigger,conClock; // ステップが進むタイミングの管理をする変数
int conYoko=16,conTate=13; // コンウェイのフィールドの大きさ
int conStep; // シーケンサーの16ステップ
int[][] conLife=new int[conYoko][conTate]; // コンウェイの生死
int[][] conLifeP=new int[conYoko][conTate]; // コンウェイの生死を一時的に格納しておく配列
int conMove=1,conSeq=0; // 世代の進行、シーケンサーのオンオフ
int conPointX=0,conPointY=0; // カーソルの位置
AudioPlayer[] conSnd=new AudioPlayer[13]; // 各行に割り当てられている音
AudioPlayer conKick; // 4ステップごとになるキック

void conSetup(){
  conKick=minim.loadFile("kick.wav");
  conSnd[0]=minim.loadFile("808clav.wav");
  conSnd[1]=minim.loadFile("dx7bass.wav");
  conSnd[2]=minim.loadFile("808conga.wav");
  conSnd[3]=minim.loadFile("slapbass.wav");
  conSnd[4]=minim.loadFile("808cow.wav");
  conSnd[5]=minim.loadFile("piano.wav");
  conSnd[6]=minim.loadFile("909clap.wav");
  conSnd[7]=minim.loadFile("dx7.wav");
  conSnd[8]=minim.loadFile("808hihat.wav");
  conSnd[9]=minim.loadFile("chord.wav");
  conSnd[10]=minim.loadFile("808snare.wav");
  conSnd[11]=minim.loadFile("sawbass.wav");
  conSnd[12]=minim.loadFile("808tom.wav");
  gD.textFont(fontF);
  
  conInit();
}

void conInit(){
  conStep=15;
  conMove=1;conSeq=0;
  for(int x=0;x<conYoko;x++){
    for(int y=0;y<conTate;y++){
      conLife[x][y]=(int)random(1.6)/1;
      if(select==1)conLife[x][y]=0;
      conLifeP[x][y]=0;
    }
  }
  gD.rectMode(CORNER);
  conClock=millis();
}

void con(){
  gD.stroke(31,63,0);
  
  conTrigger=0;
  if(conClock<millis()){
    conClock+=120;
    conTrigger=1;
  }
  
  if(conTrigger==1&&conSeq==1){
    conStep=++conStep%conYoko;
  }
  
  if(conTrigger==1&&conMove==1){
    for(int x=0;x<conYoko;x++){
      for(int y=0;y<conTate;y++){
        conLifeP[x][y]=conLife[x][y];
      }
    }
    
    for(int x=0;x<conYoko;x++){
      for(int y=0;y<conTate;y++){
        int neighbor=0;
        for(int cx=x-1;cx<=x+1;cx++){
          for(int cy=y-1;cy<=y+1;cy++){
            neighbor+=conLifeP[(cx+conYoko)%conYoko][(cy+conTate)%conTate];
          }
        }
        neighbor-=conLifeP[x][y];
        if(conLifeP[x][y]==0&&neighbor==3){conLife[x][y]=1;}
        if(conLifeP[x][y]==1&&neighbor<=1){conLife[x][y]=0;}
        if(conLifeP[x][y]==1&&neighbor>=4){conLife[x][y]=0;}
      }
    }
  }
  for(int x=0;x<conYoko;x++){
    for(int y=0;y<conTate;y++){
      if(conLife[x][y]==1){
        gD.fill(127,255,0);
        if(conStep-x==0&&conSeq==1){
          gD.fill(127,255,0);
          if(conTrigger==1){
            conSnd[y].rewind();
            conSnd[y].play();
            cbAni[y]=1;
          }
        }
      }
      else{
        gD.fill(0);
        if(conStep-x==0&&conSeq==1){
          gD.fill(31,63,0);
          if(conTrigger==1&&y%2==1){
            conSnd[y].pause();
          }
        }
      }
      gD.rect(x*gD.width/conYoko,y*(gD.height-14)/conTate+14,gD.width/conYoko,(gD.height-14)/conTate);
    }
  }
  
  if(conStep%4==0&&conTrigger==1&&conSeq==1){
    conKick.rewind();
    conKick.play();
  }
  
  if(select==1){
    if(aP==1){
      for(int x=0;x<conYoko;x++){
        for(int y=0;y<conTate;y++){
          conLife[x][y]=(int)random(1.6)/1;
        }
      }
    }
    if(bP==1){
      for(int x=0;x<conYoko;x++){
        for(int y=0;y<conTate;y++){
          conLife[x][y]=0;
        }
      }
    }
    if(startP==1){conMove=1-conMove;}
  }else{
    if(a==1)conLife[conPointX][conPointY]=1;
    if(b==1)conLife[conPointX][conPointY]=0;
    if(leftP==1||(leftP>20&&leftP%4==0))conPointX=(conPointX+conYoko-1)%conYoko;
    if(rightP==1||(rightP>20&&rightP%4==0))conPointX=(conPointX+1)%conYoko;
    if(upP==1||(upP>20&&upP%4==0))conPointY=(conPointY+conTate-1)%conTate;
    if(downP==1||(downP>20&&downP%4==0))conPointY=(conPointY+1)%conTate;
    if(startP==1){conSeq=1-conSeq;conStep=15;conClock=millis();}
  }
  
  gD.stroke(63*(1+conTrigger),127*(1+conTrigger),0);
  gD.pushMatrix();
  gD.translate(gD.width/conYoko*(1f/2+conPointX),14+(gD.height-14)/conTate*(1f/2+conPointY));
  gD.line(-4,-4,-4,-2);
  gD.line(-4,-4,-2,-4);
  gD.line(4,-4,4,-2);
  gD.line(4,-4,2,-4);
  gD.line(-4,4,-4,2);
  gD.line(-4,4,-2,4);
  gD.line(4,4,4,2);
  gD.line(4,4,2,4);
  gD.popMatrix();
  
  gD.fill(0);
  gD.noStroke();
  gD.rect(0,0,width,13);
  
  String displayPart="";
  switch(conPointY){
    case 0:displayPart="CLAV";break;
    case 1:displayPart="BASS";break;
    case 2:displayPart="CONGA";break;
    case 3:displayPart="SLAP";break;
    case 4:displayPart="COW";break;
    case 5:displayPart="PIANO";break;
    case 6:displayPart="CLAP";break;
    case 7:displayPart="DX7";break;
    case 8:displayPart="HIHAT";break;
    case 9:displayPart="PAD";break;
    case 10:displayPart="SNARE";break;
    case 11:displayPart="SAW";break;
    case 12:displayPart="TOM";break;
  }
  gD.fill(127,255,0);
  gD.textAlign(LEFT,CENTER);
  gD.text(nf(conPointX+1,2)+"-"+displayPart,3,7);
  gD.fill(63*(1+conMove),127*(1+conMove),0);
  gD.text("CONWAY",gD.width/2,7);
  gD.fill(127,255,0);
  gD.textAlign(RIGHT,CENTER);
  if(conSeq==1){
    gD.text(">",gD.width-3,7);
  }else{
    gD.text("-",gD.width-3,7);
  }
  
  if(conTrigger==1&&conStep%4==0){
    beat=1;
  }
}
