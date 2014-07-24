AudioOutput aciOut;
AudioPlayer[][] aciSamp=new AudioPlayer[5][3];
SawWave aciSaw;
ChebFilter aciLpf;

int aciTrigger,aciClock;
int aciStep;
int aciSeq=1;
float aciDec=0.8,aciCut;
int[][] aciDrum=new int[16][5];
int[] aciNote=new int[16],aciEnv=new int[16];
int[] aciVoice=new int[16];
int aciCol,aciRow;
int aciDrag;
int aciBpm=140,aciScale=0;
float aciGauge,aciPeak;

Table aciTable;

void aciSetup(){
  aciOut=minim.getLineOut();
  aciSaw=new SawWave(110,0,44100);
  aciLpf=new ChebFilter(500,ChebFilter.LP,0.05,2,44100);
  aciOut.addSignal(aciSaw);
  aciOut.addEffect(aciLpf);
  aciSamp[0][0]=minim.loadFile("aci0X.wav");
  aciSamp[0][1]=minim.loadFile("aci0Y.wav");
  aciSamp[0][2]=minim.loadFile("aci0Z.wav");
  aciSamp[1][0]=minim.loadFile("aci1X.wav");
  aciSamp[1][1]=minim.loadFile("aci1Y.wav");
  aciSamp[1][2]=minim.loadFile("aci1Z.wav");
  aciSamp[2][0]=minim.loadFile("aci2X.wav");
  aciSamp[2][1]=minim.loadFile("aci2Y.wav");
  aciSamp[2][2]=minim.loadFile("aci2Z.wav");
  aciSamp[3][0]=minim.loadFile("aci3X.wav");
  aciSamp[3][1]=minim.loadFile("aci3Y.wav");
  aciSamp[3][2]=minim.loadFile("aci3Z.wav");
  aciSamp[4][0]=minim.loadFile("aci4X.wav");
  aciSamp[4][1]=minim.loadFile("aci4Y.wav");
  aciSamp[4][2]=minim.loadFile("aci4Z.wav");
  aciLoad();
  aciInit();
}

void aciInit(){
  aciClock=millis();
  aciStep=15;
}

