module utils;
import std.stdio;
import std.file;
import std.datetime;
import std.string;
import std.array;
import std.conv;
import std.algorithm;
import std.range;

/** color formatting in terminal if it has color support */
bool COLOR_SUPPORT = false;
/** storage name where all information will be stored */
string FILENAME = ".storage";

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

/**
 * Write stuff to storage file.
 * Throws: FileException on failure.
 */
void write_to_storage(string tag, int importance=1, string note=null, string link=null){
	File file = File(FILENAME, "a");
	try {
		DateTime dateTime;
		dateTime = cast(DateTime)Clock.currTime();

		file.write( dateTime );
		file.write( ";" );

		if(note) {
			file.write("Str&" ~ note ~ ";");
		}
		else if(link) {
			file.write("Link&" ~ link ~ ";");
		}

		if(importance) {
			file.write("Importance&" ~ to!string(importance) ~ ";");
		}
		if(tag == ""){
			tag = "Other";
		}
		file.write("Tag&" ~ tag );
		file.writeln();
	}
	catch(FileException e) {
		writeln("Error. Can't write to file.");
	}
	finally {
		file.close();
	}
}

/**
 * Reads the file.
 * Returns: The contents of the file in string array.
 */
string[] read_lines(string fname) {
	Appender!(string[]) result;
	string input = cast(string)std.file.read(fname);
	foreach (line; input.splitter("\n"))
		if(line != ""){
			result.put(line);
		}
	return result.data;
}


void parse_str(string s, ref string tag, ref int importance, ref string note, ref string link, ref string time ) {
	string [] arr = split(s, ";");
	time = arr[0];
	string [] tmp = split(arr[1], "&");
	if(tmp[0] == "Str") {
		note = tmp[1];
	}
	else if (tmp[0] == "Link") {
		link = tmp[1];
	}
	// importance
	tmp = split(arr[2], "&");
	importance = to!int(tmp[1]);

	// tag
	tmp = split(arr[3], "&");
	tag = tmp[1];
}

/**
 * Format importance
 * Returns: formatted string 
 */
string format_importance(int importance) {
	string imp = "";
	if(COLOR_SUPPORT){
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
	}
	else {
		for(int i = 0; i < importance; i++)
			imp ~= FLAG;
	}
	return imp;
}

/**
 * Output note/link to terminal
 */
void format_out(string tag, int importance, string note, string link, string time ) {
	if(note){
		write( time ~ "\t" ~ note ~ "\t");
		write( format_importance( importance ) );
		writeln( "\t\n\t🏷: " ~ BLUE ~ tag ~ END_COLOR);
	}
	else {
		write( time ~ "\t" ~ link ~ "\t");
		write( format_importance( importance ) );
		writeln( "\t\n\t🏷: " ~ BLUE ~ tag ~ END_COLOR);
	}
}

/**
 * Basic program usage
 */
void usage(){
	write("Usage: [options]"
		"\nOptions:\n"
		"\t -n \t note\n"
		"\t -l \t link\n"
		"\t -i \t importance\n"
		"\t --tag \t tag\n"
		"\t -h \t help\n"
		"Example:\n"
		"\t$ jarvis -n 'Some note' -i 4 --tag 'sometag'\n"
	);
}


/**
 * Read config file
 * Throws: FileException on failure.
 */
void readconfig(string fname){
	string config [];
	try {
		config = read_lines(fname);
	}
	catch (FileException e) {
		writeln("Error. Bad config file");
		return;
	}

	foreach(s; config) {
		string tmp[] = split(s, ":");

		if(tmp.length > 1 && tmp[0] == "COLOR_SUPPORT") {
			COLOR_SUPPORT = (tmp[1] == "1" ? true : false);
		}
		else if(tmp.length > 1 && tmp[0] == "FILENAME") {
			FILENAME = tmp[1];
		}
	}
}
