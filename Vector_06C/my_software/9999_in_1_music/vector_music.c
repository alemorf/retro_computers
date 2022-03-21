// (c) 15 jun 2021 Aleksey Morozov (aleksey.f.morozov@gmail.com)

asm(" org 0x100");
asm("begin:");

// Sound chip
const int PORT_VI53_A = 0x0B;
const int PORT_VI53_B = 0x0A;
const int PORT_VI53_C = 0x09;
const int PORT_VI53_CONTROL = 0x08;
const int VI53_MODE_MUTE = 0;
const int VI53_MODE_MEANDER = 6;
const int VI53_SET_CHANNEL_MODE_0 = 0x30;
const int VI53_SET_CHANNEL_MODE_1 = 0x70;
const int VI53_SET_CHANNEL_MODE_2 = 0xB0;

// Interrupt handler
const int INTERRUPT_HANDLER_ENABLE = 0xC3;
const int INTERRUPT_HANDLER_EMPTY = 0xC9;
extern uint8_t interrupt_handler_mode = 0x38;
extern uint16_t interrupt_handler_address = 0x39;

// System port
const int PORT_SYSTEM_A = 3;
const int PORT_SYSTEM_B = 2;
const int PORT_SYSTEM_C = 1;
const int PORT_SYSTEM_MODE = 0;

// Palette
const int PALELLE_PROGRAMMING_MODE = 0x88;
const int PORT_PALETTE_INDEX = 0x02;
const int PORT_PALETTE_VALUE = 0x0C;

// Video
const int VIDEO_ADDRESS = 0x8000;
const int PALETTE_COUNT = 16;

// Main programm
void main() {
    disableInterrupts();
    
    // Init stack
    sp = &main;

    // Reset palette
    setPalette(hl = &black_palette);

    // Clear screen
    hl = VIDEO_ADDRESS;
    a ^= a; // a = 0
    do {
        *hl = a;
        hl++;
    } while(a != h);

    // Init music
    musicInit();

    // Set irq handler
    interrupt_handler_mode = a = INTERRUPT_HANDLER_ENABLE;
    interrupt_handler_address = hl = &irqHandler;
    
    // Enable interrupts
    enableInterrupts();
    
    // Infinite loop
    while() {
        halt();
    }
}

