class HatchLayer {
  ArrayList<Path> paths;
  ArrayList<Vehicle> vehicles;
  PGraphics canvas;
  int darkness, spacing;

  HatchLayer(int w, int h, int spacing, int darkness) {
    paths = new ArrayList<Path>();
    vehicles = new ArrayList<Vehicle>();
    canvas = createGraphics(w, h);
    this.darkness = darkness;
    this.spacing = spacing;
    
    setup();
  }

  void setup() {
    int w = canvas.width;
    int h = canvas.height;
    
    if (darkness == 0) {
      // do nothing
    }

    if (darkness > 0) {
      int num = int(float(w)/float(spacing));

      for (int i = 0; i < num; i++) {
        Path p1 = new Path();
        p1.addPoint(0, h-i*spacing);
        p1.addPoint(w-i*spacing, 0);
        paths.add(p1);
        if (i > 0) {
          Path p2 = new Path();
          p2.addPoint(i*spacing, h);
          p2.addPoint(w, i*spacing);
          paths.add(p2);
        }
      }
    }

    if (darkness > 1) {
      int num = int(float(w)/float(spacing));

      for (int i = 0; i < num; i++) {
        Path p1 = new Path();
        p1.addPoint(0, i*spacing);
        p1.addPoint(w-i*spacing, h);
        paths.add(p1);
        if (i > 0) {
          Path p2 = new Path();
          p2.addPoint(i*spacing, 0);
          p2.addPoint(w, h-i*spacing);
          paths.add(p2);
        }
      }
    }
    if (darkness > 2) {
      for (int i = 0; i < w; i+=spacing) {
        Path p = new Path();
        p.addPoint(i, 0);
        p.addPoint(i, h);
        paths.add(p);
      }
    }

    if (darkness > 3) {
      for (int i = 0; i < h; i++) {
        Path p = new Path();
        p.addPoint(0, i);
        p.addPoint(w, i);
        paths.add(p);
      }
    }

    for (Path p : paths) {
      boolean f = random(1) > 0.5;
      vehicles.add(new Vehicle(p.points.get(0), random(3, 7), random(0.2,0.5), new PVector(random(1,3), random(1,3)) ));
    }
    
    println("num vehicles: " + vehicles.size()); 
  }

  void update() {
  }

  void draw() {
    canvas.beginDraw();
    canvas.background(255);
    canvas.noFill();
    
    for (int i = 0; i < vehicles.size(); i++) {
      Vehicle v = vehicles.get(i);
      Path p = paths.get(i);
      v.follow(p);
      v.run(canvas);
    }
     canvas.endDraw();

  }
}

