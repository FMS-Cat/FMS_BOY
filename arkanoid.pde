ArkBar arkBar; // 棒のオブジェクトを生成
ArkBall arkBall; // ボールのオブジェクトを生成
ArrayList<ArkBlock> arkBlocks; // ブロックのオブジェクトを生成
int arkReady,arkLife,arkLevel,arkScore,arkHi,arkOver; // アルカノイドで用いる変数
int arkDemoSw=1; // 1の間はデモを表示する
PImage arkCat; // 猫の画像
AudioPlayer soundArkBar,soundArkBlock,soundArkMiss,soundArkGameover,soundArkDemo; // 効果音

// 一度だけ実行する準備
void arkSetup(){
  arkDemoSw=1;
  arkLevel=1;
  arkLife=2;
  arkScore=0;
  arkHi=1000;
  arkCat=loadImage("cat.png");
  soundArkBar=minim.loadFile("arkBar.wav");
  soundArkBlock=minim.loadFile("arkBlock.wav");
  soundArkMiss=minim.loadFile("arkMiss.wav");
  soundArkGameover=minim.loadFile("arkGameover.wav");
  soundArkDemo=minim.loadFile("arkDemo.wav");
  gD.textFont(fontF);
  soundArkDemo.rewind();
  soundArkDemo.play();
  soundArkDemo.loop();
  arkInit();
}

// ゲーム毎に実行する準備
void arkInit(){
  arkReady=100;
  arkBar=new ArkBar();
  arkBall=new ArkBall(55,90,0.1+arkLevel*0.04,-0.1-arkLevel*0.04);
  arkBlocks=new ArrayList<ArkBlock>();
  for(int cx=0;cx<10;cx++){
    for(int cy=0;cy<10;cy++){
      arkBlocks.add(new ArkBlock(10+cx*10,20+cy*5));
    }
  }
}

// デモ画面
void arkDemo(){
  // 背景と猫を描く
  gD.noStroke();
  gD.rectMode(CENTER);
  for(int cx=0;cx<gD.width;cx+=8){
    for(int cy=0;cy<gD.height;cy+=8){
      gD.fill(0,128+round(sin(dist(cx+4,cy+4,gD.width/2,gD.height/2)*0.2-frameCount*0.3))*127);
      gD.rect(cx+4,cy+4,8,8);
    }
  }
  gD.imageMode(CENTER);
  gD.image(arkCat,gD.width/2,gD.height/2,80+sin(frameCount*0.1)*20,80+sin(frameCount*0.1)*20);
  
  // Aボタンを押したらデモ終了
  if(a==1){
    arkDemoSw=0;
    soundArkDemo.close();
  }
}

void ark(){
  // 壁を描く
  gD.noStroke();
  gD.rectMode(CENTER);
  gD.fill(0);
  gD.rect(2.5,72,5,144);
  gD.rect(107.5,72,5,144);
  gD.rect(55,2.5,110,5);
  
  // UIを描く
  gD.ellipse(122,120.5,4,4);
  gD.textAlign(LEFT,CENTER);
  gD.text("1P\n"+nf(arkScore,6),117,20);
  gD.text("HI\n"+nf(arkHi,6),117,50);
  gD.text("Lv "+nf(arkLevel,2),117,80);
  gD.text("x "+arkLife,130,120);
  
  if(arkReady==0){ // READY画面でない時に実行
    for(int cRep=0;cRep<4;cRep++){ // 高精度で動かすため毎フレーム処理を4回実行
      // ボールの処理
      arkBall.coll();
      arkBall.move();
      
      // ブロックの処理
      for(int cBlock=0;cBlock<arkBlocks.size();cBlock++){
        ArkBlock arkBlock=arkBlocks.get(cBlock);
        arkBlock.coll();
      }
      
      // 棒の処理
      arkBar.move();
    }
  }else{ // READY画面の時
    arkReady--;
    if(arkOver==1){ // ゲームオーバーの時
      gD.textFont(fontF);
      gD.textAlign(CENTER,CENTER);
      gD.text("GAME OVER",55,80);
      if(arkReady==1){ // いろいろリセットする
        arkOver=0;
        arkScore=0;
        arkLife=2;
        arkLevel=1;
        arkInit(); // ここにarkReadyを100にする処理が入っている
      }
    }else{ // ゲームオーバーではない時
      gD.textFont(fontF);
      gD.textAlign(CENTER,CENTER);
      gD.text("READY",55,80);
    }
  }
  if(arkBlocks.size()==0){ // ブロックの数が0、即ちクリアした時の処理
    arkInit();
    arkLevel++;
  }
  
  // 棒とボールとブロックの表示
  arkBar.disp();
  arkBall.disp();
  for(int cBlock=0;cBlock<arkBlocks.size();cBlock++){
    ArkBlock arkBlock=arkBlocks.get(cBlock);
    arkBlock.disp();
  }
}

