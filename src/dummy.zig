const rl = @import("raylib");

const math = @import("Base/math.zig");
const shapes = @import("Base/shapes.zig");
const screen = @import("Base/screen.zig");
const res = @import("resources.zig");

pub const Dummy = struct {
    body: shapes.Circle,
    maxSpeed: f32 = 1.5,
    acceleration: f32 = 0.5,
    moveDirection: math.Vec2 = .{ .x = 0, .y = 0 },

    // Render data:
    const textureOffset: math.Vec2 = .{
        .x = 0,
        .y = -5,
    };
    const textureSize: shapes.Size = .{
        .w = 16,
        .h = 24,
    };

    pub fn update(self: *Dummy, bounds: shapes.Rect, frameDelta: f32) void {
        self.moveDirection.normalize();
        const dir = self.moveDirection;
        const FPS = 60.0;

        self.body.move(
            dir,
            self.acceleration * FPS,
            (self.acceleration / 2) * FPS,
            self.maxSpeed,
            bounds,
            frameDelta,
        ) catch unreachable;
    }

    pub fn draw(self: Dummy, camera: screen.Camera) void {
        const dummyTextr = res.dummyTextr;
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
            dummyTextr,
        );
    }

    pub fn debugDraw(self: Dummy, camera: screen.Camera) void {
        const screenCircle = camera.ScreenCircleFromCircle(self.body, screen.getScreenSize());

        rl.drawCircle(
            screenCircle.x,
            screenCircle.y,
            screenCircle.r,
            rl.Color.init(0, 0, 0, 255 / 2),
        );
    }
};
