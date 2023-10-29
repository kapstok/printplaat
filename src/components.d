module components;

import arsd.dom;
import std.conv;

abstract class Component {
    public immutable string type;
    public immutable int x;
    public immutable int y;
    public immutable int w;
    public immutable int h;

    this(string type, int x, int y, int h, int w) {
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

    this(string value, int x, int y, int h, int w) {
        super("Label", x, y, h, w);
        this.value = value;
    }

    override protected string concreteClassToXml() {
        auto xml = new Document().createElement("Value");
        xml.innerText = value;
        return xml.toString();
    }
}