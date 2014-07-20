float splashMountain=0; // スプラッシュが開始してからの時間
int splashMode=0; // 0のときは通常スプラッシュ、2のときはスキップ

void splash(){
  splashMountain++;
  if(splashMountain>100||splashMode==2){ // スプラッシュを終了する処理
    power=2; // ゲーム画面に移行
    if(cassetteSelect==0)arkSetup();
    if(cassetteSelect==1)conSetup();
    return;
  }
  
  if(splashMountain==10){ // ピコーンの音はワンテンポ遅れて流れる
    splashSound=minim.loadFile("splash.wav");
    splashSound.rewind();
    splashSound.play();
  }
  
  // FMSロゴ、フェードは四角で塗りつぶしてごまかす
  gD.imageMode(CENTER);
  gD.image(splashFMS,gD.width/2,gD.height/2);
  gD.fill(127,255,0,(abs(splashMountain/2-25)-21)*64);
  gD.noStroke();
  gD.rectMode(CORNER);
  gD.rect(0,0,gD.width,gD.height);
}
