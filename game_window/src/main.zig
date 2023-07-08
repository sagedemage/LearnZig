const c = @cImport({
    @cInclude("SDL2/SDL.h");
});

const level_width = 640;
const level_height = 400;
const screen_width = 800;
const screen_height = 450;
const image_width = 40;
const image_height = 40;

pub fn main() void {
    _ = c.SDL_Init(c.SDL_INIT_VIDEO);
    defer c.SDL_Quit();

    const window = c.SDL_CreateWindow("SDL2 Window", c.SDL_WINDOWPOS_CENTERED, c.SDL_WINDOWPOS_CENTERED, level_width, level_height, 0);

    const rend = c.SDL_CreateRenderer(window, 0, c.SDL_RENDERER_ACCELERATED);
    defer c.SDL_DestroyRenderer(rend);

    const image_surface = c.SDL_LoadBMP("test.bmp");
    defer c.SDL_FreeSurface(image_surface);

    const image_texture = c.SDL_CreateTextureFromSurface(rend, image_surface);
    defer c.SDL_DestroyTexture(image_texture);

    const srcrect = c.SDL_Rect{.x = 0, .y = 0, .w = image_width, .h = image_height};
    const dstreact = c.SDL_Rect{.x = 20, .y = 20, .w = image_width, .h = image_height};

    // [ Red, Green, Blue, Alpha ]
    _ = c.SDL_SetRenderDrawColor(rend, 255, 255, 255, 255);

    mainloop: while(true) {
        var sdl_event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&sdl_event) != 0) {
            switch(sdl_event.type) {
                c.SDL_QUIT => break :mainloop,
                else => {},
            }
        }

        // srcrect, dstrect
        _ = c.SDL_RenderClear(rend);
        _ = c.SDL_RenderCopy(rend, image_texture, &srcrect, &dstreact);
        c.SDL_RenderPresent(rend);
    }
}