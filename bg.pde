float bgAppAni,beat; // 背景アニメーション
int beatBoy; // 1の時は本体がビートにノる
float cubeRX,cubeRY,cubeRZ; // キューブの回転
float[] cbAni=new float[13]; // キューブのアニメーション
int bgKonaKazu=36; // 粉の数を指定
BgKona[] bgKona=new BgKona[bgKonaKazu]; // 粉オブジェクトを生成

void bgSetup(){
  for(int c57=0;c57<bgKonaKazu;c57++){
    bgKona[c57]=new BgKona();
  }
}

void bg(){
  bgAppAni+=(bg-bgAppAni)*.3; // 背景出現アニメーション
  beat*=.8; // ビートを減衰させる
  
  // 地形をつくる
  pushMatrix();
  translate(width/2,height,0);
  rotateX(PI/2);
  if(bgAppAni>0.1){
    float bgl=120,mtrv=.5,spd=100;
    fill(0);
    strokeWeight(1);
    for(int cbgy=-14;cbgy<=2;cbgy++){
      stroke(255,bgAppAni*255);
      if(cbgy==-14)stroke(255,bgAppAni*255*(frameCount%spd)/spd);
      for(int cbgx=-10;cbgx<=10;cbgx++){
        beginShape();
        vertex(cbgx*bgl-bgl/2,(cbgy+frameCount%spd/spd)*bgl-bgl/2,-(1-bgAppAni)*100+300*(beat+.2)*(noise(4578+cbgx*mtrv,4578+(cbgy-floor(frameCount/spd))*mtrv,frameCount*.01)-.4));
        vertex(cbgx*bgl+bgl/2,(cbgy+frameCount%spd/spd)*bgl-bgl/2,-(1-bgAppAni)*100+300*(beat+.2)*(noise(4578+(cbgx+1)*mtrv,4578+(cbgy-floor(frameCount/spd))*mtrv,frameCount*.01)-.4));
        vertex(cbgx*bgl+bgl/2,(cbgy+frameCount%spd/spd)*bgl+bgl/2,-(1-bgAppAni)*100+300*(beat+.2)*(noise(4578+(cbgx+1)*mtrv,4578+(cbgy-floor(frameCount/spd)+1)*mtrv,frameCount*.01)-.4));
        vertex(cbgx*bgl-bgl/2,(cbgy+frameCount%spd/spd)*bgl+bgl/2,-(1-bgAppAni)*100+300*(beat+.2)*(noise(4578+cbgx*mtrv,4578+(cbgy-floor(frameCount/spd)+1)*mtrv,frameCount*.01)-.4));
        endShape(CLOSE);
      }
    }
  }
  popMatrix();
  
  // 粉を作る
  pushMatrix();
  translate(width/2,-200,-800+(1-bgAppAni)*300);
  if(bgAppAni>0.1){
    for(int c57=0;c57<bgKonaKazu;c57++){
      bgKona[c57].clock();
      bgKona[c57].sph();
      bgKona[c57].con();
    }
  }
  popMatrix();
    
  if(bgAppAni>0.1){
    // キューブアニメーション
    cubeRX+=0.0091+cbAni[4]*0.24;
    cubeRY+=0.0127+pow(cbAni[10],2)*0.3;
    cubeRZ+=0.0009+cbAni[12]*0.1+pow(cbAni[8],4)*0.9;
    for(int c92=0;c92<13;c92++){
      cbAni[c92]*=.8;
    }
  }
    
  // キューブをつくる
  fill(17,255*bgAppAni);
  strokeWeight(2);
  stroke(255-255*cbAni[7]-255*cbAni[9],255-255*cbAni[5]-102*cbAni[9],255-102*cbAni[5]-102*cbAni[7],255*bgAppAni);
  
  for(int flip=-1;flip<2;flip+=2){
    pushMatrix();
    translate(width/2+width*.62*flip+20*pow(cbAni[1],4)*flip,height/3+20*pow(cbAni[3],2),-600+100*bgAppAni+cos(frameCount*PI)*15*cbAni[11]);
    rotateX(cubeRX);
    rotateY(cubeRY*flip);
    rotateZ(cubeRZ*flip);
    box(140+beat*20-cbAni[2]*15+pow(cbAni[6],2.5)*60,140+beat*20-cbAni[2]*15+cbAni[0]*20,140+beat*20-cbAni[2]*15);
    popMatrix();
  }
}

// 粉のクラス
class BgKona{
  float tx=random(99),ty=random(99),tz=random(99);
  float r=9;
  float lx=random(.2),ly=random(.2),lz=random(.2);
  float mx=800,my=600,mz=200;
  float x,y,z;
  float gx,gy,gz;
  BgKona(){
  }
  
  void clock(){
    float sum=0;
    for(int c=0;c<13;c++){
      sum+=pow(cbAni[c],2);
    }
    tx+=sum*noise(124,frameCount)*.02;
    ty+=sum*noise(1856,frameCount)*.02;
    tz+=sum*noise(954,frameCount)*.02;
    x=cos(lx*frameCount*.01+tx)*mx;
    y=cos(ly*frameCount*.01+ty)*my;
    z=cos(lz*frameCount*.01+tz)*mz;
    gx=(x-gx)*.2;
    gy=(y-gy)*.2;
    gz=(z-gz)*.2;
  }
  
  void sph(){
    noStroke();
    fill(bgAppAni*191);
    pushMatrix();
    translate(x,y,z);
    ellipse(0,0,r,r);
    popMatrix();
  }
  
  void con(){
    for(int c57=0;c57<bgKonaKazu;c57++){
      BgKona otherKona=bgKona[c57];
      if(dist(x,y,z,otherKona.x,otherKona.y,otherKona.z)<191*2){
        stroke(255,bgAppAni*191-0.5*dist(x,y,z,otherKona.x,otherKona.y,otherKona.z));
        line(x,y,z,otherKona.x,otherKona.y,otherKona.z);
      }
    }
  }
}
