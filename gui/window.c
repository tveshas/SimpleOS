#define MAX_WINDOWS 8
#define TITLE_BAR_HEIGHT 16

typedef struct {
    int x, y, width, height;
    char title[32];
    unsigned char active;
    unsigned char visible;
} Window;

Window windows[MAX_WINDOWS];
int window_count = 0;

// External functions we'll use
extern void draw_rectangle(int x, int y, int width, int height, unsigned char color);
extern void draw_line(int x0, int y0, int x1, int y1, unsigned char color);
extern void draw_text(int x, int y, char* text, unsigned char color);

int create_window(int x, int y, int width, int height, char* title) {
    if(window_count >= MAX_WINDOWS) return -1;
    
    Window* w = &windows[window_count];
    w->x = x;
    w->y = y;
    w->width = width;
    w->height = height;
    w->visible = 1;
    w->active = 0;
    
    // Copy title (simple string copy)
    for(int i = 0; i < 31 && title[i]; i++) {
        w->title[i] = title[i];
    }
    w->title[31] = 0; // Null terminate
    
    return window_count++;
}

void draw_window(int window_id) {
    if(window_id >= window_count) return;
    Window* w = &windows[window_id];
    if(!w->visible) return;
    
    // Draw window background (light gray)
    draw_rectangle(w->x, w->y, w->width, w->height, 7);
    
    // Draw title bar (dark gray)
    draw_rectangle(w->x, w->y, w->width, TITLE_BAR_HEIGHT, 8);
    
    // Draw window border (black)
    draw_line(w->x, w->y, w->x + w->width, w->y, 0);
    draw_line(w->x, w->y, w->x, w->y + w->height, 0);
    draw_line(w->x + w->width, w->y, w->x + w->width, w->y + w->height, 0);
    draw_line(w->x, w->y + w->height, w->x + w->width, w->y + w->height, 0);
    
    // Draw title text
    draw_text(w->x + 4, w->y + 4, w->title, 15);
}

void draw_all_windows() {
    for(int i = 0; i < window_count; i++) {
        draw_window(i);
    }
}
