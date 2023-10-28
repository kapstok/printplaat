//import psychometry;
//import imageformats;

import std.stdio;

extern (C++) void init();
extern (C++) void draw(int row, int column, int x, int y);
extern (C++) void render();


ubyte[] result;
/*
ubyte* decode() {
    Converter converter = new Converter(new LSBMode(64));
    IFImage underwroteImage = read_png("./result.png");
    result = converter.decode(underwroteImage.pixels);
    writeln(cast(string)result);
	return result.ptr;
}

extern (C++) ubyte* foo() {
    //writeln("foo");
    // init();
    // draw(3, 3, 0, 0);
    // draw(3, 3, 2, 2);
    // draw(3, 3, 1, 1);
    // render();
    main();
    return decode;
}
*/

extern (C++) void foo() {
    main();
}

void main() {
    init();
    draw(3,3,0,0);
    draw(3,3,2,2);
    draw(3,3,1,1);
    render();
}
