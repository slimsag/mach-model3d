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
    lib.addIncludePath("src/c");

    // Note: model3d needs unaligned accesses, which are safe on all modern architectures.
    // See https://gitlab.com/bztsrc/model3d/-/issues/19
    lib.addCSourceFile("src/c/m3d.c", &.{ "-std=c89", "-fno-sanitize=alignment" });
    b.installArtifact(lib);
    lib.installHeader("src/c/m3d.h", "m3d.h");

    // TODO: add a dependency on libmodel3d here once supported
    _ = b.addModule("mach-model3d", .{
        .source_file = .{ .path = "src/main.zig" },
    });

    const main_tests = b.addTest(.{
        .name = "model3d-tests",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    main_tests.linkLibrary(lib);
    main_tests.addIncludePath("src/c");

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&b.addRunArtifact(main_tests).step);
}
