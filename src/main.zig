const std = @import("std");
const rl = @import("raylib");

const math = @import("Base/math.zig");
const shapes = @import("Base/shapes.zig");
const screen = @import("Base/screen.zig");
const res = @import("resources.zig");

const Board = @import("board.zig").Board;

const Dummy = struct {
    body: shapes.Circle,
    maxSpeed: f32 = 3,
    acceleration: f32 = 0.5,
    moveDirection: math.Vec2 = .{ .x = 0, .y = 0 },

    pub fn update(self: *Dummy, frameDelta: f32) void {
        self.moveDirection.normalize();
        const dir = self.moveDirection;
        const FPS = 60.0;

        self.body.move(
            dir,
            self.acceleration * FPS,
            (self.acceleration / 2) * FPS,
            self.maxSpeed,
            frameDelta,
        ) catch unreachable;
    }

    pub fn draw(self: Dummy, camera: screen.Camera) void {
        const dummyTextr = res.dummyTextr;
        var rect: shapes.Rect = .{ .pos = undefined, .size = .{
            .w = self.body.r * 2,
            .h = self.body.r * 2,
        } };
        rect.setMidPoint(self.body.pos);

        const screenRect = camera.ScreenRectFromRect(rect, screen.getScreenSize());

        screen.drawTexture(
            screenRect,
            .{ .x = 0, .y = 0, .width = 16, .height = 24 },
            dummyTextr,
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

    const board: Board = .{};
    var dummy: Dummy = .{ .body = undefined };
    dummy.body.pos = .{ .x = 0, .y = 0 };
    dummy.body.r = 16;

    const h = Board.height + 32;
    const w = screenWidth * (h / screenHeight);
    std.debug.print("{d} x {d}\n", .{ w, h });
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
        dummy.update(rl.getFrameTime());

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.init(20, 20, 25, 255));

        board.draw(camera);
        dummy.draw(camera);
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
