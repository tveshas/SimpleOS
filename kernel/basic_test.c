#define VGA_MEMORY 0xA0000

struct {
    unsigned char* vga_memory;
} system_state;

extern void put_pixel(int x, int y, unsigned char color);
extern void clear_screen(unsigned char color);
extern void draw_rectangle(int x, int y, int width, int height, unsigned char color);

void kernel_main() {
    system_state.vga_memory = (unsigned char*)VGA_MEMORY;
    
    // Clear to green
    clear_screen(2);
    
    // Draw yellow rectangle
    draw_rectangle(100, 50, 120, 80, 14);
    
    // Draw white rectangle
    draw_rectangle(150, 100, 80, 60, 15);
    
    while(1);
}
