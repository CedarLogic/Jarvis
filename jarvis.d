module main;
import std.stdio;
import std.getopt;
import std.random;
import utils;

const string response[] = [
	"As you wish!", 
	"I live to serve you.", 
	"Master!"
];


void main(string[] args) {

	string note, link, tag;
	int importance = 1, read;
	bool version_opt;

	try {
		auto helpInformation = getopt(args, 
			std.getopt.config.required,
			"note|n", &note, 
			"link|l", &link, 
			std.getopt.config.required,
			"tag", &tag, 
			"i", &importance, 
			"read|r", &read,
			"version", &version_opt
		);
	}
	catch(GetOptException e) {
		if(version_opt){
			writeln("Jarvis assistant v0.1\nCopyright (c) 2016 by Bobrov Kirill");
			return;
		}
		else{
			usage();
			return;
		}
	}

	if(note || link) {
		if(importance > 5 || importance < 0 ) {
			writeln("Importance status need to be in range [1-5]");
			return;
		}

		write_to_storage(tag, importance, note, link);

		auto i = uniform(0, response.length);
		writeln(response[i]);
	}
	else if(read) {
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