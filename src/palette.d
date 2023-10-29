module palette;

// Only for testing
import std.stdio;
import std.conv;

import std.string;

extern (C++) public void redraw();

extern (C++) void fillRect(int x, int y, int width, int height);
extern (C++) void fillCircle(int x, int y, int radius);
extern (C++) void setColor(int hex, int a);
extern (C++) void createButton(int x, int y, int* w, int* h, int hex, char* text);

public enum int printplaat = 0xF7E1D3;
public enum int node = 0xBDD0C4;
public enum int functionbar = 0x826F62;
public enum int item = 0xF8E2D4;
public enum int toolbar = 0x2E2016;

public int gridOffsetX = 0;
public int gridOffsetY = 0;

public void drawMainWindow() {
 	// Background grid
	setColor(palette.printplaat, 0xff);
	fillRect(0,0,600,600);

	// Draw grid
	setColor(palette.node, 0xff);
	// Add one more to width and height to also show non-overflowing parts of grid
    drawGrid(gridOffsetX, gridOffsetY, 600 / 20 + 1, 600 / 20 + 1);

	// Background functionbar
	setColor(palette.functionbar, 0xff);
	fillRect(600, 0, 200, 600);

	// Create button
	int w, h;
	createButton(650, 50, &w, &h, palette.item, cast(char*)toStringz("Text"));
    writeln("w: " ~ to!string(w) ~ ", h: " ~ to!string(h));
}

void drawGrid(int offsetX, int offsetY, int width, int height) {
	for (int x = 0; x < width; x++) {
		for (int y = 0; y < height; y++) {
			fillCircle(x * 20 + offsetX, y * 20 + offsetY, 2);
		}
	}
}
