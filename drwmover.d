import std.experimental.logger;
import std.getopt;
import std.range;

import handler;

string source;
string target;
string name;

void main(string[] args)
{
    auto help = getopt(
            args,
            "source", &source,
            "target", &target,
            "name", &name);

    if (help.helpWanted)
    {
        defaultGetoptPrinter("", help.options);
        return;
    }

    if (name.empty)
    {
        move(source, target);
    }
    else
    {
        move(source, target, name);
    }
}
