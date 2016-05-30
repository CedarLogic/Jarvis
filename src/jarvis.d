/***********************************
 * Jarvis is a command line notebook written on D language
 *
 * Author:
 * Bobrov Kirill <miaplanedo@gmail.com>
 * (c) 2016
 */

module main;
import std.stdio;
import std.file;
import std.path;
import std.getopt;
import std.random;
import utils;

/** jarvis response to your actions. Random choice */
const string response[] = [
	"As you wish!", 
	"I live to serve you.", 
	"Master!",
	"(ﾉ◕ヮ◕)ﾉ",
	"Windows sucks!",
	"(͡ ͡° ͜ つ ͡͡°)",
	"(ﾉ◕ヮ◕)ﾉ*:・ﾟ✧",
	"(＾▽＾)",
	"(｡◕‿◕｡)",
	"｡◕‿‿◕｡",
	"❤(｡´‿`｡)",
	"(ノʘ‿ʘ)ノ"
];

void main(string[] args) {

	/** config file path */
	const string config_file = expandTilde("~/.config/jarvis/.config");
	
	string note, link, tag;
	int importance = 1, read;
	bool version_opt;

	try {
		getopt(args, 
			"note|n", &note, 
			"link|l", &link, 
			"tag", &tag, 
			"i", &importance, 
			"read|r", &read,
			"version", &version_opt
		);
	}
	catch(GetOptException){}

	readconfig(config_file);

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
		string [] strs;

		try {
			strs = read_lines(FILENAME).reverse;
		}
		catch (FileException e) {
			writeln("Error. Bad file");
		}

		int num_to_read = read < 0 || read > strs.length ? strs.length : read;
		for(int i = 0; i < num_to_read; i++) {
			string s = strs[i];
			if(s == "") {
				return;
			}
			parse_str(s, read_tag, read_imp, read_note, read_link, read_time);
			format_out(read_tag, read_imp, read_note, read_link, read_time);
		}

	}
	else if (version_opt) {
		writeln("Jarvis assistant v0.1\nCopyright (c) 2016 by Bobrov Kirill");
	}
	else {
		usage();
	}

	return;
}
