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
    public const components.Component output;
    public const components.Component input;

    this(components.Component output, components.Component input) {
        this.output = output;
        this.input = input;
    }

    public final string toXml() {
        auto xml = new Document()
            .createElement("Wire")
            .setAttribute("output", to!string(output.id))
            .setAttribute("input", to!string(input.id));
        return xml.toString();
    }
}