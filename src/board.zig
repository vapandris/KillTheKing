const rl = @import("raylib");
const math = @import("Base/math.zig");
const shapes = @import("Base/shapes.zig");
const screen = @import("Base/screen.zig");
const res = @import("resources.zig");

pub const Board = struct {
    pos: math.Pos2 = .{ .x = 0, .y = 0 },

    pub const tileSize: u32 = 48;
    pub const cols: u32 = 8;
    pub const rows: u32 = 8;

    pub const width: f32 = @floatFromInt(cols * tileSize);
    pub const height: f32 = @floatFromInt(rows * tileSize);

    pub fn rect(self: Board) shapes.Rect {
        return .{
            .pos = self.pos,
            .size = .{ .w = Board.width, .h = Board.height },
        };
    }

    pub fn draw(self: Board, camera: screen.Camera) void {
        const lightText = res.lightTileTextr;
        const darkText = res.darkTileTextr;

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
                    screen.drawTexture(
                        screenRect,
                        .{ .x = 0, .y = 0, .width = 48, .height = 48 },
                        lightText,
                    );
                } else {
                    screen.drawTexture(
                        screenRect,
                        .{ .x = 0, .y = 0, .width = 48, .height = 48 },
                        darkText,
                    );
                }

                tile.pos.x += @floatFromInt(tileSize);
            }
            tile.pos.y += @floatFromInt(tileSize);
        }
    }
};
