const rl = @import("raylib");

const math = @import("Base/math.zig");
const shapes = @import("Base/shapes.zig");
const screen = @import("Base/screen.zig");
const res = @import("resources.zig");

pub const Dummy = struct {
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
