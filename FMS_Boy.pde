// FMS_Boy.pde
// 某ゲーム機の模倣です
// 2014-07-21
// 4-14 小渕豊

/*

===== FMS BOY =====
カセットを２つのうちから選べます
一つはアルカノイド（ブロック崩し）です
もう一つはコンウェイシーケンサーです
コンウェイに関しては背景が同期します

===== 採点ポイント =====
条件分岐 : FMS_Boy タブ 84 行 - ボタンを押しているか否かの変数により、ボタンの連続入力時間を扱う変数を変化させています
繰り返し : arkanoid タブ 42 行 - 背景として正方形を描画していますが、たくさん並べるので繰り返しを用いています
配列 : conway タブ 4 行 - コンウェイの生死を格納する変数に配列を用いています ( int[][] conLife )
関数 : cassette タブ 1 行 - カセットを描画する関数を作っています、パラメータはラベル画像 ( void cassette(PImage label) )

===== 本体の操作 =====
- P が電源
- E,S,D,F が十字パッド カセットの選択
- K がAボタン カセットの差込
- J がBボタン カセットの抜出
- Enter がSTART
- BS がSELECT

===== その他の操作 =====
- 十字キー で角度操作
- 2 がズーム
- 3 で背景
- 4 で本体ビート
- 5 でオートパイロット

*/

import ddf.minim.*;
Minim minim;

int cassetteSelect=0; // 0がアルカノイド、1がライフゲーム
float cassetteSelectAni; // カセットのアニメーション
PGraphics gD;  // ゲーム画面
int flip,insert,zoom; // 本体のカメラ視点と状態
int power; // 0がオフ、1がスプラッシュ、2が動作
float flipAni,insertAni,zoomAni;  // カメラ視点のアニメーション
int up,down,left,right,a,b,start,select;  // ボタン入力
int upP,downP,leftP,rightP,aP,bP,startP,selectP;  // ボタン入力時間
float vAni,hAni,aAni,bAni,startAni,selectAni; // ボタンのアニメーション
float cameraX,cameraY,cameraZ,cameraAuto; // 邪魔カメラ視点
int cameraUp,cameraDown,cameraLeft,cameraRight,shift; // 邪魔カメラ用のボタン入力
PFont fontL,fontF; // フォント
PImage labelArk,labelCon; // カセットのラベル
PImage splashFMS; // スプラッシュの画像
int bg; // 背景
AudioPlayer splashSound; // 起動音

void setup(){
  size(640,640,OPENGL);
  rectMode(CENTER);
  imageMode(CENTER);
  gD=createGraphics(160,144);
  fontL=loadFont("logo.vlw");
  fontF=loadFont("fami.vlw");
  labelArk=loadImage("arkanoid.png");
  labelCon=loadImage("conway.png");
  splashFMS=loadImage("FMS.png");
  minim=new Minim(this);
  bgSetup();
}

