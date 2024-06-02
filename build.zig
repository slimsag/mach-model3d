const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const lib = b.addStaticLibrary(.{
        .name = "mach-model3d",
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibC();
    lib.addIncludePath(b.path("src/c"));
    lib.addCSourceFile(.{
        .file = b.path("src/c/m3d.c"),
        // Note: model3d needs unaligned accesses, which are safe on all modern architectures.
        // See https://gitlab.com/bztsrc/model3d/-/issues/19
        .flags = &.{ "-std=c89", "-fno-sanitize=alignment" },
    });
    lib.installHeader(b.path("src/c/m3d.h"), "m3d.h");
    b.installArtifact(lib);

    const module = b.addModule("mach-model3d", .{ .root_source_file = b.path("src/main.zig") });
    module.linkLibrary(lib);

    const main_tests = b.addTest(.{
        .name = "model3d-tests",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    main_tests.linkLibrary(lib);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&b.addRunArtifact(main_tests).step);
}
