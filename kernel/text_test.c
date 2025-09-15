#define VGA_MEMORY 0xA0000

struct {
    unsigned char* vga_memory;
    int mouse_x, mouse_y;
    int mouse_buttons;
} system_state;

extern void clear_screen(unsigned char color);
extern void draw_char(int x, int y, char c, unsigned char color);
extern void draw_text(int x, int y, char* text, unsigned char color);

void kernel_main() {
    system_state.vga_memory = (unsigned char*)VGA_MEMORY;
    clear_screen(2);  // Green
    
    // Test individual characters
    draw_char(10, 10, 'A', 15);
    draw_char(20, 10, 'B', 15);
    draw_char(30, 10, 'C', 15);
    
    // Test text strings
    draw_text(10, 30, "HELLO", 14);      // Yellow
    draw_text(10, 50, "WORLD", 12);      // Red
    draw_text(10, 70, "SUCCESS", 15);    // White
    
    while(1) {
        for(int i = 0; i < 1000000; i++);
    }
}
