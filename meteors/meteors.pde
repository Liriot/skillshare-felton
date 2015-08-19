// LIBRARIES
import processing.pdf.*;

// GLOBAL VARS
PShape map;
Table table;
PFont font;

// SETUP
void setup () {
  size(1800, 900);
  map = loadShape("WorldMap.svg");

  table = loadTable("MeteorStrikesDataSet.csv", "header");

  font = createFont("Avenir-Medium", 12);

  noLoop();
}

// DRAW
void draw () {
  beginRecord(PDF, "meteor-strikes.pdf");
  shape(map, 0, 0, width, height);
  noStroke();

  for (TableRow row : table.rows()) {
    // Cache row data
    String place = row.getString("place");
    int year = row.getInt("year");
    int mass = row.getInt("mass_g");
    float lng = row.getFloat("longitude");
    float lat = row.getFloat("latitude");
    String type = row.getString("fell_found");

    // Blue markers for fallen meteors, orange markers for found
    fill(type.equals("Fell") ? 0x644D94B0 : 0x64D9653B);
    noStroke();

    // Map lat/long coordinates to world map height/width
    float mapLong = map(lng, -180, 180, 0, width);
    float mapLat = map(lat, 90, -90, 0, height);

    // Add markers
    float markerSize = 0.05 * sqrt(mass) / PI;
    ellipse(mapLong, mapLat, markerSize, markerSize);

    // Highlight 20 largest meteors (first 20 rows in dataset)
    if (mass > 3000000) {
      fill(0);
      textFont(font);
      text(place, mapLong + markerSize + 5, mapLat + 4);
      noFill();
      stroke(0);
      line(mapLong + markerSize / 2, mapLat, mapLong + markerSize, mapLat);
    }
  }

  endRecord();
}
