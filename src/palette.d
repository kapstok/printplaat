module palette;

import std.string, std.stdio, std.conv;

import components = entities.components;
import wires = entities.wires;
import input = input.delegates;
import field = input.field;

extern (C++) void redraw();
extern (C++) void drawRect(int x, int y, int width, int height);
extern (C++) void fillRect(int x, int y, int width, int height);
extern (C++) void fillCircle(int x, int y, int radius);
extern (C++) void setColor(int hex, int a);
extern (C++) void createButton(int x, int y, int* w, int* h, int hex, char* text);
extern (C++) int createComponent(const char* path, int x, int y, int w, int h);
extern (C++) void stampComponents();
extern (C++) void stampWires();
extern (C++) void drawWireLine(int startX, int startY, int endX, int endY);

public enum int printplaat = 0xF7E1D3;
public enum int node = 0xBDD0C4;
public enum int functionbar = 0x826F62;
public enum int item = 0xF8E2D4;
public enum int toolbar = 0x2E2016;

public enum int nodeDistance = 20;

public int gridOffsetX = 0;
public int gridOffsetY = 0;

public void drawMainWindow() {
 	// Background grid
	setColor(palette.printplaat, 0xff);
	fillRect(0,0,600,600);

	// Draw grid
	setColor(palette.node, 0xff);
	// Add one more to width and height to also show non-overflowing parts of grid
    drawGrid(gridOffsetX, gridOffsetY, 600 / nodeDistance + 1, 600 / nodeDistance + 1);
	drawComponents(gridOffsetX, gridOffsetY);

	// Show components and wires
	stampComponents();
	drawWire(
		new wires.Wire(
			new components.Clicker(20, 20, 20, 20),
			new components.Tweaker(60, 20, 20, 20)
		),
		8,
		8
	);
	stampWires();

	// Background functionbar
	setColor(palette.functionbar, 0xff);
	fillRect(600, 0, 200, 600);

	// Create 'add Label' button
	int w, h;
	createButton(650, 50, &w, &h, palette.item, cast(char*)toStringz("Text"));
	if (input.selection == "Add Label") {
		setColor(palette.item, 0xff);
		drawRect(625, 40, w + 50, h + 20);
	}

	// Create 'add Tweaker' button
	createButton(650, 150, &w, &h, palette.item, cast(char*)toStringz("Tweaker"));
	if (input.selection == "Add Tweaker") {
		setColor(palette.item, 0xff);
		drawRect(625, 140, w + 50, h + 20);
	}

	// Create 'add Clicker' button
	createButton(650, 250, &w, &h, palette.item, cast(char*)toStringz("Clicker"));
	if (input.selection == "Add Clicker") {
		setColor(palette.item, 0xff);
		drawRect(625, 240, w + 50, h + 20);
	}

	redraw();
}

void drawGrid(int offsetX, int offsetY, int width, int height) {
	for (int x = 0; x < width; x++) {
		for (int y = 0; y < height; y++) {
			fillCircle(x * nodeDistance + offsetX, y * nodeDistance + offsetY, 2);
		}
	}
}

void drawComponents(int offsetX, int offsetY) {
	foreach(components.Component component; components.getComponents()) {
		drawComponent(component, offsetX, offsetY);
	}
}

void drawComponent(components.Component component, int offsetX, int offsetY) {
	if (component.type == "Label") {
    	int w, h;

		// Visual appearance
        createButton(
            component.x + offsetX, component.y + offsetY,
            &w, &h, // Both variables are required, but they only have use when button is created in engine.cpp.
            palette.toolbar,
            cast(char*)toStringz((cast(components.Label)component).value)
		);

		// Input appearance
        input.grid.addDelegate(
            field.Field(
                component.x + offsetX,
                component.y + offsetY,
                cast(int) component.w,
                cast(int) component.h,
                () {if (component.id != null) input.selection = "Label " ~ component.id;}
            )
        );
    } else if (component.type == "Tweaker") {
		int w, h;

		// Visual appearance
		// TODO: do something with return value
        createComponent(
			cast(char*)toStringz("rsc/components/tweaker.png"),
            component.x + offsetX, component.y + offsetY,
			24, 24
		);

		// Input appearance
        input.grid.addDelegate(
            field.Field(
                component.x + offsetX,
                component.y + offsetY,
                24,
                24,
                () {if (component.id != null) input.selection = "Tweaker " ~ component.id;}
            )
        );
	} else if (component.type == "Clicker") {
		int w, h;

		// Visual appearance
		// TODO: do something with return value
        createComponent(
			cast(char*)toStringz("rsc/components/clicker.png"),
            component.x + offsetX, component.y + offsetY,
			24, 24
		);

		// Input appearance
        input.grid.addDelegate(
            field.Field(
                component.x + offsetX,
                component.y + offsetY,
                24,
                24,
                () {if (component.id != null) input.selection = "Clicker " ~ component.id;}
            )
        );
	} else {
        writeln("::ERROR:: Unsupported component type!");
    }
}

void drawWires(int offsetX, int offsetY) {
	foreach (wires.Wire wire; wires.getWires()) {
		drawWire(wire, offsetX, offsetY);
	}
}

void drawWire(wires.Wire wire, int offsetX, int offsetY) {
	drawWireLine(
		wire.output.x + offsetX,
		wire.output.y + offsetY,
		wire.output.x + offsetX + nodeDistance,
		wire.output.y + offsetY
	);

	drawWireLine(
		wire.input.x + offsetX - nodeDistance,
		wire.input.y + offsetY,
		wire.input.x,
		wire.input.y
	);
}