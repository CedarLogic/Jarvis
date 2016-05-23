module header;
import std.stdio;
import std.file;
import std.datetime;
import std.string;
import std.array;
import std.conv;
import std.algorithm;

enum {
	GREEN = "\033[1;32m", 
	YELLOW = "\033[33m", 
	BLUE = "\033[34m", 
	RED = "\033[31m",
	CYAN = "\033[0;36m",
	MAGENTA = "\033[0;35m",
	GRAY = "\033[0;37m",
	END_COLOR = "\033[0m",

	FLAG = "🏴"
}


string filename = "storage";

void write_to_storage(string tag, int importance=1, string note=null, string link=null){
	File file = File(filename, "a");

	DateTime dateTime;
	dateTime = cast(DateTime)Clock.currTime();

	file.write( dateTime );
	file.write( ";" );

	if(note) {
		file.write("Str:" ~ note ~ ";");
	}
	else if(link) {
		file.write("Link:" ~ link ~ ";");
	}

	if(importance) {
		file.write("Importance:" ~ to!string(importance) ~ ";");
	}

	file.write("Tag:" ~ tag );
	file.writeln();
	file.close();

}

string[] read_lines() {
	string input = cast(string)std.file.read(filename);
    Appender!(string[]) result;
    foreach (line; input.splitter("\n"))
        result.put(line);
    return result.data;
}


void parse_str(string s, ref string tag, ref int importance, ref string note, ref string link, ref string time ) {
	string [] arr = split(s, ";");
	time = arr[0];
	string [] tmp = split(arr[1], ":");
	if(tmp[0] == "Str") {
		note = tmp[1];
	}
	else if (tmp[0] == "Link") {
		link = tmp[1];
	}
	// importance
	tmp = split(arr[2], ":");
	importance = to!int(tmp[1]);

	// tag
	tmp = split(arr[3], ":");
	tag = tmp[1];
}

string format_importance(int importance) {
	string imp;
	switch (importance) {
		case 1:
			imp = FLAG;
			break;
		case 2:
			imp = YELLOW ~ FLAG ~ END_COLOR;
			break;
		case 3:
			imp = CYAN ~ FLAG ~ END_COLOR;
			break;
		case 4:
			imp = MAGENTA ~ FLAG ~ END_COLOR;
			break;
		case 5:
			imp = RED ~ FLAG ~ END_COLOR;
			break;
		default:
			imp = FLAG;
	}
	return imp;
}

void format_out(string tag, int importance, string note, string link, string time ) {
	if(note){
		write( time ~ "\t" ~ note ~ "\t");
		write( format_importance( importance ) );
		writeln( "\t\n\tTag: " ~ BLUE ~ tag ~ END_COLOR);
	}
	else {
		write( time ~ "\t" ~ link ~ "\t");
		write( format_importance( importance ) );
		writeln( "\t\n\tTag: " ~ BLUE ~ tag ~ END_COLOR);
	}
}