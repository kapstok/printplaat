// This file contains code that interacts with app.d.

module input.delegates;

import std.stdio, std.string;

public import input.field : Field;

import palette;
import components, persistency;
import std.string;

extern (C++) void redraw();
extern (C++) void createButton(int x, int y, int* w, int* h, int hex, char* text);

// Temporary for testing
extern (C++) void resetComponents();

public Field grid = Field(0, 0, 600, 600);
public Field functionBar = Field(600, 0, 200, 600);
public string state = "";

public void onLeftClick(int x, int y) {
    if (grid.isInField(x, y)) {
        writeln("Is in grid");
        inputToGrid(x, y);
    } else if (functionBar.isInField(x, y)) {
        writeln("Is in function bar");
    } else {
        writeln("????");
    }
}

private void inputToGrid(int x, int y) {
    if (state == "Add Label") {
        state = "";

        components.Label label = new components.Label("[Your text here]", x, y);
        resetComponents();
        components.push(label);
        string path = "/tmp/printplaat.xml";
        persistency.save(path);
    } else if (state.startsWith("Label ")) {
        writeln(state);
        state = "";
    }
}