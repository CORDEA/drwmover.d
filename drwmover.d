import std.algorithm.iteration;
import std.algorithm.sorting;
import std.getopt;
import std.stdio;
import std.range;
import std.file;
import std.path;

enum Dpis = [
    "mdpi",
    "hdpi",
    "xhdpi",
    "xxhdpi",
    "xxxhdpi"
];
enum Path = "src/main/res/drawable-";

enum Delimiters = [
    "@",
    "-"
];

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
    auto sortedFiles = Delimiters
        .map!(delimiter => dirEntries(source, name ~ delimiter ~ "*.png", SpanMode.shallow))
        .filter!(files => !files.empty)
        .array[0]
        .array
        .sort!(comp);

    assert(sortedFiles.length > 4);
    auto paths = Dpis.map!(dpi => buildPath(target, Path ~ dpi, fileName));

    foreach (source, target; zip(sortedFiles, paths))
    {
        source.copy(target);
    }
}