void aci(){
  aciTrigger=0;
  if(aciClock<millis()){
    aciClock+=15000/aciBpm;
    aciTrigger=1;
  }
  
  if(aciTrigger==1&&aciSeq==1){
    aciStep=++aciStep%16;
  }
  if(start==1&&select==1){
    if(leftP==1||(leftP>20&&leftP%4==0)){
      aciBpm=max(--aciBpm,60);
    }
    if(rightP==1||(rightP>20&&rightP%4==0)){
      aciBpm=min(++aciBpm,999);
    }
    if(upP==1||(upP>20&&upP%4==0)){
      aciScale=++aciScale%8;
    }
    if(downP==1||(downP>20&&downP%4==0)){
      aciScale=(--aciScale+8)%8;
    }
  }else{
    if(startP==1){aciSeq=1-aciSeq;aciStep=15;aciClock=millis();aciSave();}
    if(leftP==1||(leftP>20&&leftP%4==0)){
      if(a==1){
        aciDrum[aciRow][aciCol]=2;
      }else if(b==1){
        if(select==0){
          aciNote[aciRow]--;
          aciScaler(aciRow,0);
          if(aciNote[aciRow]<0)aciNote[aciRow]=0;
        }else{
          for(int c=0;c<16;c++){
            aciNote[c]--;
            if(aciNote[c]<0)aciNote[c]=0;
          }
        }
      }else{
        aciCol=(--aciCol+5)%5;
      }
    }
    if(rightP==1||(rightP>20&&rightP%4==0)){
      if(a==1){
        aciDrum[aciRow][aciCol]=3;
      }else if(b==1){
        if(select==0){
          aciNote[aciRow]++;
          aciScaler(aciRow,1);
          if(aciNote[aciRow]>119)aciNote[aciRow]=119;
        }else{
          for(int c=0;c<16;c++){
            aciNote[c]++;
            if(aciNote[c]>119)aciNote[c]=119;
          }
        }
      }else{
        aciCol=++aciCol%5;
      }
    }
    if(upP==1||(upP>20&&upP%4==0)){
      if(a==1){
        aciRow=(--aciRow+16)%16;
        aciDrum[aciRow][aciCol]=aciDrag;
      }else if(b==1){
        if(select==0){
          aciEnv[aciRow]++;
          if(aciVoice[aciRow]==0){aciEnv[aciRow]=0;aciVoice[aciRow]=1;}
          if(aciEnv[aciRow]==32)aciEnv[aciRow]=31;
        }else{
          for(int c=0;c<16;c++){
            aciEnv[c]++;
            if(aciVoice[c]==0){aciEnv[c]=0;aciVoice[c]=1;}
            if(aciEnv[c]==32)aciEnv[c]=31;
          }
        }
      }else{
        aciRow=(--aciRow+16)%16;
      }
    }
    if(downP==1||(downP>20&&downP%4==0)){
      if(a==1){
        aciRow=(++aciRow)%16;
        aciDrum[aciRow][aciCol]=aciDrag;
      }else if(b==1){
        if(select==0){
          aciEnv[aciRow]--;
          if(aciEnv[aciRow]==-1){aciEnv[aciRow]=0;aciVoice[aciRow]=0;}
        }else{
          for(int c=0;c<16;c++){
            aciEnv[c]--;
            if(aciEnv[c]==-1){aciEnv[c]=0;aciVoice[c]=0;}
          }
        }
      }else{
        aciRow=(++aciRow)%16;
      }
    }
    if(aP==1){
      if(select==0){
        if(aciDrum[aciRow][aciCol]==0){aciDrum[aciRow][aciCol]=1;aciDrag=1;}
        else{aciDrum[aciRow][aciCol]=0;aciDrag=0;}
      }else{
        for(int c=0;c<16;c++){
          if(b==0){
            aciDrum[c][aciCol]=floor(random(4));
          }else{
            aciNote[c]=floor(random(48));
            aciScaler(c,floor(random(2)));
            if(random(1)<0.4)aciNote[c]=floor(aciNote[c]/12)*12;
            aciEnv[c]=floor(random(32));
            aciVoice[c]=1;
          }
        }
      }
    }
  }
  
  if(aciSeq==1&&aciTrigger==1){
    for(int c=0;c<5;c++){
      if(aciDrum[aciStep][c]>0){
        if(c==0){beat=1;}
        if(c==1&&aciDrum[aciStep][c]==1){cbAni[0]=1;}
        if(c==1&&aciDrum[aciStep][c]==2){cbAni[8]=1;}
        if(c==1&&aciDrum[aciStep][c]==3){cbAni[11]=1;}
        if(c==2&&aciDrum[aciStep][c]==1){cbAni[4]=1;}
        if(c==2&&aciDrum[aciStep][c]==2){cbAni[10]=1;}
        if(c==2&&aciDrum[aciStep][c]==3){cbAni[12]=1;}
        if(c==3&&aciDrum[aciStep][c]==1){cbAni[6]=1;}
        if(c==3&&aciDrum[aciStep][c]==2){cbAni[1]=1;}
        if(c==3&&aciDrum[aciStep][c]==3){cbAni[3]=1;}
        if(c==4&&aciDrum[aciStep][c]==1){cbAni[9]=1;}
        if(c==4&&aciDrum[aciStep][c]==2){cbAni[7]=1;}
        if(c==4&&aciDrum[aciStep][c]==3){cbAni[5]=1;}
        
        aciSamp[c][aciDrum[aciStep][c]-1].rewind();
        aciSamp[c][aciDrum[aciStep][c]-1].play();
        aciGauge+=2;
        if(c==0)aciGauge+=2;
      }
    }
  }
  
  aciSaw.setFreq(55/4f*pow(2,aciNote[aciStep]/12f)*aciVoice[aciStep]);
  aciSaw.setAmp(aciSeq*.3);
  
  if(aciVoice[aciStep]==1&&aciSeq==1){aciGauge+=.6;}
  aciGauge*=.9;
  
  aciCut*=.9;
  if(aciTrigger==1&&aciSeq==1)aciCut=aciEnv[aciStep]*200;
  if(aciCut<300)aciCut=300;
  aciLpf.setFreq(aciCut);
  
  gD.noStroke();
  gD.fill(0,71);
  gD.rectMode(CORNER);
  gD.rect(0,0,10,144);
  gD.rect(aciCol*10+20,0,10,144);
  gD.rect(0,aciRow*8+16,126,8);
  
  gD.textFont(fontF);
  gD.textAlign(LEFT,TOP);
  for(int c=0;c<16;c++){
    gD.fill(0);
    for(int cd=0;cd<5;cd++){
      if(aciDrum[c][cd]==1)gD.text("X",22+cd*10,17+8*c);
      if(aciDrum[c][cd]==2)gD.text("Y",22+cd*10,17+8*c);
      if(aciDrum[c][cd]==3)gD.text("Z",22+cd*10,17+8*c);
    }
    if(aciNote[c]%12==0)gD.text("A",82,17+8*c);
    if(aciNote[c]%12==1)gD.text("A#",82,17+8*c);
    if(aciNote[c]%12==2)gD.text("B",82,17+8*c);
    if(aciNote[c]%12==3)gD.text("C",82,17+8*c);
    if(aciNote[c]%12==4)gD.text("C#",82,17+8*c);
    if(aciNote[c]%12==5)gD.text("D",82,17+8*c);
    if(aciNote[c]%12==6)gD.text("D#",82,17+8*c);
    if(aciNote[c]%12==7)gD.text("E",82,17+8*c);
    if(aciNote[c]%12==8)gD.text("F",82,17+8*c);
    if(aciNote[c]%12==9)gD.text("F#",82,17+8*c);
    if(aciNote[c]%12==10)gD.text("G",82,17+8*c);
    if(aciNote[c]%12==11)gD.text("G#",82,17+8*c);
    gD.text(aciNote[c]/12,94,17+8*c);
    if(aciVoice[c]==1){
      gD.text(nf(aciEnv[c],2),106,17+8*c);
    }else{
      gD.text("--",106,17+8*c);
    }
    
    if(aciStep==c&&aciSeq==1)gD.rect(0,16+8*c,10,8);
    if(aciStep==c&&aciSeq==1)gD.fill(127,255,0);
    if(c<10){gD.text(c,2,17+8*c);}
    else{gD.text(char(c+55),2,17+8*c);}
  }
  
  gD.fill(0);
  gD.stroke(0);
  gD.line(132,5,132,9);
  gD.point(133,6);gD.point(134,7);gD.point(134,8);
  gD.ellipse(131,10,2,1);
  gD.text(aciBpm,137,5);
  for(int c=0;c<16;c++){
    if(c<aciGauge-1)gD.rect(128,144-8-c*8,29,6);
  }
  
  gD.text("0",22,5);
  gD.text("1",32,5);
  gD.text("2",42,5);
  gD.text("3",52,5);
  gD.text("4",62,5);
  
  if(aciScale==0)gD.text("CHROMA",82,5);
  if(aciScale==1)gD.text("IONIAN",82,5);
  if(aciScale==2)gD.text("PHRYG",82,5);
  if(aciScale==3)gD.text("AEOLIA",82,5);
  if(aciScale==4)gD.text("RAGA",82,5);
  if(aciScale==5)gD.text("PENTA",82,5);
  if(aciScale==6)gD.text("JAPAN",82,5);
  if(aciScale==7)gD.text("5TH",82,5);
}

