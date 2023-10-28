import std.stdio;
import std.string;
import std.conv;

extern (C++) void init(int width, int height);
extern (C++) void drawRect(int x, int y, int width, int height);
extern (C++) short tick();
extern (C++) void redraw();
extern (C++) void fillRect(int x, int y, int width, int height);
extern (C++) void setColor(int r, int g, int b, int a);
extern (C++) void createButton(int x, int y, int r, int g, int b, char* text);

extern (C) int SDL_GetMouseState(int* x, int* y);

// This does not match with specification of SDL. But apparently, it works.
// Problem could be caused because SDL_GetMouseState returns UInt32 (encoded C thingy)
enum int leftClick = 1;
enum int rightClick = 4;

enum int userClosedWindowSignal = 0;

void drawGrid(int offsetX, int offsetY, int width, int height) {
	for (int x = 0; x < width; x++) {
		for (int y = 0; y < height; y++) {
			drawRect(x * 20 + offsetX, y * 20 + offsetY, 20, 20);
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
    drawGrid(0, 0, 600 / 20, 600 / 20);

	// Create button
	createButton(650, 50, 0,0,0, cast(char*)toStringz("Text"));

	redraw();
    short signal = tick();
	writeln("Test");
	int[3] mouseState;
	bool clicked = false;
	int lastState;

	while (signal == userClosedWindowSignal) {
		signal = tick();
		mouseState[0] = SDL_GetMouseState(&mouseState[1], &mouseState[2]);
		writeln("x: " ~ to!string(mouseState[1]));
		writeln("y: " ~ to!string(mouseState[2]));
		if (mouseState[0] == leftClick) clicked = true;
		if (mouseState[0] != 0) lastState = mouseState[0];
	}
	if (clicked) writefln("Clicked! %x", lastState);
	else writefln("Mouse state: %x", lastState);
}