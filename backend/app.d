import std.stdio;
import std.string;

extern (C++) void init(int width, int height);
extern (C++) void drawRect(int x, int y, int width, int height);
extern (C++) short tick();
extern (C++) void redraw();
extern (C++) void fillRect(int x, int y, int width, int height);
extern (C++) void setColor(int r, int g, int b, int a);
extern (C++) void createButton(int x, int y, int r, int g, int b, char* text);

void drawGrid(int width, int height) {
	for (int x = 0; x < width; x++) {
		for (int y = 0; y < height; y++) {
			drawRect(x * 20, y * 20, 20, 20);
		}
	}
}

void main() {
    init(600, 800);

	// Background grid
	setColor(0xa0, 0xa0, 0xff, 0xff);
	fillRect(0,0,600,600);

	// Background toolbar
	setColor(0xff, 0xff, 0xff, 1);
	fillRect(600, 0, 200, 600);

	// Draw grid
	setColor(0xC0,0xC0,0xE0,0xff);
    drawGrid(600 / 20, 600 / 20);

	// Create button
	createButton(650, 50, 0,0,0, cast(char*)toStringz("Text"));

	redraw();
    short signal = tick();
	writeln("Test");

	while (signal == 0) {
		signal = tick();
	}
}
