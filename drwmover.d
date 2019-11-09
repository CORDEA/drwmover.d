import std.experimental.logger;
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

    if (name.empty)
    {
        fatal("Name is empty.");
    }

    if (!source.exists || !source.isDir)
    {
        fatal("Source dir not found.");
    }

    if (!target.exists || !target.isDir)
    {
        fatal("Target dir not found.");
    }

    auto fileName = name ~ ".png";
    auto files = Delimiters
        .map!(delimiter => dirEntries(source, name ~ delimiter ~ "*.png", SpanMode.shallow))
        .filter!(files => !files.empty)
        .array;

    if (files.empty)
    {
        fatal("Source images not found.");
    }

    alias comp = (x, y) => getSize(x) < getSize(y);
    auto sortedFiles = files[0].array.sort!(comp);

    if (sortedFiles.length != 5)
    {
        fatal("Requires 5 files.");
    }

    auto paths = Dpis.map!(dpi => buildPath(target, Path ~ dpi, fileName));

    foreach (source, target; zip(sortedFiles, paths))
    {
        source.copy(target);
    }
}
