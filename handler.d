module handler;

import std.experimental.logger;
import std.algorithm.iteration;
import std.algorithm.sorting;
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

void move(string source, string target, string name) {
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

    foreach (src, tgt; zip(sortedFiles, paths))
    {
        src.copy(tgt);
    }
}

void move(string source, string target) {
    auto srcDir = dirName(source);
    auto tgtDir = dirName(target);
    auto srcName = baseName(source);
    auto tgtName = baseName(target);

    if (!srcDir.exists || !srcDir.isDir)
    {
        fatal("Source dir not found.");
    }

    if (!tgtDir.exists || !tgtDir.isDir)
    {
        fatal("Target dir not found.");
    }

    auto tgtFileName = tgtName ~ ".png";
    auto srcFiles = Delimiters
        .map!(delimiter => dirEntries(srcDir, srcName ~ delimiter ~ "*.png", SpanMode.shallow))
        .filter!(files => !files.empty)
        .array;

    if (srcFiles.empty)
    {
        fatal("Source images not found.");
    }

    alias comp = (x, y) => getSize(x) < getSize(y);
    auto sortedFiles = srcFiles[0].array.sort!(comp);

    if (sortedFiles.length != 5)
    {
        fatal("Requires 5 files.");
    }

    auto paths = Dpis.map!(dpi => buildPath(tgtDir, Path ~ dpi, tgtFileName));

    foreach (src, tgt; zip(sortedFiles, paths))
    {
        src.copy(tgt);
    }
}
