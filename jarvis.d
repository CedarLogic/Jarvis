module main;
import std.stdio;
import std.getopt;
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
	RED = "\033[41m",
	LIGHTBLUE = "\033[46m",
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

void format_out(string tag, int importance, string note, string link, string time ) {
	if(note){
		writeln( time ~ "\t" ~ note ~ "\t" ~ to!string(importance) ~ "\t\n\tTag: " ~ BLUE ~ tag ~ END_COLOR);
	}
	else {
		writeln( time ~ "\t" ~ link ~ "\t" ~ to!string(importance) ~ "\t\n\tTag: " ~ BLUE ~ tag ~ END_COLOR);
	}
}


void main(string[] args) {
	string note, link, tag;
	int importance;
	int read;

	getopt(args, "note|n", &note, "link|l", &link, "tag", &tag, "i", &importance, "r", &read);

	if(!read) {
		if(!note && !link){
			writefln("\tTell me, What are you thinking of...");
			return;
		}

		if(importance > 5 && importance < 0 ) {
			writefln("Important status need to be in range [1-5]");
			return;
		}

		write_to_storage(tag, importance, note, link);
	}
	else {
		string read_note, read_link, read_tag, read_time;
		int read_imp;

		string [] strs = read_lines();
		foreach(s; strs) {
			if(s == ""){
				return;
			}
			parse_str(s, read_tag, read_imp, read_note, read_link, read_time);
			format_out(read_tag, read_imp, read_note, read_link, read_time);
		}
	}
	return;
}