// 棒のクラス
class ArkBar{
  float x=55,y=120,v,leng=30;
  
  ArkBar(){
  }
  
  // 棒を動かす処理
  void move(){
    v=0.6+b-a*0.3;
    x+=right*v-left*v;
    if(x<5+leng/2)x=5+leng/2;
    if(x>105-leng/2)x=105-leng/2;
  }
  
  // 棒を表示する処理
  void disp(){
    gD.noStroke();
    gD.fill(0);
    gD.beginShape();
    gD.vertex(x-leng/2,y+4);
    gD.vertex(x-leng/2,y);
    gD.vertex(x+leng/2,y);
    gD.vertex(x+leng/2,y+4);
    gD.endShape();
  }
}

// ボールのクラス
class ArkBall{
  float x,y,vx,vy,r=2;
  ArkBall(float xTemp,float yTemp,float vxTemp,float vyTemp){
    x=xTemp;
    y=yTemp;
    vx=vxTemp;
    vy=vyTemp;
  }
  
  // ボールが壁及びバーと衝突した時、落ちた時の処理
  void coll(){
    if(x<5+r){ // 左壁
      x=5+r;
      vx*=-1;
    }
    if(x>105-r){ // 右壁
      x=105-r;
      vx*=-1;
    }
    if(y<5+r){ // 上壁
      y=5+r;
      vy*=-1;
    }
    if(arkBar.y-r<y&&y<arkBar.y-r+5&&arkBar.x-arkBar.leng/2<x&&x<arkBar.x+arkBar.leng/2){ // バー
      y=arkBar.y-r;
      float v=dist(0,0,vx,vy)*1.02; // ボールの早さを保存、ただし1.02倍に
      float angV=atan2(vy,vx); // 速度角度
      float angR=(PI-angV)%PI+PI+(x-arkBar.x)*0.04; // 反射角
      angR=min(angR,PI*11/6); // 角度が急すぎると良くない
      angR=max(PI*7/6,angR); // 角度が急すぎると良くない
      vx=v*cos(angR);
      vy=v*sin(angR);
      soundArkBar.rewind();
      soundArkBar.play();
    }
    if(150<y){ // 落下時、即ちミス時の処理
      if(arkLife<=0){ // ライフが0の時にミスしたらゲームオーバー
        arkReady=300; // ゲームオーバー画面では300フレーム待つ
        arkOver=1;
        soundArkGameover.rewind();
        soundArkGameover.play();
      }else{
        float v=dist(0,0,vx,vy)*0.7; // 速度を保存、ただし0.7倍に
        arkReady=100; // READY画面では100フレーム待つ
        arkBar=new ArkBar(); // 棒のリセット
        arkBall=new ArkBall(55,90,v/sqrt(2),-v/sqrt(2)); // ボールのリセット
        arkLife--;
        soundArkMiss.rewind();
        soundArkMiss.play();
      }
    }
  }
  
  // ボールを動かす処理
  void move(){
    x+=vx;
    y+=vy;
  }
  
  // ボールを表示する処理
  void disp(){
    gD.noStroke();
    gD.fill(0);
    gD.ellipse(x,y,r*2,r*2);
  }
}

