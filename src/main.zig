// ==========================================================================================
// Imports and top-level fields
const Engine = @import("Engine");
const State = @import("State");
const std = @import("std");

// Windows of the game
var Windows: [2]?Engine.Renderer.Window = undefined;
var vulkan = Engine.Renderer.Renderer(.Vulkan);

// ==========================================================================================
// Init and deinit functions
// Command-line arguments and DebugAllocator are passed through Engine.Init
pub fn init(Init: Engine.Init) !void {
    try Engine.IO.Console.Print("Hello, {s}\n", .{"world!"});
    try Engine.IO.Console.ColourPrint("Hello, {s}\n", .{"but in red!"}, .{.Hex = 0xFF0000});
    try vulkan.init(Init.Allocator);
    Windows[0] = try Engine.Renderer.createWindow(600, 600, "Test window 1", null, null, vulkan);
    Windows[1] = try Engine.Renderer.createWindow(600, 600, "Test window 2", null, null, vulkan);
    if (vulkan.listDevices()) |devices| {
        for (devices, 0..) |device, i| {
            try Engine.IO.Console.Print("{d}: {s}, type: {s}\n", .{i, device.name, @tagName(device.type)});
        }
    } else try Engine.IO.Console.Print("null devices", .{});
}
pub fn deinit() void {
    vulkan.deinit();
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
    pub fn update() void {
        const Zone = Engine.ztracy.ZoneNC(@src(), "60 TPS", 0xA000FF);
        defer Zone.End();
    }
    pub var tick_rate: ?u64 = 60;
};
var opened_windows: u8 = Windows.len;
pub const RendererLoop = struct {
    pub fn update() void {
        const Zone = Engine.ztracy.ZoneNC(@src(), "Window update(120 TPS)", 0xA000FF);
        defer Zone.End();
        
        for (0..Windows.len) |i| {
            var window = Windows[i] orelse continue;

            if (window.getKey(.escape) == .press) {
                window.setShouldClose(true);
            }
            if (window.shouldClose()) { 
                window.destroy();
                Windows[i] = null;
                opened_windows -= 1;
                continue; 
            }
            
            window.swapBuffers();
        }
        if (opened_windows == 0) {
            State.Running = false;
            return;
        }
    }
    pub var tick_rate: ?u64 = 120;
};