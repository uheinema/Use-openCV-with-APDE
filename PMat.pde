/*

NOT HERE!
import java.awt.image.BufferedImage;
 import java.awt.image.DataBufferInt;
 */

import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.CvType;

import java.nio.*;

// who needs more??

class PMat extends Mat {
  
  public PMat(PImage img) {
    super( img.height,img.width,CvType.CV_8UC4);
    setImage(img); // sets BGRA
  }


  // kranker scheiss...das muss einfacher gehen..
  // memmapped file bytebuffer, byteorder???



  /**
   	 * Convert a Processing PImage to an OpenCV Mat.
   	 * (Inspired by Kyle McDonald's ofxCv's toOf())
   	 * 
   	 * @param img
   	 * 		The PImage to convert.
   	 * @param m
   	 * 		The Mat to receive the image data.
   	 */
  public // static 
    void toCv(PImage img, Mat m) {
    //	BufferedImage image = (BufferedImage)img.getNative();
    img.loadPixels();
    // getnative is an 
    // android.graphics.Bitmap..but why assume that..
    int[] matPixels = img.pixels;
    //((DataBufferInt)image.getRaster().getDataBuffer()).getData();
    // krank..
    ByteBuffer bb = ByteBuffer.allocate(matPixels.length * 4);
    IntBuffer ib = bb.asIntBuffer();
    ib.put(matPixels);

    byte[] bvals = bb.array();

    m.put(0, 0, bvals);
  }


  
  
  public void setImage(PImage img) {				
    toCv(img, this);
    ARGBtoBGRA();
  }

  public 
    void ARGBtoBGRA() {
    ArrayList<Mat> channels = new ArrayList<Mat>(4);
    Core.split(this, channels);

    ArrayList<Mat> reordered = new ArrayList<Mat>(4);
    // Starts as ARGB. 
    // Make into BGRA.

    reordered.add(channels.get(3));
    reordered.add(channels.get(2));
    reordered.add(channels.get(1));
    reordered.add(channels.get(0));

    Core.merge(reordered, this);
  }

  public PImage get(PApplet parent) {
    PImage result = parent.createImage(width(), rows(), PApplet.ARGB);
    toPImage(this, result);
    return result;
  }

  public void toPImage(Mat m, PImage img) {	
    img.loadPixels(); 
    
    // really? we are overwriting them next..
    if (m.channels() == 3) {
      Mat m2 = new Mat();
      Imgproc.cvtColor(m, m2, Imgproc.COLOR_RGB2RGBA);
      img.pixels = matToARGBPixels(m2);
    } else if (m.channels() == 1) {
      Mat m2 = new Mat();
      Imgproc.cvtColor(m, m2, Imgproc.COLOR_GRAY2RGBA);
      img.pixels = matToARGBPixels(m2);
    } else if (m.channels() == 4) {
      img.pixels = matToARGBPixels(m);
    }
    img.updatePixels();
  }


  /**
   * 
   * Convert a 4 channel OpenCV Mat object into 
   * pixels to be shoved into a 4 channel ARGB PImage's
   * pixel array.
   * 
   * @param m
   * 		An RGBA Mat we want converted 
   * @return
   * 		An int[] formatted to be the pixels of a PImage
   */
  public int[] matToARGBPixels(Mat m) {
    int pImageChannels = 4;
    int numPixels = m.width()*m.height();
    int[] intPixels = new int[numPixels];
    byte[] matPixels = new byte[numPixels*pImageChannels];

    m.get(0, 0, matPixels);
    ByteBuffer.wrap(matPixels).order(ByteOrder.LITTLE_ENDIAN).asIntBuffer().get(intPixels);
    return intPixels;
  }
}

