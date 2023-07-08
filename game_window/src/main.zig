const c = @cImport({
    @cInclude("SDL2/SDL.h");
});

const std = @import("std");

const level_width = 640;
const level_height = 400;
const screen_width = 800;
const screen_height = 450;
const image_width = 40;
const image_height = 40;
const player_speed = 2;

pub fn main() void {
    const status: c_int = c.SDL_Init(c.SDL_INIT_VIDEO);
    if (status == -1) {
        std.debug.print("SDL_Init Error", .{});
    }
    defer c.SDL_Quit();

    // Create window
    const window = c.SDL_CreateWindow("SDL2 Window", c.SDL_WINDOWPOS_CENTERED, c.SDL_WINDOWPOS_CENTERED, level_width, level_height, 0);

    // Create renderer
    const rend = c.SDL_CreateRenderer(window, 0, c.SDL_RENDERER_ACCELERATED);
    defer c.SDL_DestroyRenderer(rend);

    // Create image surface
    const image_surface = c.SDL_LoadBMP("test.bmp");
    defer c.SDL_FreeSurface(image_surface);

    // Create image texture
    const image_texture = c.SDL_CreateTextureFromSurface(rend, image_surface);
    defer c.SDL_DestroyTexture(image_texture);

    // Source and destination rectangle of the image
    const srcrect = c.SDL_Rect{.x = 0, .y = 0, .w = image_width, .h = image_height};
    var dstrect = c.SDL_Rect{.x = 20, .y = 20, .w = image_width, .h = image_height};

    // [ Red, Green, Blue, Alpha ]
    _ = c.SDL_SetRenderDrawColor(rend, 255, 255, 255, 255);

    mainloop: while(true) {
        // Game loop
        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event) != 0) {
            switch(event.type) {
                c.SDL_QUIT => break :mainloop,
                c.SDL_KEYDOWN => {
                    if (event.key.keysym.scancode == c.SDL_SCANCODE_ESCAPE) {
                        break :mainloop;
                    }
                },
                else => {},
            }
        }

        // Hold Keybindings
        // Get Keyboard State Feature Does Not Work
        //var state = c.SDL_GetKeyboardState(null);
        //if (state[c.SDL_SCANCODE_RIGHT] == 1) {
        //    dstrect.x += player_speed;
        //}

        // Clear renderer
        _ = c.SDL_RenderClear(rend);
        // Render the image
        _ = c.SDL_RenderCopy(rend, image_texture, &srcrect, &dstrect);
        // Updates the screen (renderer)
        c.SDL_RenderPresent(rend);
    }
}