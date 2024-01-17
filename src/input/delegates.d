// This file contains code that interacts with app.d.

module input.delegates;

import std.stdio, std.string, std.conv;

public import input.field : Field;
import palette;
import components, persistency;

extern (C++) void redraw();
extern (C++) void createButton(int x, int y, int* w, int* h, int hex, char* text);
extern (C++) char* openProperties(const char* data);

public Field grid = Field(0, 0, 600, 600);
public Field functionBar = Field(600, 0, 200, 600);
public string selection = "";
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
    if (state.startsWith("Select ")) { // If we need to select a component for our properties window
        components.Component originalComponent = components.getComponents()[to!int(state[7..$])];
        string output;
        if (originalComponent.type == "Clicker") {
            output = "type: Clicker\noutput: " ~ selection ~ "\n";
        } else if (originalComponent.type == "Tweaker") {
            output = "type: Tweaker\ninput: " ~ selection ~ "\n";
        } else {
            writeln("Don't know what to do!");
            output = "";
        }
        char[] input = fromStringz(openProperties(cast(char*)toStringz(output)));
        interpretInputFromProperties(input);
        state = "";
    } else if (selection == "Add Label") {
        selection = "";

        components.Label label = new components.Label("[Your text here]", x, y);
        components.push(label);
        persistency.save(path);
    } else if (selection.startsWith("Label ")) {
        writeln("Selection: " ~ selection);
        selection = "";
    } else if (selection == "Add Tweaker") {
        selection = "";

        components.Tweaker tweaker = new components.Tweaker(x, y, 24, 24);
        components.push(tweaker);
        persistency.save(path);
    } else if (selection.startsWith("Tweaker ")) {
        writeln("Selection: " ~ selection);
        selection = "";
        writeln("OUTPUT: " ~ fromStringz(openProperties(cast(char*)toStringz("type: Tweaker\ninput: "))));
    } else if (selection == "Add Clicker") {
        selection = "";

        components.Clicker clicker = new components.Clicker(x, y, 24, 24);
        components.push(clicker);
        persistency.save(path);
    } else if (selection.startsWith("Clicker ")) {
        writeln("Selection: " ~ selection);
        char[] input = fromStringz(openProperties(cast(char*)toStringz("type: Clicker\noutput: ")));
        interpretInputFromProperties(input);
    }
}

private void interpretInputFromProperties(char[] input) {
    if (input.startsWith("SELECT\n")) {
        state = "Select " ~ selection[8..$];
        selection = "";
        writeln("State: " ~ state);
    } else if (input.startsWith("CHANGE DATA\n")) { // TODO: Interpret CHANGE DATA
        selection = "";
    } else {
        writeln("Unable to handle input:\n" ~ input);
        selection = "";
    }
}