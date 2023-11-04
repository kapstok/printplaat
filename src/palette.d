module palette;

import std.string, std.stdio;

import components;
import input = input.delegates;
import field = input.field;

extern (C++) void redraw();
extern (C++) void drawRect(int x, int y, int width, int height);
extern (C++) void fillRect(int x, int y, int width, int height);
extern (C++) void fillCircle(int x, int y, int radius);
extern (C++) void setColor(int hex, int a);
extern (C++) void createButton(int x, int y, int* w, int* h, int hex, char* text);
extern (C++) void stampComponents();

public enum int printplaat = 0xF7E1D3;
public enum int node = 0xBDD0C4;
public enum int functionbar = 0x826F62;
public enum int item = 0xF8E2D4;
public enum int toolbar = 0x2E2016;

public int gridOffsetX = 0;
public int gridOffsetY = 0;

public void drawMainWindow() {
	int w, h;

 	// Background grid
	setColor(palette.printplaat, 0xff);
	fillRect(0,0,600,600);

	// Draw grid
	setColor(palette.node, 0xff);
	// Add one more to width and height to also show non-overflowing parts of grid
    drawGrid(gridOffsetX, gridOffsetY, 600 / 20 + 1, 600 / 20 + 1);
	drawComponents(gridOffsetX, gridOffsetY);

	// Show components
	stampComponents();

	// Background functionbar
	setColor(palette.functionbar, 0xff);
	fillRect(600, 0, 200, 600);

	// Create 'add Label' button
	createButton(650, 50, &w, &h, palette.item, cast(char*)toStringz("Text"));
	if (input.state == "Add Label") {
		setColor(palette.item, 0xff);
		drawRect(625, 40, w + 50, h + 20);
	}

	redraw();
}

void drawGrid(int offsetX, int offsetY, int width, int height) {
	for (int x = 0; x < width; x++) {
		for (int y = 0; y < height; y++) {
			fillCircle(x * 20 + offsetX, y * 20 + offsetY, 2);
		}
	}
}

void drawComponents(int offsetX, int offsetY) {
	foreach(Component component; components.getComponents()) {
		drawComponent(component, offsetX, offsetY);
	}
}

void drawComponent(Component component, int offsetX, int offsetY) {
	if (component.type == "Label") {
    	int w, h;

		// Visual appearance
        createButton(
            component.x + offsetX, component.y + offsetY,
            &w, &h, // Both variables are required, but they only have use when button is created in engine.cpp.
            palette.toolbar,
            cast(char*)toStringz((cast(Label)component).value));

		// Input appearance
        input.grid.addDelegate(
            field.Field(
                component.x + offsetX,
                component.y + offsetY,
                cast(int) component.w,
                cast(int) component.h,
                () {if (component.id != null) input.state = "Label " ~ component.id;}
            )
        );
    } else {
        writeln("::ERROR:: Unsupported component type!");
    }
}