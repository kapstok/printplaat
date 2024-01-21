module persistency;

import std.stdio, std.file;
import std.conv;
import arsd.dom;

import components = entities.components;
import wires = entities.wires;

public void save(string path) {
    auto doc = new XmlDocument("<Machine><Components></Components><Wires></Wires></Machine>");

    string componentsXml = "";
    foreach(components.Component component; components.getComponents()) {
        componentsXml ~= component.toXml();
    }
    doc.querySelector("Components").innerRawSource(componentsXml);

    string wiresXml = "";
    foreach(wires.Wire wire; wires.getWires()) {
        wiresXml ~= wire.toXml();
    }
    doc.querySelector("Wires").innerRawSource(wiresXml);

    std.file.write(path, doc.toString());
    writeln("Machine saved!");
}

public void load(string path) {
    string data = path.exists ? readText(path) : "<Machine><Components></Components><Wires></Wires></Machine>";
    auto doc = new XmlDocument(data);

    writeln(doc.toString());

    foreach(Element rawComponent; doc.querySelector("Components").childNodes) {
        switch (rawComponent.tagName) {
            case "Label":
                string value = rawComponent.querySelector("Value").innerText;
                components.Label label = new components.Label(
                    value,
                    to!int(rawComponent.getAttribute("x")),
                    to!int(rawComponent.getAttribute("y")),
                    to!int(rawComponent.getAttribute("w")),
                    to!int(rawComponent.getAttribute("h"))
                );
                components.push(label, false);
                break;
            case "Tweaker":
                components.Tweaker tweaker = new components.Tweaker(
                    to!int(rawComponent.getAttribute("x")),
                    to!int(rawComponent.getAttribute("y")),
                    to!int(rawComponent.getAttribute("w")),
                    to!int(rawComponent.getAttribute("h"))
                );
                components.push(tweaker, false);
                break;
            case "Clicker":
                components.Clicker clicker = new components.Clicker(
                    to!int(rawComponent.getAttribute("x")),
                    to!int(rawComponent.getAttribute("y")),
                    to!int(rawComponent.getAttribute("w")),
                    to!int(rawComponent.getAttribute("h"))
                );
                components.push(clicker, false);
                break;
            default:
                writeln("Invalid tag found: " ~ rawComponent.tagName);
                break;
        }
    }

    foreach(Element rawWire; doc.querySelector("Wires").childNodes) {
        writeln("foo");
        int outputId = to!int(rawWire.getAttribute("output"));
        writeln("bar");
        int inputId = to!int(rawWire.getAttribute("input"));
        wires.Wire wire = new wires.Wire(
            components.getComponents()[outputId],
            components.getComponents()[inputId]
        );
        wires.push(wire, false);
    }

    writeln(components.getComponents());
    writeln(wires.getWires());
}