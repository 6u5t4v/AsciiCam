import processing.video.*;

/* HVILKE SYMBOLER SKAL PROGRAMMET BRUGE
 *
 * Fjern "//" for at bruge indstilling
 * Kun en af følgende kan være aktiv adgangen
 * så tilføj "//" ved den du ikke bruger.
 */
//final String density = "Ñ@#W$9876543210?!abc;:+=-,._ ";
//final String density = "Ñ@#W$9876543210?!abc;:+=-,._                    ";
final String density = "       .:-i|=+%O#@";



Capture cam;
PFont font;

String asciiPreview;

final int len = density.length();

void setup() {
  // Vinduets størrelse, dette afgøre også resolutionen
  // kameraet optager i.

  // Vindue      Kamera
  // 1500x1000 = 150x100
  size(1500, 1000);

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);

    /* KAMERA RESOLUTION
     *
     * default er 150x100
     * for bedste resolution kamera resolutionen
     *
     */
    cam = new Capture(this, width/10, height/10, cameras[0]);
    cam.start();
  }

  font = createFont("Courant", 16, true);
  textFont(font);
}



void draw() {
  background(0);

  if (cam.available()) {
    cam.read();
  }
  cam.loadPixels();

  /* Fjern "//" for at se hvad kameraet ser*/
  //set(0, 0, cam);

  String asciiFrame = "";
  for (int i = 0; i < cam.height; i++) {
    for (int j = 0; j < cam.width; j++) {
      final color col = cam.get(j, i);
      final float r = red(col);
      final float g = green(col);
      final float b = blue(col);

      final float avg = (r + g + b) / 3;

      /* INVERTER FARVERNE
       *
       * Fjern "//" for at bruge indstilling
       * Kun en af følgende kan være aktiv adgangen
       * så tilføj "//" ved den du ikke bruger.
       */
      //final int charIndex = floor(map(avg, 0, 255, len-1, 0)); // Lyst hvor der er mørkt
      final int charIndex = floor(map(avg, 0, 255, 0, len-1)); // Mørkt hvor der er lyst

      char c = density.charAt(charIndex);

      asciiFrame += c;
    }
    asciiFrame += "\n";
  }

  noStroke();
  fill(255);
  textLeading(10);
  text(asciiFrame, 0, 0);
}
