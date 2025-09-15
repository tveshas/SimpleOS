#define VGA_MEMORY 0xA0000
struct { unsigned char* vga_memory; } system_state;
extern void clear_screen(unsigned char color);
extern void draw_rectangle(int x, int y, int width, int height, unsigned char color);
void kernel_main() {
    system_state.vga_memory = (unsigned char*)VGA_MEMORY;
    clear_screen(1);
    // H - letter H
    draw_rectangle(50, 50, 3, 25, 15);  // Left vertical line
    draw_rectangle(65, 50, 3, 25, 15);  // Right vertical line  
    draw_rectangle(50, 60, 18, 3, 15);  // Middle horizontal line
    // I - letter I
    draw_rectangle(85, 50, 15, 3, 15);  // Top horizontal line
    draw_rectangle(90, 50, 3, 25, 15);  // Middle vertical line
    draw_rectangle(85, 72, 15, 3, 15);  // Bottom horizontal line
    while(1) { for(int i = 0; i < 1000000; i++); }
}
