#define VGA_MEMORY 0xA0000
#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 200

// System state
struct {
    unsigned char* vga_memory;
    int mouse_x, mouse_y;
    int mouse_buttons;
} system_state;

// Forward declarations
void put_pixel(int x, int y, unsigned char color);
void clear_screen(unsigned char color);
void draw_rectangle(int x, int y, int width, int height, unsigned char color);
void draw_line(int x0, int y0, int x1, int y1, unsigned char color);

// GUI functions (from your files)
extern void draw_text(int x, int y, char* text, unsigned char color);
extern int create_window(int x, int y, int width, int height, char* title);
extern void draw_all_windows();

void kernel_main() {
    // VGA mode already set by bootloader
    system_state.vga_memory = (unsigned char*)VGA_MEMORY;
    
    // Clear screen to desktop color (dark blue)
    clear_screen(1);
    
    // Create some test windows
    create_window(50, 30, 200, 120, "FIRST WINDOW");
    create_window(100, 80, 150, 100, "SECOND WINDOW"); 
    create_window(20, 140, 180, 80, "THIRD WINDOW");
    
    // Draw all windows
    draw_all_windows();
    
    // Add some desktop text
    draw_text(10, 10, "SIMPLEOS GUI DESKTOP", 15);
    
    // Main loop
    while(1) {
        // Simple delay
        for(int i = 0; i < 1000000; i++);
    }
}