void aciScaler(int note,int pm){
  if(aciScale==1){
    if(aciNote[note]%12==1)aciNote[note]+=-1+pm*2;
    if(aciNote[note]%12==3)aciNote[note]+=-1+pm*2;
    if(aciNote[note]%12==6)aciNote[note]+=-1+pm*2;
    if(aciNote[note]%12==8)aciNote[note]+=-1+pm*2;
    if(aciNote[note]%12==10)aciNote[note]+=-1+pm*2;
  }
  if(aciScale==2){
    if(aciNote[note]%12==2)aciNote[note]+=-1+pm*2;
    if(aciNote[note]%12==4)aciNote[note]+=-1+pm*2;
    if(aciNote[note]%12==6)aciNote[note]+=-1+pm*2;
    if(aciNote[note]%12==9)aciNote[note]+=-1+pm*2;
    if(aciNote[note]%12==11)aciNote[note]+=-1+pm*2;
  }
  if(aciScale==3){
    if(aciNote[note]%12==1)aciNote[note]+=-1+pm*2;
    if(aciNote[note]%12==4)aciNote[note]+=-1+pm*2;
    if(aciNote[note]%12==6)aciNote[note]+=-1+pm*2;
    if(aciNote[note]%12==9)aciNote[note]+=-1+pm*2;
    if(aciNote[note]%12==11)aciNote[note]+=-1+pm*2;
  }
  if(aciScale==4){
    if(aciNote[note]%12==2)aciNote[note]+=-1+pm*3;
    if(aciNote[note]%12==3)aciNote[note]+=-2+pm*3;
    if(aciNote[note]%12==6)aciNote[note]+=-1+pm*2;
    if(aciNote[note]%12==9)aciNote[note]+=-1+pm*3;
    if(aciNote[note]%12==10)aciNote[note]+=-2+pm*3;
  }
  if(aciScale==5){
    if(aciNote[note]%12==1)aciNote[note]+=-1+pm*3;
    if(aciNote[note]%12==2)aciNote[note]+=-2+pm*3;
    if(aciNote[note]%12==4)aciNote[note]+=-1+pm*2;
    if(aciNote[note]%12==6)aciNote[note]+=-1+pm*2;
    if(aciNote[note]%12==8)aciNote[note]+=-1+pm*3;
    if(aciNote[note]%12==9)aciNote[note]+=-2+pm*3;
    if(aciNote[note]%12==11)aciNote[note]+=-1+pm*2;
  }
  if(aciScale==6){
    if(aciNote[note]%12==2)aciNote[note]+=-1+pm*4;
    if(aciNote[note]%12==3)aciNote[note]+=-2+pm*4;
    if(aciNote[note]%12==4)aciNote[note]+=-3+pm*4;
    if(aciNote[note]%12==6)aciNote[note]+=-1+pm*2;
    if(aciNote[note]%12==8)aciNote[note]+=-1+pm*3;
    if(aciNote[note]%12==9)aciNote[note]+=-2+pm*3;
    if(aciNote[note]%12==11)aciNote[note]+=-1+pm*2;
  }
  if(aciScale==7){
    if(aciNote[note]%12==1)aciNote[note]+=-1+pm*7;
    if(aciNote[note]%12==2)aciNote[note]+=-2+pm*7;
    if(aciNote[note]%12==3)aciNote[note]+=-3+pm*7;
    if(aciNote[note]%12==4)aciNote[note]+=-4+pm*7;
    if(aciNote[note]%12==5)aciNote[note]+=-5+pm*7;
    if(aciNote[note]%12==6)aciNote[note]+=-6+pm*7;
    if(aciNote[note]%12==8)aciNote[note]+=-1+pm*5;
    if(aciNote[note]%12==9)aciNote[note]+=-2+pm*5;
    if(aciNote[note]%12==10)aciNote[note]+=-3+pm*5;
    if(aciNote[note]%12==11)aciNote[note]+=-4+pm*5;
  }
}

