module persistency;

import std.stdio, std.file;
import std.conv;
import arsd.dom;

import components;

public void save(Component component, string path) {
    std.file.write(path, component.toXml());
}

public void load(string path) {
    string data = path.exists ? readText(path) : "<Components></Components><Wires></Wires>";
    auto doc = new XmlDocument("<Components>" ~ data ~ "</Components><Wires></Wires>");

    writeln(doc.toString());
    foreach(Element rawComponent; doc.querySelector("Components").childNodes) {
        switch (rawComponent.tagName) {
            case "Label":
                string value = rawComponent.querySelector("Value").nodeValue();
                components.Label label = new components.Label(
                    value,
                    to!int(rawComponent.getAttribute("x")),
                    to!int(rawComponent.getAttribute("y")),
                    to!int(rawComponent.getAttribute("h")),
                    to!int(rawComponent.getAttribute("w"))
                );
                components.components ~= label;
                break;
            default:
                writeln("Invalid tag found: " ~ rawComponent.tagName);
        }
    }

    writeln(components.components);
}