// ブロックのクラス
class ArkBlock{
  float x,y,wid=10,hei=5;
  ArkBlock(float xTemp,float yTemp){
    x=xTemp;
    y=yTemp;
  }
  
  // ボールがブロックと衝突した時の処理
  void coll(){
    int collJ=0; // 衝突判定
    if(y-hei/2<arkBall.y&&arkBall.y<y+hei/2&&x-wid/2-arkBall.r<arkBall.x&&arkBall.x<x+wid/2+arkBall.r){ // ブロックの上下と衝突した時の処理
      arkBall.vx*=-1;
      if(arkBall.x<x){arkBall.x=x-wid/2-arkBall.r;}
      else{arkBall.x=x+wid/2+arkBall.r;}
      collJ=1;
    }else if(y-hei/2-arkBall.r<arkBall.y&&arkBall.y<y+hei/2+arkBall.r&&x-wid/2<arkBall.x&&arkBall.x<x+wid/2){ // ブロックの左右と衝突した時の処理
      arkBall.vy*=-1;
      if(arkBall.y<y){arkBall.y=y-hei/2-arkBall.r;}
      else{arkBall.y=y+hei/2+arkBall.r;}
      collJ=1;
    }else if(dist(arkBall.x,arkBall.y,x-wid/2,y-hei/2)<arkBall.r-0.1){ // ブロックの左上と衝突した時の処理
      float v=dist(0,0,arkBall.vx,arkBall.vy);
      float angleV=atan2(arkBall.vy,arkBall.vx);
      arkBall.vx=-v*cos(PI/2-angleV);
      arkBall.vy=-v*sin(PI/2-angleV);
      arkBall.x=x-wid/2-arkBall.r/sqrt(2);
      arkBall.y=y-hei/2-arkBall.r/sqrt(2);
      collJ=1;
    }else if(dist(arkBall.x,arkBall.y,x-wid/2,y+hei/2)<arkBall.r-0.1){ // ブロックの左下と衝突した時の処理
      float v=dist(0,0,arkBall.vx,arkBall.vy);
      float angleV=atan2(arkBall.vy,arkBall.vx);
      arkBall.vx=-v*cos(PI/2*3-angleV);
      arkBall.vy=-v*sin(PI/2*3-angleV);
      arkBall.x=x-wid/2-arkBall.r/sqrt(2);
      arkBall.y=y+hei/2+arkBall.r/sqrt(2);
      collJ=1;
    }else if(dist(arkBall.x,arkBall.y,x+wid/2,y-hei/2)<arkBall.r-0.1){ // ブロックの右上と衝突した時の処理
      float v=dist(0,0,arkBall.vx,arkBall.vy);
      float angleV=atan2(arkBall.vy,arkBall.vx);
      arkBall.vx=-v*cos(PI/2*3-angleV);
      arkBall.vy=-v*sin(PI/2*3-angleV);
      arkBall.x=x+wid/2+arkBall.r/sqrt(2);
      arkBall.y=y-hei/2-arkBall.r/sqrt(2);
      collJ=1;
    }else if(dist(arkBall.x,arkBall.y,x+wid/2,y+hei/2)<arkBall.r-0.1){ // ブロックの右下と衝突した時の処理
      float v=dist(0,0,arkBall.vx,arkBall.vy);
      float angleV=atan2(arkBall.vy,arkBall.vx);
      arkBall.vx=-v*cos(PI/2-angleV);
      arkBall.vy=-v*sin(PI/2-angleV);
      arkBall.x=x+wid/2+arkBall.r/sqrt(2);
      arkBall.y=y+hei/2+arkBall.r/sqrt(2);
      collJ=1;
    }
    if(collJ==1){ // 衝突した時の処理
      arkScore+=100; // 100点増える
      arkHi=max(arkHi,arkScore); // 現在の得点がハイスコアを上回ればそれを代入
      arkBlocks.remove(this); // ブロック消去
      soundArkBlock.rewind();
      soundArkBlock.play();
    }
  }
  
  // ブロックを表示する処理
  void disp(){
    gD.noStroke();
    gD.fill(0);
    gD.rect(x,y,wid-1,hei-1);
  }
}
