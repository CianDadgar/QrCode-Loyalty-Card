import processing.video.*;
final int MAX_STAMPS = 9;
ArrayList<PVector> coordinates = new ArrayList<PVector>();

PImage app;
PImage update;
PImage empty;



String decodedText;
Customer customer;
LoyaltyAPI API;
Capture webCamera;
boolean scanned;
boolean FREE_BEER = false;
int stamps;



void setup() {
  size(700, 1048);
  frameRate(30);
  
  startCamera();
  customer = null;
  scanned = false;
  API = null;
  stamps = -1;
  
  app = loadImage("app.png");
  update = loadImage("update.png");
  empty = loadImage("empty.png");
  
  coordinates.add(0, new PVector(150, 260));
  coordinates.add(1, new PVector(335, 260));
  coordinates.add(2, new PVector(500, 260));
  coordinates.add(3, new PVector(150, 380));
  coordinates.add(4, new PVector(335, 380));
  coordinates.add(5, new PVector(500, 380));
  coordinates.add(6, new PVector(150, 500));
  coordinates.add(7, new PVector(335, 500));
  coordinates.add(8, new PVector(500, 500));
  
}

void draw() {
  background(app);
  if (scanned == false){
    if (webCamera.available() == true) {
      webCamera.read();
      image(webCamera, 175, 300, 400, 350);
    }
}
else {
  fill(0, 0, 0);
  textAlign(CENTER, CENTER);
  if(FREE_BEER == true){
    FREE_BEER = false;
    text("Free Beer!," + customer.getName(), 30, 200, 640, 480);
  }
  else if(stamps >= 0){
    for(int i = 0; i < stamps; i++){
      PVector pos = coordinates.get(i);
      image(update, pos.x, pos.y, width/8, height/10 );
      println("DEBUG: Full cup index (" + i +") at position: (" + pos.x + ", " + pos.y + ")");
    }
    for(int i = stamps; i < MAX_STAMPS; i++) {
      PVector pos = coordinates.get(i);
      image(empty, pos.x, pos.y, width/8, height/10);
      println("DEBUG: Full cup index (" + i +") at position: (" + pos.x + ", " + pos.y + ")");
    }
  }
  else{
    text("Error scan", 30, 200, 640, 480);
  }
  noLoop();
}
}
void checkLoyaltyStatus() {
  stamps = API.getBeerStamps();
  println("DEBUG: Stamps: " + stamps);
  if (stamps > MAX_STAMPS) {
    API.resetCard();
    FREE_BEER = true;
    println("DEBUG: Customer Gets A Free Beer");
  }
}

void decodeQRCode(PImage img) {
    BarCodeReader qrReader = new BarCodeReader(img);
    String decoded = qrReader.decode();
    if(decoded != "Error: No Barcode"){
    customer = new Customer(qrReader.decode());
    API = new LoyaltyAPI(customer.getID());
    if(API != null) {
      println("DEBUG: Found customer: " + customer.getName() + " with ID: " + customer.getID());
      checkLoyaltyStatus();  
  }
}
else{
  println("DEBUG: Couldnt find a valid QR code");
}
scanned = true;
}
void keyPressed() {
  if (key == ' ') {
    PImage scr = get(0, 0, width, height);
    decodeQRCode(scr);
  }
  else if (key == ESC){
    exit();
  }
}
void stop(){
  webCamera.stop();
  println("DEBUG: All Done, Exiting");
}


void startCamera() {
  println("DEBUG: Initialising Camera, Please wait...");
  String[] cameras = Capture.list();

  if (cameras.length != 0) {
    webCamera = new Capture(this, 640, 480, cameras[0]);
    webCamera.start();
    
  }
}
