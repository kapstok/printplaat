// This file contains code that interacts with app.d.

module input.delegates;

import std.stdio;

public import input.field : Field;

// TODO: Restructure code and place this somewhere else.
import palette;
import components, persistency;
import std.string;
extern (C++) void redraw();
extern (C++) void createButton(int x, int y, int* w, int* h, int hex, char* text);

public Field grid = Field(0, 0, 600, 600);
public Field functionBar = Field(600, 0, 200, 600);
public string state = "";

public void onLeftClick(int x, int y) {
    if (grid.isInField(x, y)) {
        writeln("Is in grid");
        addToGrid(x, y);
    } else if (functionBar.isInField(x, y)) {
        writeln("Is in function bar");
    } else {
        writeln("????");
    }
}

private void addToGrid(int x, int y) {
    if (state == "Add text") {
        state = "";
    	int w, h;
        drawMainWindow();
	    createButton(x, y, &w, &h, palette.toolbar, cast(char*)toStringz("[Your text here]"));
        grid.addDelegate(
            Field(x, y, w, h, () {state = "Text [ID]";})
        );
        redraw();

        // Test data
        components.Label label = new components.Label("[Your text here]", x, y, w, h);
        string path = "/tmp/printplaat.xml";
        persistency.save(label, path);
        persistency.load(path);
    } else if (state.startsWith("Text")) {
        state = "";
        writeln("Clicked on text!");
    }
}