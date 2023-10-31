module input.field;

public struct Field {
    protected Field[] subFields;
    protected void function() @safe action;
    protected void delegate() @safe delegateAction;
    protected int x, y, w, h;

    this(int x, int y, int w, int h) {
        this(x, y, w, h, () {});
    }

    this(int x, int y, int w, int h, void function() @safe action) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.action = action;
        this.delegateAction = null;
    }

    this(int x, int y, int w, int h, void delegate() @safe delegateAction) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.action = () {};
        this.delegateAction = delegateAction;
    }

    public bool isInField(int x, int y) {
        bool result;

        result = x >= this.x && x < this.x + this.w;
        result &= y >= this.y && y < this.y + this.h;

        if (result) {
            delegateAction == null ? action() : delegateAction();

            foreach (Field subField; subFields) {
                subField.isInField(x, y);
            }
        }

        return result;
    }

    public ulong addDelegate(Field field) {
        subFields ~= field;
        return subFields.length - 1;
    }
};