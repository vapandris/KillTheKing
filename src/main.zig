const std = @import("std");
const rl = @import("raylib");

const math = @import("Base/math.zig");
const shapes = @import("Base/shapes.zig");
const screen = @import("Base/screen.zig");
const res = @import("resources.zig");

const Board = @import("board.zig").Board;

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 1600;
    const screenHeight = 900;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    res.init();

    const board: Board = .{};

    const h = Board.height + 32;
    const w = screenWidth * (h / screenHeight);
    std.debug.print("{d} x {d}\n", .{ w, h });
    var camera: screen.Camera = .{
        .rect = .{
            .pos = .{ .x = board.pos.x, .y = board.pos.x },
            .size = .{ .w = w, .h = h },
        },
    };
    camera.focusOn(board.rect().getMidPoint());
    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.init(20, 20, 25, 255));

        board.draw(camera);
        //----------------------------------------------------------------------------------
    }
}

// ==========================================================================
test main {
    _ = @import("Base/math.zig");
    _ = @import("Base/shapes.zig");
    _ = @import("Base/screen.zig");
    _ = @import("Base/atlas.zig");
}
