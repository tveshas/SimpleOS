#define VGA_MEMORY 0xA0000

struct {
    unsigned char* vga_memory;
} system_state;

extern void clear_screen(unsigned char color);
extern void draw_rectangle(int x, int y, int width, int height, unsigned char color);
extern int create_window(int x, int y, int width, int height, char* title);
extern void draw_all_windows();

// Simple pixel text - draw "HELLO" using rectangles
void draw_hello() {
    // H
    draw_rectangle(20, 20, 2, 20, 15);  // Left line
    draw_rectangle(32, 20, 2, 20, 15);  // Right line  
    draw_rectangle(20, 28, 14, 2, 15);  // Middle line
    
    // E
    draw_rectangle(40, 20, 2, 20, 15);  // Left line
    draw_rectangle(40, 20, 12, 2, 15);  // Top line
    draw_rectangle(40, 28, 10, 2, 15);  // Middle line
    draw_rectangle(40, 38, 12, 2, 15);  // Bottom line
    
    // L
    draw_rectangle(58, 20, 2, 20, 15);  // Vertical line
    draw_rectangle(58, 38, 10, 2, 15);  // Bottom line
    
    // L
    draw_rectangle(72, 20, 2, 20, 15);  // Vertical line
    draw_rectangle(72, 38, 10, 2, 15);  // Bottom line
    
    // O  
    draw_rectangle(86, 20, 12, 2, 15);  // Top
    draw_rectangle(86, 38, 12, 2, 15);  // Bottom
    draw_rectangle(86, 20, 2, 20, 15);  // Left
    draw_rectangle(96, 20, 2, 20, 15);  // Right
}

void kernel_main() {
    system_state.vga_memory = (unsigned char*)VGA_MEMORY;
    
    clear_screen(1);  // Blue background
    
    // Create 3 windows
    create_window(50, 60, 200, 120, "FIRST WINDOW");
    create_window(100, 100, 150, 100, "SECOND WINDOW");
    create_window(20, 150, 180, 80, "THIRD WINDOW");
    
    draw_all_windows();
    
    // Draw "HELLO" text using rectangles (this should work)
    draw_hello();
    
    while(1) {
        for(int i = 0; i < 1000000; i++);
    }
}
