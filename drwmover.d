import std.getopt;
import std.file;

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

    assert(source.exists);
    assert(source.isDir);

    assert(target.exists);
    assert(target.isDir);
}