uint8_t black_palette[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

void irqHandler() {
    push(a, bc, de, hl) {
        musicTick();
    }
    enable_interrupts();    
}

void memcpy(de, hl, c) {
    do {
        *de = a = *hl; hl++; de++;
    } while(flag_nz --c);
}

void setPalette(hl) {
    // Сan change the palette only during horizontal blanking. 
    // These are columns 0, 32 - 47 of 48. 

    // Setup GPIO mode for palette programming
    out(PORT_SYSTEM_MODE, a = PALELLE_PROGRAMMING_MODE);
    
    // Set empty interrupt handler
    interrupt_handler_mode = a = INTERRUPT_HANDLER_EMPTY;

    // Synchronize the processor with the video controller 
    a ^= a;
    enable_interrupts();
    halt();

    // Not 9-th column (if the interrupt handler is empty)

    c = a;                  // 9-11
    do {
        out(PORT_PALETTE_INDEX, a);       // 11-14
        a = *hl;            // 14-16
        out(PORT_PALETTE_VALUE, a);       // 16-19 ---
        hl++;               // 19-21
        c++;                // 21-23

        out(PORT_PALETTE_INDEX, a = c);   // 24-29
        a = *hl;            // 29-31
        out(PORT_PALETTE_VALUE, a);       // 31-34 ---
        hl++;               // 34-36
        c++;                // 36-38

        swap(*sp, hl);      // 38-44
        swap(*sp, hl);      // 44-2
        a = c; a = c;       // 3-6
    } while(a < PALETTE_COUNT);        // 7-11
}

// *** Music algorithm ***

// State of current music channel. Temporary variables.
uint8_t  musicDelay = 0;
uint16_t musicPtr = 0;
uint8_t  musicSubRepeatCounter = 0;
uint16_t musicSubRet = 0;

// Music channel 0 state
uint8_t  music1Delay = 0;
uint16_t music1Ptr = 0;
uint8_t  music1SubCnt = 0;
uint16_t music1SubRet = 0;

// Music channel 1 state
uint8_t  music2Delay = 0;
uint16_t music2Ptr = 0;
uint8_t  music2SubCnt = 0;
uint16_t music2SubRet = 0;

// Music channel 2 state
uint8_t  music3Delay = 0;
uint16_t music3Ptr = 0;
uint8_t  music3SubCnt = 0;
uint16_t music3SubRet = 0;

// Music rythm state
uint8_t  musicRythm = 0;
uint16_t musicRythmFreq = 0;

const int MUSIC_RYTHM_PERIOD = 12 * 6;

const int MUSIC_COMMAND_DELAY = 0x81;
const int MUSIC_COMMAND_SUBROUTINE = 0x84;
const int MUSIC_COMMAND_END_SUBROUTINE = 0x85;

void musicInit() {
    music1Ptr = hl = &musicChannel1;
    music2Ptr = hl = &musicChannel2;
    music3Ptr = hl = &musicChannel3;
    music1Delay = (a ^= a);
    music2Delay = a;
    music3Delay = a;
    a++;
    musicRythm = a; // a = 1
    noreturn;
}

void musicOff() {
    out(PORT_VI53_CONTROL, a = [VI53_SET_CHANNEL_MODE_0 | VI53_MODE_MUTE]);
    out(PORT_VI53_CONTROL, a = [VI53_SET_CHANNEL_MODE_1 | VI53_MODE_MUTE]);
    out(PORT_VI53_CONTROL, a = [VI53_SET_CHANNEL_MODE_2 | VI53_MODE_MUTE]);
}

void musicTick() {
    musicChannel(hl = &music1Delay);
    if (flag_nc) {
        a |= VI53_SET_CHANNEL_MODE_0;
        out(PORT_VI53_CONTROL, a);
        out(PORT_VI53_A, a = l);
        out(PORT_VI53_A, a = h);
    }
    musicChannel(hl = &music2Delay);
    if (flag_nc) {
        a |= VI53_SET_CHANNEL_MODE_1;
        out(PORT_VI53_CONTROL, a);
        out(PORT_VI53_B, a = l);
        out(PORT_VI53_B, a = h);
    }
    musicChannel(hl = &music3Delay);
    if (flag_nc) {
        a |= VI53_SET_CHANNEL_MODE_2;
        out(PORT_VI53_CONTROL, a);
        hl += hl; // -1 octave
        musicRythmFreq = hl;
    }

    hl = musicRythmFreq;
    a = musicRythm;
    a--;
    if (flag_z) {
        a = MUSIC_RYTHM_PERIOD;
        hl += hl; // -1 octave
    }
    musicRythm = a;
    out(PORT_VI53_C, a = l);
    out(PORT_VI53_C, a = h);
}

void musicChannel(hl) {
    // Delay before processing the next command 
    a = *hl;
    if (a >= 2) {
        a--;
        *hl = a;
        (a ^= a) -= 1; // Set flag C for return
        return;
    }

    // Copy music channel state
    push(hl);
    memcpy(de = &musicDelay, hl, c = [&music2Delay - &music1Delay]);

    // Read 2 bypes from the music programm
    hl = musicPtr;
musicRetry:
    a = *hl; hl++;
    b = *hl; hl++;
    musicPtr = hl;

    // This is a musical note
    if (a < [(&notesEnd - &notes) / 2]) {
        l = ((a += a) += &notes); // Convert the musical note number to period by table
        h = ((a +@= [&notes >> 8]) -= l);
        musicDelay = a = b; // The second byte is a delay
        c = *hl; hl++;
        b = *hl;
    } else {
        // This is a delay
        if (a == MUSIC_COMMAND_DELAY) {
            musicDelay = a = b;  // The second byte is a delay
            bc = 0;
        } else {
            // This is a subroutine
            if (a == MUSIC_COMMAND_SUBROUTINE) {
                a = b;  // The second byte is a subroutine repeat counter
                a++;
                musicSubRet = hl; 
                goto musicReturn; // Third and fourth bytes are a subroutine address
            }
            // This is the end of the subroutine
            if (a == MUSIC_COMMAND_END_SUBROUTINE) {
                hl = musicSubRet; // Read the subroutime start address from the main programm
                a = musicSubRepeatCounter;
musicReturn:    e = *hl; hl++;
                d = *hl; hl++;
                a--;  // Decrease the subroutime repeat counter
                musicSubRepeatCounter = a;
                if (flag_nz) { // If the subroutime repeat counter is zero,
                    swap(hl, de); // then change the subroutine start address to the main programm address
                }
                goto musicRetry;
            }
            // Any other command resets the music channel
            pop(hl);
            pop(hl); // Remove the return address to the musicTick() function
            musicInit();
            return musicTick();
        }
    }

    pop(de); // Save music channel state
    push(bc);
    memcpy(de, hl = &musicDelay, c = [&music2Delay - &music1Delay]);
    pop(hl);
    a ^= a; // Reset flag C for return
    a = VI53_MODE_MEANDER;
}

// *** Music ***

uint16_t notes[] = {
    0x6AE0,
    0x5F30,
    0x59E0,
    0x54D0,
    0x5010,
    0x4B90,
    0x4750,
    0x4350,
    0x3F80,
    0x3BF0,
    0x3890,
    0x3570,
    0x3270,
    0x2F90,
    0x2CF0,
    0x2A60,
    0x2800,
    0x25C0,
    0x23A0,
    0x21A0,
    0x1FC0,
    0x1DF0,
    0x1C40,
    0x1AB0,
    0x1930,
    0x17C0,
    0x1670,
    0x1520,
    0x13F0,
    0x12D0,
    0x11C0,
    0x10C0,
    0x0FD0,
    0x0EE0,
    0x0E10,
    0x0D40,
    0x0C80,
    0x0BD0,
    0x0B20,
    0x0A80,
    0x09F0,
    0x0960,
    0x08D0,
    0x0850,
    0x07E0,
    0x0760,
    0x0700,
    0x0690,
    0x0630,
    0x05E0,
    0x0580,
    0x0530,
    0x04F0,
    0x04A0,
    0x0460,
    0x0420,
    0x03E0,
    0x03A0,
    0x0370,
    0x0340,
    0x0310,
    0x02E0,
    0x02B0,
    0x0290,
    0x0270,
    0x0240,
    0x0220,
    0x0200,
    0x01E0,
    0x01C0,
    0x01B0
};
notesEnd:

uint8_t musicChannel1[] = {
    0x24, 0x60,
    0x81, 0xC,
    0x28, 0x30,
    0x26, 0xC,
    0x24, 0xC,
    0x26, 0xC,
    0x24, 0x48,
    0x81, 0xC,
    0x26, 0xC,
    0x28, 0xC,
    0x24, 0xC,
    0x24, 0x60,
    0x81, 0xC,
    0x24, 0xC,
    0x1F, 0x30,
    0x23, 0x18,
    0x26, 0x30,
    0x28, 0x18,
    0x24, 0x18,
    0x24, 0x60,
    0x81, 0xC,
    0x26, 0xC,
    0x24, 0x60,
    0x81, 0xC,
    0x1C, 0x18,
    0x1D, 0xC,
    0x1F, 0x90,
    0x81, 0x90,
    0x24, 0x60,
    0x81, 0x18,
    0x28, 0x24,
    0x81, 6,
    0x26, 6,
    0x24, 6,
    0x26, 6,
    0x24, 0x60,
    0x26, 0x18,
    0x28, 6,
    0x24, 6,
    0x24, 6,
    0x26, 6,
    0x21, 0x60,
    0x24, 0xC,
    0x1F, 0x30,
    0x23, 0x18,
    0x26, 0x48,
    0x28, 0xC,
    0x24, 0xC,
    0x26, 0xC,
    0x24, 0x48,
    0x28, 0x12,
    0x26, 6,
    0x24, 6,
    0x26, 6,
    0x24, 0x60,
    0x81, 0x18,
    0x24, 0x18,
    0x2B, 0x90,
    0x2F, 0x48,
    0x2D, 6,
    0x2F, 6,
    0x2D, 6,
    0x2B, 6,
    0x2D, 6,
    0x2B, 6,
    0x29, 0x24,
    0x28, 0x30,
    0x24, 0x18,
    0x1F, 0x90,
    0x81, 0x48,
    0x24, 0x30,
    0x81, 6,
    0x26, 6,
    0x24, 6,
    0x26, 6,
    0x24, 0x48,
    0x23, 0x12,
    0x1F, 0x12,
    0x1C, 0x60,
    0x23, 0x48,
    0x21, 0xC,
    0x1D, 0xC,
    0x1A, 0x30,
    0x81, 0xC,
    0x26, 0x48,
    0x28, 0xC,
    0x26, 0xC,
    0x28, 0xC,
    0x2B, 0xC,
    0x2D, 0x12,
    0x28, 6,
    0x26, 6,
    0x24, 6,
    0x26, 6,
    0x24, 0x90,
    0x81, 0x7E,
    0x84, 1, &F6B9, [&F6B9 >> 8],
    0x26, 0xC,
    0x24, 0xC,
    0x28, 0xC,
    0x2B, 0x24,
    0x2D, 0xC,
    0x28, 0xC,
    0x24, 6,
    0x26, 6,
    0x24, 0x30,
    0x81, 0xC,
    0x84, 1, &F6B9, [&F6B9 >> 8],
    0x28, 0xC,
    0x26, 0xC,
    0x24, 0x90,
    0x86
};

uint8_t F6B9[] = {
    0x1D, 0xC,
    0x1F, 0x24,
    0x21, 0xC,
    0x24, 0xC,
    0x23, 0x30,
    0x24, 0xC,
    0x23, 0xC,
    0x21, 0x30,
    0x1D, 0xC,
    0x21, 0xC,
    0x1F, 0x48,
    0x1D, 0xC,
    0x1F, 0x24,
    0x21, 0xC,
    0x24, 0xC,
    0x26, 0x30,
    0x85
};

uint8_t musicChannel2[] = {
    0x84, 2, &F791, [&F791 >> 8],
    0x84, 2, &F79E, [&F79E >> 8],
    0x84, 2, &F7AB, [&F7AB >> 8],
    0x84, 2, &F7B8, [&F7B8 >> 8],
    0x84, 2, &F791, [&F791 >> 8],
    0x84, 2, &F79E, [&F79E >> 8],
    0x84, 2, &F7C5, [&F7C5 >> 8],
    0x84, 2, &F7B8, [&F7B8 >> 8],
    0x84, 2, &F791, [&F791 >> 8],
    0x84, 2, &F79E, [&F79E >> 8],
    0x84, 2, &F7AB, [&F7AB >> 8],
    0x84, 2, &F7B8, [&F7B8 >> 8],
    0x84, 2, &F791, [&F791 >> 8],
    0x84, 2, &F79E, [&F79E >> 8],
    0x84, 2, &F7C5, [&F7C5 >> 8],
    0x84, 2, &F7B8, [&F7B8 >> 8],
    0x84, 2, &F791, [&F791 >> 8],
    0x84, 2, &F7B8, [&F7B8 >> 8],
    0x84, 2, &F791, [&F791 >> 8],
    0x10, 0xC,
    0x13, 0xC,
    0x17, 0xC,
    0x1C, 0xC,
    0x17, 0xC,
    0x1F, 0xC,
    0x84, 1, &F7C5, [&F7C5 >> 8],
    0x11, 0xC,
    0x15, 0xC,
    0x18, 0xC,
    0x1D, 0xC,
     0xC, 0xC,
    0x15, 0xC,
    0x84, 1, &F7AB, [&F7AB >> 8],
    0x84, 2, &F7B8, [&F7B8 >> 8],
    0x84, 2, &F791, [&F791 >> 8],
    0x84, 2, &F7D2, [&F7D2 >> 8],
    0x84, 1, &F7AB, [&F7AB >> 8],
    0x84, 1, &F7DF, [&F7DF >> 8],
    0x84, 1, &F7AB, [&F7AB >> 8],
    0x84, 1, &F7EC, [&F7EC >> 8],
    0x84, 1, &F7AB, [&F7AB >> 8],
    0x84, 1, &F7DF, [&F7DF >> 8],
    0x84, 1, &F791, [&F791 >> 8],
    0x84, 1, &F7D2, [&F7D2 >> 8],
    0x84, 1, &F7AB, [&F7AB >> 8],
    0x84, 1, &F7DF, [&F7DF >> 8],
    0x84, 1, &F7AB, [&F7AB >> 8],
    0x84, 1, &F7EC, [&F7EC >> 8],
    0x84, 1, &F7AB, [&F7AB >> 8],
    0x84, 1, &F7DF, [&F7DF >> 8],
    0x84, 2, &F791, [&F791 >> 8],
    0x86
};

uint8_t F791[] = {
    0x18, 0xC,
    0x1C, 0xC,
    0x1F, 0xC,
    0x24, 0xC,
    0x1F, 0xC,
    0x1C, 0xC,
    0x85
};

uint8_t F79E[] = {
    0x15, 0xC,
    0x18, 0xC,
    0x1C, 0xC,
    0x21, 0xC,
    0x1C, 0xC,
    0x18, 0xC,
    0x85
};

uint8_t F7AB[] = {
    0x11, 0xC,
    0x15, 0xC,
    0x18, 0xC,
    0x1D, 0xC,
    0x18, 0xC,
    0x15, 0xC,
    0x85
};

uint8_t F7B8[] = {
    0x13, 0xC,
    0x17, 0xC,
    0x1A, 0xC,
    0x1F, 0xC,
    0x1A, 0xC,
    0x17, 0xC,
    0x85
};

uint8_t F7C5[] = {
    0x10, 0xC,
    0x13, 0xC,
    0x17, 0xC,
    0x1C, 0xC,
    0x17, 0xC,
    0x13, 0xC,
    0x85
};

uint8_t F7D2[] = {
    0x18, 0xC,
    0x1C, 0xC,
    0x1F, 0xC,
    0x22, 0xC,
    0x1F, 0xC,
    0x1C, 0xC,
    0x85
};

uint8_t F7DF[] = {
    0x13, 0xC,
    0x17, 0xC,
    0x1A, 0xC,
    0x1D, 0xC,
    0x1A, 0xC,
    0x17, 0xC,
    0x85
};

uint8_t F7EC[] = {
    0xF, 0xC,
    0x13, 0xC,
    0x16, 0xC,
    0x1B, 0xC,
    0x16, 0xC,
    0x13, 0xC,
    0x85
};

uint8_t musicChannel3[] = {
    0x18, 0x90,
    0x15, 0x90,
    0x11, 0x90,
    0x13, 0x90,
    0x18, 0x90,
    0x15, 0x90,
    0x10, 0x90,
    0x13, 0x24,
    0x1F, 0x24,
    0x23, 0x24,
    0x26, 0x24,
    0x1C, 0x24,
    0x84, 1, &F856, [&F856 >> 8],
    0x24, 0x48,
    0x1D, 0x24,
    0x26, 0x24,
    0x24, 0x24,
    0x23, 0x24,
    0x1F, 0x24,
    0x28, 0x24,
    0x26, 0x24,
    0x81, 0x24,
    0x84, 1, &F856, [&F856 >> 8],
    0x24, 0x24,
    0x1F, 0x90,
    0x26, 0x90,
    0x24, 0x90,
    0x23, 0x24,
    0x1F, 0x24,
    0x23, 0x24,
    0x26, 0x24,
    0x18, 0x90,
    0x1C, 0x90,
    0x1D, 0x90,
    0x1F, 0x90,
    0x18, 0x90,
    0x81, 0x90,
    0x84, 1, &F861, [&F861 >> 8],
    0x16, 0x48,
    0x84, 1, &F861, [&F861 >> 8],
    0x18, 0x48,
    0x86
};

uint8_t F856[] = {
    0x1C, 0x24,
    0x1F, 0x24,
    0x24, 0x48,
    0x1C, 0x24,
    0x21, 0x24,
    0x85
};

uint8_t F861[] = {
    0x11, 0x48,
    0x13, 0x48,
    0x15, 0x48,
    0x16, 0x48,
    0x11, 0x48,
    0x13, 0x48,
    0x18, 0x48,
    0x85
};

