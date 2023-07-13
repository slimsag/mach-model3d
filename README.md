# mach/model3d - compact, featureful model format & alternative to glTF

[Model3D](https://gitlab.com/bztsrc/model3d/) is an up-and-coming compact, featureful, universal model format that tries to address the shortcomings of existing formats (yes, including glTF - see [their rationale](https://gitlab.com/bztsrc/model3d/#rationale).)

This repository provides Zig bindings, with the aim of a pure-Zig implementation eventually.

This repository is a separate copy of the same library in the [main Mach repository](https://github.com/hexops/mach), and is automatically kept in sync, so that anyone can use this library in their own project if they like!

## Experimental

This is an _experimental_ Mach library, according to our [stability guarantees](https://machengine.org/next/docs/libs/):

> Experimental libraries may have their APIs change without much notice, and you may have to look at recent changes in order to update your code.

[Why this library is not declared stable yet](https://machengine.org/next/docs/libs/experimental/#model3d)

## Getting started

### Adding dependency

Create a `build.zig.zon` file in your project (replace `$LATEST_COMMIT` with the latest commit hash):

```
.{
    .name = "mypkg",
    .version = "0.1.0",
    .dependencies = .{
        .mach_model3d = .{
            .url = "https://github.com/hexops/mach-model3d/archive/$LATEST_COMMIT.tar.gz",
        },
    },
}
```

Run `zig build` in your project, and the compiler instruct you to add a `.hash = "..."` field next to `.url`.

Then use the dependency in your `build.zig`:

```zig
...
pub fn build(b: *Build) void {
    ...
    const mach_model3d = b.dependency("mach_model3d", .{
        .target = target,
        .optimize = optimize,
    });
    exe.addModule("mach-model3d", mach_model3d.module("mach-model3d"));
    exe.linkLibrary(mach_model3d.artifact("mach-model3d"));
}
```

You may then `const model3d = @import("mach-model3d");` and use it.

## Join the community

Join the Mach community [on Discord](https://discord.gg/XNG3NZgCqp) to discuss this project, ask questions, get help, etc.

## Issues

Issues are tracked in the [main Mach repository](https://github.com/hexops/mach/issues?q=is%3Aissue+is%3Aopen+label%3Amodel3d).
