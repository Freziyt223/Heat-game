// ==========================================================================================
// Imports and top-level fields
const Engine = @import("Engine");
const State = @import("State");
const std = @import("std");

// Windows of the game
var Windows: [2]?*Engine.Renderer.Renderer.zglfw.Window = undefined;


// ==========================================================================================
// Init and deinit functions
// Command-line arguments and DebugAllocator are passed through Engine.Init
pub fn init(_: Engine.Init) !void {
    try Engine.IO.Console.Print("Hello, {s}\n", .{"world!"});
    try Engine.IO.Console.ColourPrint("Hello, {s}\n", .{"but in red!"}, .{.Hex = 0xFF0000});
    Engine.Renderer.Renderer.zglfw.windowHint(.client_api, .no_api);
    Windows[0] = try Engine.Renderer.Renderer.zglfw.createWindow(600, 600, "Test window 1", null, null);
    Windows[1] = try Engine.Renderer.Renderer.zglfw.createWindow(600, 600, "Test window 2", null, null);

}
pub fn deinit() void {
    Engine.IO.Console.Print("Goodbye, world!\n", .{}) catch unreachable; // Unreachable will stop the execution and show where it happened
}


// ==========================================================================================
// Update loops
// To make a function in a while loop use this format:
pub const update = [_]type{
    RendererLoop,
    Loop60
};
pub const Loop60 = struct {
    pub fn update() !void {
        const Zone = Engine.ztracy.ZoneNC(@src(), "60 TPS", 0xA000FF);
        defer Zone.End();
    }
    pub var tick_rate: ?u64 = 60;
};
pub const RendererLoop = struct {
    pub fn update() !void {
        const Zone = Engine.ztracy.ZoneNC(@src(), "Window update(120 TPS)", 0xA000FF);
        defer Zone.End();
        var opened_windows: u8 = 0;
        for (0..Windows.len) |i| {
            if (Windows[i]) |window| {
                if (window.shouldClose()) {
                    window.destroy();
                    Windows[i] = null;
                } else {
                    window.swapBuffers();
                    opened_windows += 1;
                }

                if (window.getKey(.escape) == .press) window.setShouldClose(true);
            }
        }
        if (opened_windows == 0) State.Running = false;
    }
    pub var tick_rate: ?u64 = 120;
};