void draw(){
  // カセットのアニメーション
  cassetteSelectAni+=(cassetteSelect-cassetteSelectAni)*.3;
  
  // カメラ視点のアニメーション
  flipAni+=(flip-flipAni)*.3; 
  insertAni+=(insert-insertAni)*.3;
  zoomAni+=(zoom-zoomAni)*.3;
  if(flipAni>0.99&&flipAni!=1){flipAni=1;insert=1;}
  if(insertAni<0.01&&insertAni!=0){insertAni=0;flip=0;}
  
  // ボタンのアニメーション
  vAni+=(down-up-vAni)*.8;
  hAni+=(right-left-hAni)*.8;
  aAni+=(a-aAni)*.8;
  bAni+=(b-bAni)*.8;
  startAni+=(start-startAni)*.8;
  selectAni+=(select-selectAni)*.8;
  
  // ボタン入力時間判定
  if(a==1){aP++;}else{aP=0;}
  if(b==1){bP++;}else{bP=0;}
  if(left==1){leftP++;}else{leftP=0;}
  if(right==1){rightP++;}else{rightP=0;}
  if(up==1){upP++;}else{upP=0;}
  if(down==1){downP++;}else{downP=0;}
  if(start==1){startP++;}else{startP=0;}
  if(select==1){selectP++;}else{selectP=0;}
  
  background(0);
  
  // ライティング
  ambientLight(225,225,225);
  spotLight(255,255,255,0,0,640,0,0,0,PI/2,0);
  
  // 背景を描画
  bg();
  
  // 邪魔カメラ
  cameraX+=cameraUp*0.05-cameraDown*0.05;
  if(cameraX>PI)cameraX-=2*PI;
  if(cameraX<-PI)cameraX+=2*PI;
  cameraY+=cameraRight*0.05-cameraLeft*0.05;
  if(cameraY>PI)cameraY-=2*PI;
  if(cameraY<-PI)cameraY+=2*PI;
  if(cameraAuto==1){
    cameraX=noise(frameCount*0.01,66)*PI/2*3-PI/4*3;
    cameraY=noise(frameCount*0.01,172)*PI/2*3-PI/4*3;
    cameraZ=noise(frameCount*0.01,3265)*PI*6-PI*3;
  }
  translate(width/2,height/2,beat*30*beatBoy);
  rotateX(cameraX*(1-zoomAni));
  rotateY(cameraY*(1-zoomAni));
  rotateZ(cameraZ*(1-zoomAni));
  
  // カセット（アルカノイド）を描画
  pushMatrix();
  translate(0-cassetteSelectAni*300,height/4*(-1+insertAni*0.6+zoomAni*(0.2+(1-flipAni)*0.8)-abs(0-cassetteSelect)*flipAni*2),zoomAni*300);
  rotateX(0.1);
  rotateY(PI*flipAni);
  if(insertAni<0.8)cassette(labelArk);
  popMatrix();
  
  // カセット（コンウェイ）を描画
  pushMatrix();
  translate(300-cassetteSelectAni*300,height/4*(-1+insertAni*0.6+zoomAni*(0.2+(1-flipAni)*0.8)-abs(1-cassetteSelect)*flipAni*2),zoomAni*300);
  rotateX(0.1);
  rotateY(PI*flipAni);
  if(insertAni<0.8)cassette(labelCon);
  popMatrix();
  
  // 本体を描画
  pushMatrix();
  translate(0,height/4*(1-flipAni*0.3-insertAni*0.6+zoomAni*(0.2+(1-flipAni)*0.8)),zoomAni*300);
  rotateX(-0.8+0.9*flipAni-0.1*zoomAni);
  game();
  body(); // 本体ほとんど
  gameDisplay(); // ゲーム画面
  popMatrix();
}

void stop(){
  minim.stop();
  super.stop();
}

void keyPressed(){
  // カセットを選ぶ
  if(power==0){
    if(flip==0){
      if(key=='s')cassetteSelect--;
      if(key=='f')cassetteSelect++;
      cassetteSelect=max(0,cassetteSelect);
      cassetteSelect=min(cassetteSelect,1);
      if(key=='k'){
        flip=1;
      }
    }
    if(key=='j'){
      if(insert==1){insert=0;power=0;}
    }
  }
  
  // 本体のカメラ視点と状態を制御するボタン
  if(key=='p'){
    if(power==0){
      if(insert==1){
        splashMountain=0;
        power=1;
        splashMode=0;
        if(start==1)splashMode=2;
      }
    }else{
      power=0;
      minim.stop();
    }
  }
  if(key=='2')zoom=1-zoom;
  if(key=='3')bg=1-bg;
  if(key=='4')beatBoy=1-beatBoy;
  if(key=='5'){
    cameraX=0;
    cameraY=0;
    cameraZ=0;
    cameraAuto=1-cameraAuto;
  }
  if(key==CODED){
    if(keyCode==UP)cameraUp=1;
    if(keyCode==DOWN)cameraDown=1;
    if(keyCode==LEFT)cameraLeft=1;
    if(keyCode==RIGHT)cameraRight=1;
  }
  
  // 本体のボタン
  if(key=='e')up=1;
  if(key=='s')left=1;
  if(key=='d')down=1;
  if(key=='f')right=1;
  if(key=='k')a=1;
  if(key=='j')b=1;
  if(key==ENTER)start=1;
  if(key==BACKSPACE)select=1;
}

void keyReleased(){
  // 本体のボタン
  if(key=='e')up=0;
  if(key=='s')left=0;
  if(key=='d')down=0;
  if(key=='f')right=0;
  if(key=='k')a=0;
  if(key=='j')b=0;
  if(key==ENTER)start=0;
  if(key==BACKSPACE)select=0;
  
  // カメラ用のボタン
  if(key==CODED){
    if(keyCode==UP)cameraUp=0;
    if(keyCode==DOWN)cameraDown=0;
    if(keyCode==LEFT)cameraLeft=0;
    if(keyCode==RIGHT)cameraRight=0;
  }
}
