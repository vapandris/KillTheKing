const rl = @import("raylib");

pub var lightTileTextr: rl.Texture = undefined;
pub var darkTileTextr: rl.Texture = undefined;
pub var dummyTextr: rl.Texture = undefined;
pub var rookTextr: rl.Texture = undefined;

pub fn init() void {
    const lightTilePath = "assets/tile_light.png";
    const darkTilePath = "assets/tile_dark.png";
    const dummyPath = "assets/dummy.png";
    const rookPath = "assets/rook.png";

    lightTileTextr = rl.loadTexture(lightTilePath);
    darkTileTextr = rl.loadTexture(darkTilePath);
    dummyTextr = rl.loadTexture(dummyPath);
    rookTextr = rl.loadTexture(rookPath);

    if (lightTileTextr.id <= 0) @panic("Fatal error: couldn't load texture for light tile\n" ++ "Relative-path: " ++ lightTilePath ++ "\n\n");
    if (darkTileTextr.id <= 0) @panic("Fatal error: couldn't load texture for dark tile\n" ++ "Relative-path: " ++ darkTilePath ++ "\n\n");
    if (dummyTextr.id <= 0) @panic("Fatal error: couldn't load texture for player character\n" ++ "Relative-path: " ++ dummyPath ++ "\n\n");
    if (rookTextr.id <= 0) @panic("Fatal error: couldn't load texture for Rook\n" ++ "Relative-path: " ++ rookPath ++ "\n\n");
}
