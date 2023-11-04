// This file contains code that interacts with app.d.

module input.delegates;

import std.stdio, std.string;

public import input.field : Field;
import palette;
import components, persistency;

extern (C++) void redraw();
extern (C++) void createButton(int x, int y, int* w, int* h, int hex, char* text);

public Field grid = Field(0, 0, 600, 600);
public Field functionBar = Field(600, 0, 200, 600);
public string state = "";

// TODO: Should not be hardcoded
private string path = "/tmp/printplaat.xml";

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
        components.push(label);
        persistency.save(path);
    } else if (state.startsWith("Label ")) {
        writeln(state);
        state = "";
    } else if (state == "Add Tweaker") {
        state = "";

        components.Tweaker tweaker = new components.Tweaker(x, y, 24, 24);
        components.push(tweaker);
        persistency.save(path);
    } else if (state.startsWith("Tweaker ")) {
        writeln(state);
        state = "";
    } else if (state == "Add Clicker") {
        state = "";

        components.Clicker clicker = new components.Clicker(x, y, 24, 24);
        components.push(clicker);
        persistency.save(path);
    } else if (state.startsWith("Clicker ")) {
        writeln(state);
        state = "";
    }
}