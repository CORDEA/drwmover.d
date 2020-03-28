module handler;

import std.experimental.logger;
import std.algorithm.iteration;
import std.algorithm.sorting;
import std.algorithm;
import std.string;
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
enum Path = "src/main/res";
enum DrawablePath = "drawable-";

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
        .map!(delimiter => getSrcDirEntries(source, name, delimiter))
        .filter!(files => !files.empty)
        .array;

    if (files.empty)
    {
        fatal("Source images not found.");
    }

    auto sortedFiles = getSortedFiles(files[0].array);

    if (sortedFiles.length != 5)
    {
        fatal("Requires 5 files.");
    }

    auto paths = buildPaths(target, fileName);

    foreach (src, tgt; zip(sortedFiles, paths))
    {
        src.copy(tgt);
    }
}

void move(string source, string target) {
    auto srcDir = source.expandTilde().dirName();
    auto tgtDir = target.expandTilde().dirName();
    auto srcName = source.baseName();
    auto tgtName = target.baseName();

    if (tgtDir.endsWith("*"))
    {
        tgtDir = tgtDir.chop();
    }
    if (tgtDir[$-1].isDirSeparator())
    {
        tgtDir = tgtDir.chop();
    }

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
        .map!(delimiter => getSrcDirEntries(srcDir, srcName, delimiter))
        .filter!(files => !files.empty)
        .array;

    if (srcFiles.empty)
    {
        fatal("Source images not found.");
    }

    auto sortedFiles = getSortedFiles(srcFiles[0].array);

    if (sortedFiles.length != 5)
    {
        fatal("Requires 5 files.");
    }

    auto paths = buildPaths(tgtDir, tgtFileName);

    foreach (src, tgt; zip(sortedFiles, paths))
    {
        src.copy(tgt);
    }
}

private auto getSrcDirEntries(string dir, string name, string delimiter) {
    string fileName;
    if (name.endsWith(delimiter))
    {
        fileName = name ~ "*.png";
    }
    else
    {
        fileName = name ~ delimiter ~ "*.png";
    }
    return dirEntries(dir, fileName, SpanMode.shallow);
}

private auto getSortedFiles(DirEntry[] files) {
    alias comp = (x, y) => getSize(x) < getSize(y);
    return files.array.sort!(comp);
}

private auto buildPaths(string dir, string name) {
    alias map = delegate(string dpi) {
        string fullDirPath;
        if (dir.endsWith(Path))
        {
            fullDirPath = buildPath(dir, DrawablePath ~ dpi, name);
        }
        else
        {
            fullDirPath = buildPath(dir, Path, DrawablePath ~ dpi, name);
        }
        return fullDirPath;
    };
    return Dpis.map!(map);
}
