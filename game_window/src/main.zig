/// Game Window using SDL2
const c = @cImport({
    @cInclude("SDL2/SDL.h");
});

const std = @import("std");

const LEVEL_WIDTH: i32 = 640;
const LEVEL_HEIGHT: i32 = 400;
const PLAYER_WIDTH: u32 = 20;
const PLAYER_HEIGHT: u32 = 20;
const PLAYER_SPEED: u32 = 2;

const Player = struct {
    srcrect: c.SDL_Rect,
    dstrect: c.SDL_Rect,
    texture: ?*c.SDL_Texture,
};

pub fn main() !void {
    // Initialize the SDL library
    try std.testing.expect(c.SDL_Init(c.SDL_INIT_VIDEO) != -1);
    defer c.SDL_Quit();

    // Create window
    const window: ?*c.SDL_Window = c.SDL_CreateWindow("SDL2 Window", c.SDL_WINDOWPOS_CENTERED, c.SDL_WINDOWPOS_CENTERED, LEVEL_WIDTH, LEVEL_HEIGHT, 0);
    defer c.SDL_DestroyWindow(window);

    // Create renderer
    const rend: ?*c.SDL_Renderer = c.SDL_CreateRenderer(window, 0, c.SDL_RENDERER_ACCELERATED);
    defer c.SDL_DestroyRenderer(rend);

    // Create player surface
    const player_surface: ?[*]c.SDL_Surface = c.SDL_LoadBMP("player.bmp");
    defer c.SDL_FreeSurface(player_surface);

    try std.testing.expect(player_surface != null);

    // Create player texture
    const player_texture: ?*c.SDL_Texture = c.SDL_CreateTextureFromSurface(rend, player_surface);
    defer c.SDL_DestroyTexture(player_texture);

    // Source and destination rectangle of the player
    const player_srcrect: c.SDL_Rect = c.SDL_Rect{ .x = 0, .y = 0, .w = PLAYER_WIDTH, .h = PLAYER_HEIGHT };
    var player_dstrect: c.SDL_Rect = c.SDL_Rect{ .x = 20, .y = 20, .w = PLAYER_WIDTH, .h = PLAYER_HEIGHT };

    var player = Player{ .srcrect = player_srcrect, .dstrect = player_dstrect, .texture = player_texture };

    // Set the background color to white
    _ = c.SDL_SetRenderDrawColor(rend, 255, 255, 255, 255);

    mainloop: while (true) {
        // Game loop
        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event) != 0) {
            switch (event.type) {
                c.SDL_QUIT => break :mainloop,
                c.SDL_KEYDOWN => {
                    if (event.key.keysym.scancode == c.SDL_SCANCODE_ESCAPE) {
                        break :mainloop;
                    }
                },
                else => {},
            }
        }

        // Hold Movement Keybindings
        var state: [*]const u8 = c.SDL_GetKeyboardState(null);
        if (state[c.SDL_SCANCODE_RIGHT] == 1) {
            // move the player right
            player.dstrect.x += PLAYER_SPEED;
        }
        if (state[c.SDL_SCANCODE_LEFT] == 1) {
            // move the player left
            player.dstrect.x -= PLAYER_SPEED;
        }
        if (state[c.SDL_SCANCODE_DOWN] == 1) {
            // move the player down
            player.dstrect.y += PLAYER_SPEED;
        }
        if (state[c.SDL_SCANCODE_UP] == 1) {
            // move the player up
            player.dstrect.y -= PLAYER_SPEED;
        }

        // Player boundaries
        if (player.dstrect.x < 0) {
            // left boundary
            player.dstrect.x = 0;
        }
        if (player.dstrect.x + player.dstrect.w > LEVEL_WIDTH) {
            // right boundary
            player.dstrect.x = LEVEL_WIDTH - player.dstrect.w;
        }
        if (player.dstrect.y + player.dstrect.h > LEVEL_HEIGHT) {
            // bottom boundary
            player.dstrect.y = LEVEL_HEIGHT - player.dstrect.h;
        }
        if (player.dstrect.y < 0) {
            // top boundary
            player.dstrect.y = 0;
        }

        // Clear renderer
        _ = c.SDL_RenderClear(rend);

        // Render the player
        _ = c.SDL_RenderCopy(rend, player.texture, &player.srcrect, &player.dstrect);

        // Updates the screen (renderer)
        c.SDL_RenderPresent(rend);

        // Calculates to 60 fps
        // 1000ms equals 1s
        const miliseconds: i32 = 1000;
        const gameplay_frames: i32 = 60;
        c.SDL_Delay(miliseconds / gameplay_frames);
    }
}
