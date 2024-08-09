const std = @import("std");
const rl = @import("raylib");

const math = @import("Base/math.zig");
const shapes = @import("Base/shapes.zig");
const screen = @import("Base/screen.zig");

const Board = struct {
    pos: math.Pos2 = .{ .x = 0, .y = 0 },

    pub const tileSize: u32 = 48;
    pub const cols: u32 = 8;
    pub const rows: u32 = 8;

    pub const width: f32 = @floatFromInt(cols * tileSize);
    pub const height: f32 = @floatFromInt(rows * tileSize);

    pub fn draw(self: Board, camera: screen.Camera) void {
        // TODO: Move Texture load from here almost literairly to anywhere else
        const lightText = rl.loadTexture("assets/tile_light.png");
        const darkText = rl.loadTexture("assets/tile_dark.png");

        if (lightText.id <= 0) unreachable;
        if (darkText.id <= 0) unreachable;

        var tile: shapes.Rect = .{
            .pos = self.pos,
            .size = .{ .w = @floatFromInt(tileSize), .h = @floatFromInt(tileSize) },
        };

        for (0..Board.rows) |row| {
            tile.pos.x = self.pos.x;
            for (0..Board.cols) |col| {
                const screenRect = camera.ScreenRectFromRect(tile, screen.getScreenSize());

                const parity = ((col + (row % 2)) % 2);
                if (parity == 0) {
                    screen.drawTextureEx(screenRect, lightText, 1);
                } else {
                    screen.drawTextureEx(screenRect, darkText, 1);
                }

                tile.pos.x += @floatFromInt(tileSize);
            }
            tile.pos.y += @floatFromInt(tileSize);
        }
    }
};

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    const screenSize = screen.getScreenSize();
    const camera: screen.Camera = .{
        .rect = .{
            .pos = .{ .x = 0, .y = 0 },
            .size = screenSize,
        },
    };
    const board: Board = .{};

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

        rl.clearBackground(rl.Color.white);

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
