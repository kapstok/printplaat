import std.stdio;
import std.string;
import std.conv;

// Internal source files
import palette, persistency;
import input = input.delegates;

extern (C++) void init(int color, int width, int height);
extern (C++) void drawRect(int x, int y, int width, int height);
extern (C++) short tick();

extern (C) int SDL_GetMouseState(int* x, int* y);

// This does not match with specification of SDL. But apparently, it works.
// Problem could be caused because SDL_GetMouseState returns UInt32 (encoded C thingy)
enum int leftClick = 1;
enum int rightClick = 4;

enum int userClosedWindowSignal = 1;

void main() {
    init(palette.printplaat, 800, 600);

	persistency.load("/tmp/printplaat.xml");
	palette.drawMainWindow();
	input.functionBar.addDelegate(
		input.Field(650, 50, 42, 29, () { input.selection = "Add Label"; palette.drawMainWindow(); })
	);
	input.functionBar.addDelegate(
		input.Field(650, 150, 87, 29, () { input.selection = "Add Tweaker"; palette.drawMainWindow(); })
	);
	input.functionBar.addDelegate(
		input.Field(650, 250, 73, 29, () { input.selection = "Add Clicker"; palette.drawMainWindow(); })
	);

    short signal;
	int[3] mouseState;

	do {
		signal = tick();

		if (signal == 3) {
			mouseState[0] = SDL_GetMouseState(&mouseState[1], &mouseState[2]);
			if (mouseState[0] == leftClick) input.onLeftClick(mouseState[1], mouseState[2]);
		}
	} while (signal != userClosedWindowSignal);
}