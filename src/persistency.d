module persistency;

import std.stdio, std.file;
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
        // switch (raw.Component.getAttribute("type")) {

        // }
        writeln(rawComponent.nodeValue);
    }
}