const std = @import("std");
const rl = @import("raylib");

const math = @import("Base/math.zig");
const shapes = @import("Base/shapes.zig");
const screen = @import("Base/screen.zig");
const res = @import("resources.zig");

const Board = @import("board.zig").Board;
const Dummy = @import("dummy.zig").Dummy;

pub const Rook = struct {
    body: shapes.Circle,
    maxSpeed: f32 = 2.5,
    acceleration: f32 = 0.35,
    moveDirection: math.Vec2 = .{ .x = 0, .y = 0 },

    // Render data:
    const textureOffset: math.Vec2 = .{
        .x = 0,
        .y = -12,
    };
    const textureSize: shapes.Size = .{
        .w = 48,
        .h = 64,
    };

    pub fn draw(self: Rook, camera: screen.Camera) void {
        const rookTextr = res.rookTextr;
        var rect: shapes.Rect = .{
            .pos = undefined,
            .size = textureSize,
        };
        rect.setMidPoint(self.body.pos);
        rect.pos.y += textureOffset.y;

        const screenRect = camera.ScreenRectFromRect(rect, screen.getScreenSize());

        screen.drawTexture(
            screenRect,
            .{ .x = 0, .y = 0, .width = textureSize.w, .height = textureSize.h },
            rookTextr,
        );
    }

    pub fn debugDraw(self: Rook, camera: screen.Camera) void {
        const screenCircle = camera.ScreenCircleFromCircle(self.body, screen.getScreenSize());

        rl.drawCircle(
            screenCircle.x,
            screenCircle.y,
            screenCircle.r,
            rl.Color.init(0, 0, 0, 255 / 2),
        );
    }
};

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 1600;
    const screenHeight = 900;

    rl.initWindow(screenWidth, screenHeight, "Kill the king");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second

    res.init();

    // ==================
    // Init board:
    const board: Board = .{};

    const h = Board.height + 32;
    const w = screenWidth * (h / screenHeight);
    std.debug.print("{d} x {d}\n", .{ w, h });

    // ==================
    // Init dummy:
    var dummy: Dummy = .{ .body = undefined };
    dummy.body.pos = .{
        .x = board.rect().getMidPoint().x,
        .y = board.pos.y + Board.height - 16,
    };
    dummy.body.r = 5;

    // ==================
    // Init rooks:
    const offsetX: f32 = 64;
    const offsetY: f32 = 48;
    var rook1: Rook = .{ .body = undefined };
    rook1.body.pos = .{
        .x = board.rect().getMidPoint().x + offsetX,
        .y = board.pos.y + offsetY,
    };
    rook1.body.r = 18;

    var rook2: Rook = .{ .body = undefined };
    rook2.body.pos = .{
        .x = board.rect().getMidPoint().x - offsetX,
        .y = board.pos.y + offsetY,
    };
    rook2.body.r = 18;

    // ==================
    // Init camera:
    var camera: screen.Camera = .{
        .rect = .{
            .pos = .{ .x = 0, .y = 0 },
            .size = .{ .w = w, .h = h },
        },
    };
    camera.focusOn(board.rect().getMidPoint());
    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        var dir = math.Vec2.ZERO;
        if (rl.isKeyDown(.key_d)) dir.x += 1;
        if (rl.isKeyDown(.key_a)) dir.x -= 1;
        if (rl.isKeyDown(.key_s)) dir.y += 1;
        if (rl.isKeyDown(.key_w)) dir.y -= 1;

        dummy.moveDirection = dir;
        dummy.update(board.rect(), rl.getFrameTime());

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.init(20, 20, 25, 255));

        board.draw(camera);
        dummy.draw(camera);
        dummy.debugDraw(camera);
        rook1.draw(camera);
        rook2.draw(camera);
        rook1.debugDraw(camera);
        rook2.debugDraw(camera);
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
