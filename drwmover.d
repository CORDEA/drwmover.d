import std.algorithm.sorting;
import std.getopt;
import std.stdio;
import std.range;
import std.file;
import std.path;

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

    assert(!name.empty);

    assert(source.exists);
    assert(source.isDir);

    assert(target.exists);
    assert(target.isDir);

    auto fileName = name ~ ".png";
    alias comp = (x, y) => getSize(x) < getSize(y);
    auto sortedFiles = dirEntries(source, name ~ "*.png", SpanMode.shallow).array.sort!(comp);
    foreach (s; sortedFiles)
        writeln(s);
}
