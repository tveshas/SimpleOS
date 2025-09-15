void kernel_main() {
    unsigned char* vga = (unsigned char*)0xA0000;
    
    // Fill entire screen with green (color 2)
    for(int i = 0; i < 64000; i++) {
        vga[i] = 2;
    }
    
    // Put red square in top-left (color 4)
    for(int y = 0; y < 50; y++) {
        for(int x = 0; x < 50; x++) {
            vga[y * 320 + x] = 4;
        }
    }
    
    // Infinite loop
    while(1);
}
