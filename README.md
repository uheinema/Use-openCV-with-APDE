# Using openCV from APDE

In order to use openCV (or any other library relying on .so natiive libraries),
it is necessary to add these .so files to

- somewhere like /system/lib...
  - no idea how
- in a lib subdir of the APK

Unfortunately, the build process in APDE is not designed to do so ( and hardcoded in Java), so we have to add them after the build - here is how.

An alternative SHOULD have been to explicitely load them at runtime, but alas:
> Starting in Android 7.0, the system prevents apps from dynamically linking against non-NDK libraries,
 which may cause your app to crash.
 This change in behavior aims to create 
 a consistent app experience across platform updates 
 and different devices.
 
 
 Thank you so much, Android.
 
 ## Tools
 
 - APDE
 - TotalCommander
    (or the file manager app of your choice. Should be able to manipulate the contents of ZIP/JAR/APK files)
    
 - APK Editor 
   (or any other tool able to sign an APK)
   
 and/or
 - TermUX

## Preliminarys

- Put the contents of this repository in a sketch named `A_openCV`

- In APDE set 
     - Build on internal - off
     - Keep build folder - on
 
 - Get the needed JAR/DEX and SO files.
   - Go to the OpenCV Android Sourceforge page and download the latest OpenCV Android library OR
   - I added the needed files in the `library` (jar) and `lib`(so) folders for convenience.
 
 The jar and -dex.jar go to any library/library-dex subsubdirectory in Sketchbook/libraries.
 
 You should then be able to compile and run the provided A_openCV.pde example  sketch - 
 without openCV functionality, yet.
 
 Now build a non-preview app (could not figure out how to hack preview yet).
 
 In the build folder (parallel to sketchbook) there now should be a file
 `build/bin/A_openCV.apk` - this is the one we will manipulate.
 
 
 ## Manual adding the lib*.so
 
 You need to
 
 ### Copy the provided lib folder into the APK.
  Do so, it is just a ZIP file with a different extension.
  Should look like   
              -- res   
              -- assets   
              -- lib   
              -- ....etc pp   
 now.
 
 ### This manipulated APK must now be signed again.
 
 Just load it with eg. `APK Editor`
 - full edit 
 - decode all 
 - save
 
Bingo, you now should have
/storage/emulated/0/ApkEditor/A_openCV_signed.apk

 Install, enjoy.
 
 ![Screenshot_20201002_155205_processing.test.a_opencv](Screenshot_20201002_155205_processing.test.a_opencv.jpg)
 
 This is less effort than it seems,  but still an annoyance if you are actually developing in APDE (like me) - has to b e done on every recompile.
 
 So it might make sense to automate this somewhat.
 
 ## Scripted with TermUX
 
 Fortunately TermUX has all the necessary tools.
 
 - Install TermUX and set it up to access shared ('external') storage.
 - (optional) Establish the 'execute on edit' trick (so any file you send to termUX for 'edit'ing  gets executed as a shell script
 
 In termUX install aapt and apksigner:
 ```
 apt install aapt 
 apt install apksigner
 ```
 Go to
 `
 cd storage 
 cd shared 
 cd build 
 cd bin 
 ls 
 `
 and you should see the bin directory of above.
 
 Here is a script to do the copying and resigning (also in addso.termux):
 
 ```
 #!
# addso - add the so parts of opencv to a sketch
#
# note this uses the Termux
# way to access external storage 
#
sketchbook=$HOME/storage/shared/Sketchbook
apkdir=$HOME/storage/shared/build/bin
name=A_openCV
read -e -p "Sketch to patch [$name]:"  sketchname
sketchname=${sketchname:-$name}
apk=${sketchname}.apk
#
cd $apkdir
cp -r ${sketchbook}/${sketchname}/lib lib
cp -r ${sketchbook}/${sketchname}/stuff/* .
#
 aapt add $apk lib/armeabi-v7a/*
 apksigner sign --key testkey.pk8  --cert testkey.x509.pem $apk
 #
read -p 'No news is good news.' fakenews
#
 
 ```