void aciLoad(){
  aciTable=loadTable("aci.csv","header");
  
  for(int c=0;c<16;c++){
    TableRow row=aciTable.getRow(c);
    aciDrum[c][0]=row.getInt("0");
    aciDrum[c][1]=row.getInt("1");
    aciDrum[c][2]=row.getInt("2");
    aciDrum[c][3]=row.getInt("3");
    aciDrum[c][4]=row.getInt("4");
    aciNote[c]=row.getInt("note");
    aciVoice[c]=row.getInt("voice");
    aciEnv[c]=row.getInt("env");
    if(c==0){
      aciBpm=row.getInt("bpm");
      aciScale=row.getInt("scale");
    }
  }
}

void aciSave(){
  aciTable=new Table();
  
  aciTable.addColumn("0");
  aciTable.addColumn("1");
  aciTable.addColumn("2");
  aciTable.addColumn("3");
  aciTable.addColumn("4");
  aciTable.addColumn("note");
  aciTable.addColumn("voice");
  aciTable.addColumn("env");
  aciTable.addColumn("bpm");
  aciTable.addColumn("scale");
  
  for(int c=0;c<16;c++){
    TableRow newRow=aciTable.addRow();
    newRow.setInt("0",aciDrum[c][0]);
    newRow.setInt("1",aciDrum[c][1]);
    newRow.setInt("2",aciDrum[c][2]);
    newRow.setInt("3",aciDrum[c][3]);
    newRow.setInt("4",aciDrum[c][4]);
    newRow.setInt("note",aciNote[c]);
    newRow.setInt("voice",aciVoice[c]);
    newRow.setInt("env",aciEnv[c]);
    if(c==0){
      newRow.setInt("bpm",aciBpm);
      newRow.setInt("scale",aciScale);
    }
  }
  
  saveTable(aciTable,"data/aci.csv");
}
