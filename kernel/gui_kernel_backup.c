#define VGA_MEMORY 0xA0000
#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 200

struct {
    unsigned char* vga_memory;
} system_state;

// Forward declarations
extern void put_pixel(int x, int y, unsigned char color);
extern void clear_screen(unsigned char color);
extern void draw_rectangle(int x, int y, int width, int height, unsigned char color);
extern void draw_text(int x, int y, char* text, unsigned char color);
extern int create_window(int x, int y, int width, int height, char* title);
extern void draw_all_windows();

void kernel_main() {
    system_state.vga_memory = (unsigned char*)VGA_MEMORY;
    
    // Clear to desktop blue
    clear_screen(1);
    
    // Create GUI windows
    create_window(50, 30, 200, 120, "FIRST WINDOW");
    create_window(100, 80, 150, 100, "SECOND WINDOW");
    create_window(20, 140, 180, 80, "THIRD WINDOW");
    
    // Draw all windows
    draw_all_windows();
    
    // Add desktop text
    draw_text(10, 10, "SIMPLEOS GUI DESKTOP", 15);
    
    // Main loop
    while(1) {
        for(int i = 0; i < 1000000; i++);
    }
}
