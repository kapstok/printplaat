module persistency;

import std.stdio, std.file;
import std.conv;
import arsd.dom;

import components;

public void save(string path) {
    auto doc = new XmlDocument("<Components></Components><Wires></Wires>");

    string componentsXml = "";
    foreach(Component component; components.getComponents()) {
        componentsXml ~= component.toXml();
    }
    doc.querySelector("Components").innerRawSource(componentsXml);

    std.file.write(path, doc.toString());
    writeln("Machine saved!");
}

public void load(string path) {
    string data = path.exists ? readText(path) : "<Components></Components><Wires></Wires>";
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
            default:
                writeln("Invalid tag found: " ~ rawComponent.tagName);
        }
    }

    writeln(components.getComponents());
}