#define VGA_MEMORY 0xA0000
#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 200

struct {
    unsigned char* vga_memory;
    int mouse_x, mouse_y;
    int mouse_buttons;
} system_state;

// Forward declarations
extern void put_pixel(int x, int y, unsigned char color);
extern void clear_screen(unsigned char color);
extern void draw_rectangle(int x, int y, int width, int height, unsigned char color);
extern void draw_char(int x, int y, char c, unsigned char color);
extern void draw_text(int x, int y, char* text, unsigned char color);
extern int create_window(int x, int y, int width, int height, char* title);
extern void draw_all_windows();

// Mouse functions
extern void init_mouse();
extern void update_mouse();
extern void draw_cursor(int x, int y, unsigned char color);
extern int mouse_button_pressed(int button);

// Cursor management
static int old_cursor_x = 160, old_cursor_y = 100;

void kernel_main() {
    system_state.vga_memory = (unsigned char*)VGA_MEMORY;
    
    // Initialize mouse
    init_mouse();
    
    // Clear to blue desktop
    clear_screen(1);
    
    // Create windows
    create_window(50, 30, 200, 120, "WINDOW ONE");
    create_window(100, 80, 150, 100, "WINDOW TWO");
    create_window(20, 140, 180, 80, "WINDOW THREE");
    
    // Draw all windows
    draw_all_windows();
    
    // Desktop text (using our working font system)
    draw_text(10, 10, "MOUSE DESKTOP", 15);
    draw_text(10, 185, "CLICK TO TEST", 14);
    
    // Main loop with mouse
    while(1) {
        update_mouse();
        
        // Simple cursor (just a white cross)
        put_pixel(system_state.mouse_x, system_state.mouse_y, 15);
        put_pixel(system_state.mouse_x+1, system_state.mouse_y, 15);
        put_pixel(system_state.mouse_x-1, system_state.mouse_y, 15);
        put_pixel(system_state.mouse_x, system_state.mouse_y+1, 15);
        put_pixel(system_state.mouse_x, system_state.mouse_y-1, 15);
        
        // Click feedback
        if (mouse_button_pressed(0)) {
            draw_rectangle(system_state.mouse_x-2, system_state.mouse_y-2, 4, 4, 4);
        }
        
        // Delay
        for(int i = 0; i < 50000; i++);
    }
}
