
/*

 How to use openCV from APDE
 
 - install openCv java jar/dex
 - compile to app
 - extract app to eg. Aopencv_signed.apk 
 - add lib directory to this apk
 - re-sign this into Aopencv_signed2.apk
 - install this apk
 - enjoy
 
 pwd
 cd storage/shared/build/bin
 cp -r ../../Sketchbook/A_openCV/lib lib
 cp ../../Sketchbook/A_openCV/stuff/* .
 aapt add A_openCV.apk lib/armeabi-v7a/*
 apksigner sign --key testkey.pk8  --cert testkey.x509.pem A_openCV.apk
 

 */
 
import org.opencv.core.Core;
import org.opencv.imgproc.Imgproc;



PMat m;

PImage img,can;

float aspect;
float piwi;
boolean linked=false;

void setup() {
  fullScreen();
  textSize(64);
  String property = System.getProperty("java.library.path");
  println(property);
  //System.load( "/storage/emulated/0/Sketchbook/A_openCV/lib/armeabi-v7a/libopencv_java.so");
  // "/storage/emulated/0/Sketchbook/A_openCV/lib/armeabi-v7a/libopencv_java.so");
 /*
  Starting in Android 7.0, the system prevents apps from dynamically linking against non-NDK libraries,
 which may cause your app to crash.
 This change in behavior aims to create 
 a consistent app experience across platform updates 
 and different devices.
 Thank you so much  assholes
 */
  img=loadImage("athene.jpg");///"smile.png");
  piwi=width;
  aspect=1.0*img.height/img.width;
  if (aspect>1) piwi/=aspect;
  mouseX=width;
  try{
    can=canny(img);
    linked=true;
  }
  catch(java.lang.UnsatisfiedLinkError oops){
    oops.printStackTrace();
    println("Oops, no libopencv_java.so?"+
    "\n Add /lib to your APK."+
    "\n (and sorry, no preview mode...)");;
  }
}

PImage canny(PImage img){
 // println("now openCV");
  m=new PMat(img);
  //println("canning");
  float l=map(mouseX,0,width,10,180);
  float h=l*1.3;
  Imgproc.Canny(m,
     m,l,h);
  Core.bitwise_not( m,m );
  //println("canned");
  PImage can=m.get(this);
 // println("heat");
  return can;
}

void draw() {
  background(frameCount);
  image(img, 0, 10, piwi, piwi*aspect);
  if(linked){
    can=canny(img);
    image(can, 0, 20+piwi*aspect, piwi, piwi*aspect);
 }
  else
  {
    text("Sorry, no openCV",20,150+piwi*aspect);
  }
}




