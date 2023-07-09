/// Game Window using SDL2
const c = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("SDL2/SDL_image.h");
    @cInclude("SDL2/SDL_mixer.h");
});

const std = @import("std");

const level_width: i32 = 640;
const level_height: i32 = 400;
const screen_width: i32 = 800;
const screen_height: i32 = 450;
const player_width: i32 = 40;
const player_height: i32 = 40;
const player_speed: i32 = 2;
const chunksize: i32 = 1024;
const music_volume: i32 = 64; // 128

pub fn main() void {
    const sdl_status: c_int = c.SDL_Init(c.SDL_INIT_VIDEO);
    defer c.SDL_Quit();

    if (sdl_status == -1) {
        std.debug.print("SDL_Init Error\n", .{});
    }

    // Create window
    const window = c.SDL_CreateWindow("SDL2 Window", c.SDL_WINDOWPOS_CENTERED, c.SDL_WINDOWPOS_CENTERED, level_width, level_height, 0);
    defer c.SDL_DestroyWindow(window);

    // Initialize SDL_mixer
    const open_audio: c_int = c.Mix_OpenAudio(c.MIX_DEFAULT_FREQUENCY, c.MIX_DEFAULT_FORMAT, 2, chunksize);
    defer c.Mix_CloseAudio();

    if (open_audio == -1) {
        std.debug.print("Mix_OpenAudio Error\n", .{});
    }

    // Create renderer
    const rend = c.SDL_CreateRenderer(window, 0, c.SDL_RENDERER_ACCELERATED);
    defer c.SDL_DestroyRenderer(rend);

    const music = c.Mix_LoadMUS("test.ogg");

    // Create player surface
    const player_surface = c.IMG_Load("player.png");
    defer c.SDL_FreeSurface(player_surface);

    // Create player texture
    const player_texture = c.SDL_CreateTextureFromSurface(rend, player_surface);
    defer c.SDL_DestroyTexture(player_texture);

    // Source and destination rectangle of the player
    const srcrect = c.SDL_Rect{.x = 0, .y = 0, .w = player_width, .h = player_height};
    var dstrect = c.SDL_Rect{.x = 20, .y = 20, .w = player_width, .h = player_height};

    // [ Red, Green, Blue, Alpha ]
    _ = c.SDL_SetRenderDrawColor(rend, 255, 255, 255, 255);

    _ = c.Mix_VolumeMusic(music_volume);

    // Start background music (-1 means infinity)
    const music_status: c_int = c.Mix_PlayMusic(music, -1);

    if (music_status == -1) {
        std.debug.print("Mix_PlayMusic Error\n", .{});
    }

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

        // Hold Movement Keybindings
        var state: [*]const u8 = c.SDL_GetKeyboardState(null);
        if (state[c.SDL_SCANCODE_RIGHT] == 1) {
            dstrect.x += player_speed;
        }
        if (state[c.SDL_SCANCODE_LEFT] == 1) {
            dstrect.x -= player_speed;
        }
        if (state[c.SDL_SCANCODE_DOWN] == 1) {
            dstrect.y += player_speed;
        }
        if (state[c.SDL_SCANCODE_UP] == 1) {
            dstrect.y -= player_speed;
        }

        // Player boundaries
        if (dstrect.x < 0) {
            // left boundary
            dstrect.x = 0;
        }
        if (dstrect.x + dstrect.w > level_width) {
            // right boundary
            dstrect.x = level_width - dstrect.w;
        }
        if (dstrect.y + dstrect.h > level_height) {
            // bottom boundary
            dstrect.y = level_height - dstrect.h;
        }
        if (dstrect.y < 0) {
            // top boundary
            dstrect.y = 0;
        }

        // Clear renderer
        _ = c.SDL_RenderClear(rend);
        
        // Render the player
        _ = c.SDL_RenderCopy(rend, player_texture, &srcrect, &dstrect);
        
        // Updates the screen (renderer)
        c.SDL_RenderPresent(rend);

        // Calculates to 60 fps
        // 1000 ms equals 1s
        const miliseconds = 1000;
        const gameplay_frames = 60;
        c.SDL_Delay(miliseconds / gameplay_frames);
    }
}