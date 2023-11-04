module components;

import arsd.dom;
import std.conv, std.stdio, std.string;

import palette;

extern (C++) void getFontWidthAndHeight(int* width, int* height, char* text);

private Component[] components;

public void push(Component component) {
    push(component, true);
}

public void push(Component component, bool redraw) {
    component.id = to!string(components.length);
    components ~= component;

    if (redraw) {
        palette.drawMainWindow();
    }
}

public Component[] getComponents() {
    return components;
}

abstract class Component {
    public immutable string type;
    public immutable int x, y, w, h;
    public string id = null;

    this(string type, int x, int y, int w, int h) {
        this.type = type;
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }

    // Should only be used with new Labels
    protected this(string type, string value, int x, int y) {
        int w, h;
        getFontWidthAndHeight(&w, &h, cast(char*)toStringz(value));
        this.type = type;
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }

    protected abstract string concreteClassToXml();

    public final string toXml() {
        auto xml = new Document()
            .createElement(type)
            .setAttribute("x", to!string(x))
            .setAttribute("y", to!string(y))
            .setAttribute("w", to!string(w))
            .setAttribute("h", to!string(h));

        xml.innerRawSource = concreteClassToXml();
        return xml.toString();
    }
}

class Label : Component {
    public string value;

    this(string value, int x, int y) {
        super("Label", value, x, y);
        this.value = value;
    }

    this(string value, int x, int y, int w, int h) {
        super("Label", x, y, w, h);
        this.value = value;
    }

    override protected string concreteClassToXml() {
        auto xml = new Document().createElement("Value");
        xml.innerText = value;
        return xml.toString();
    }
}

class Tweaker : Component {
    this(int x, int y, int w, int h) {
        super("Tweaker", x, y, w, h);
    }

    override protected string concreteClassToXml() {
        return "";
    }
}

class Clicker : Component {
    this(int x, int y, int w, int h) {
        super("Clicker", x, y, w, h);
    }

    override protected string concreteClassToXml() {
        return "";
    }
}