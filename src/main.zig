const Engine = @import("Engine");
const State = @import("State");
const std = @import("std");

pub var counter: usize = 0;

pub fn init() !void {
    try Engine.IO.Console.Print("Hello, {s}\n", .{"world!"});
    try Engine.IO.Console.ColourPrint("Hello, {s}\n", .{"but in red!"}, .{.Hex = 0xFF0000});
}

pub const update = [_]type{
    Loop60,
    Loop120,
};
pub const Loop60 = struct {
    pub fn update() !void {
        const Zone = Engine.ztracy.ZoneNC(@src(), "60 Tick", 0x00FF00);
        defer Zone.End();
    }
    pub var tick_rate: ?u64 = 60;
};
pub const Loop120 = struct {
    pub fn update() !void {
        const Zone = Engine.ztracy.ZoneNC(@src(), "120 Tick", 0xA000FF);
        defer Zone.End();
    }
    pub var tick_rate: ?u64 = 120;
};

pub fn deinit() void {
    Engine.IO.Console.Print("Goodbye, world! Final counter: {d}\n", .{counter}) catch unreachable;
}