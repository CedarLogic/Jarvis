module main;
import std.stdio;
import std.getopt;
import header;


void main(string[] args) {

	string note, link, tag;
	int importance = 1;
	int read;

	getopt(args, 
		"note|n", &note, 
		"link|l", &link, 
		"tag", &tag, 
		"i", &importance, 
		"read|r", &read);

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