// External references
extern struct {
    unsigned char* vga_memory;
    int mouse_x, mouse_y;
    int mouse_buttons;
} system_state;

#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 200

// Ultra simple graphics - just pixel plotting
void put_pixel(int x, int y, unsigned char color) {
    if(x >= 0 && x < SCREEN_WIDTH && y >= 0 && y < SCREEN_HEIGHT) {
        system_state.vga_memory[y * SCREEN_WIDTH + x] = color;
    }
}

void clear_screen(unsigned char color) {
    for(int i = 0; i < SCREEN_WIDTH * SCREEN_HEIGHT; i++) {
        system_state.vga_memory[i] = color;
    }
}

// Simple line drawing
void draw_line(int x0, int y0, int x1, int y1, unsigned char color) {
    int dx = x1 - x0;
    int dy = y1 - y0;
    int steps = (dx > dy) ? dx : dy;
    
    if(steps < 0) steps = -steps;
    if(steps == 0) return;
    
    float x_inc = (float)dx / steps;
    float y_inc = (float)dy / steps;
    
    float x = x0, y = y0;
    for(int i = 0; i <= steps; i++) {
        put_pixel((int)x, (int)y, color);
        x += x_inc;
        y += y_inc;
    }
}

void draw_rectangle(int x, int y, int width, int height, unsigned char color) {
    for(int i = 0; i < width; i++) {
        for(int j = 0; j < height; j++) {
            put_pixel(x + i, y + j, color);
        }
    }
}
