module entities.wires;

import arsd.dom;
import std.conv, std.stdio;
import palette;

import components = entities.components;
import entity = entities.entity;

private Wire[] wires;

public void push(Wire wire) {
    push(wire, true);
}

public void push(Wire wire, bool redraw) {
    wires ~= wire;

    if (redraw) {
        palette.drawMainWindow();
    }

    writeln("New Wire push:");
    writeln(wire.toXml());
}

public Wire[] getWires() {
    return wires;
}

class Wire : entity.Entity {
    public const components.Component output, input;

    public int horizontal, vertical;
    public bool left, up;

    this(components.Component output, components.Component input) {
        this.output = output;
        this.input = input;
        updatePath();
    }

    public final string toXml() {
        auto xml = new Document()
            .createElement("Wire")
            .setAttribute("output", to!string(output.id))
            .setAttribute("input", to!string(input.id));
        return xml.toString();
    }

    private void updatePath() {
        int outputX = (output.x / palette.nodeDistance) + 1;
        int outputY = output.y / palette.nodeDistance;
        int inputX = (input.x / palette.nodeDistance) - 1;
        int inputY = input.y / palette.nodeDistance;

        if (inputX - outputX > 0) {
            horizontal = inputX - outputX;
            left = false;
        } else {
            horizontal = outputX - inputX;
            left = true;
        }

        if (inputY - outputY > 0) {
            vertical = inputY - outputY;
            up = false;
        } else {
            vertical = outputY - inputY;
            up = true;
        }
    }
}