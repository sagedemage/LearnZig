const c = @cImport({
    @cInclude("SDL2/SDL.h");
});

const screen_width = 800;
const screen_height = 450;

pub fn main() void {
    _ = c.SDL_Init(c.SDL_INIT_VIDEO);
    defer c.SDL_Quit();

    var window = c.SDL_CreateWindow("SDL2 Window", c.SDL_WINDOWPOS_CENTERED, c.SDL_WINDOWPOS_CENTERED, 640, 400, 0);

    var renderer = c.SDL_CreateRenderer(window, 0, c.SDL_RENDERER_PRESENTVSYNC);
    defer c.SDL_DestroyRenderer(renderer);

    mainloop: while(true) {
        var sdl_event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&sdl_event) != 0) {
            switch(sdl_event.type) {
                c.SDL_QUIT => break :mainloop,
                else => {},
            }
        }

        // [ Red, Green, Blue, Alpha ]
        _ = c.SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
        _ = c.SDL_RenderClear(renderer);
        c.SDL_RenderPresent(renderer);
    }
}