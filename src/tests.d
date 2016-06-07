module tests;
import std.stdio;
import utils;
import std.exception;

/**
 * Reading not existing file
 */
unittest {
	writeln("test_not_exist_file");
	assertThrown!Throwable(read_lines("not_exist_file"));
}

/**
 * Format importance
 */
unittest {
	writeln("test_format_importance");
	assert(format_importance(5) == FLAG~FLAG~FLAG~FLAG~FLAG);
}