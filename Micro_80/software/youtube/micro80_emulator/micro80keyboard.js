// Micro 80 computer emulator from Radio magazine 1983
// (c) 25-05-2025 Alexey Morozov aleksey.f.morozov@gmail.com
// License: Apache License Version 2.0

function Micro80Keyboard(screenKeyboard) {
    let keyMatrix = [ 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF ];

    this.read = function(columns) {
        let result = 0xFF;
        for (let i in keyMatrix)
            if (~columns & (1 << i))
                result &= keyMatrix[i];
        return result;
    };

    function keyPressed(index, pressed) {
        const i = index >> 3;
        const mask = 1 << (index & 7);
        if (pressed)
            keyMatrix[i] &= ~mask;
        else
            keyMatrix[i] |= mask;
        if (screenKeyboard)
            screenKeyboard.keyPressed(index, pressed);
    }

    if (screenKeyboard)
        screenKeyboard.setKeyHandler(keyPressed);

    const keyTranslate = {
        'Digit0' : 0,
        'Digit1' : 1,
        'Digit2' : 2,
        'Digit3' : 3,
        'Digit4' : 4,
        'Digit5' : 5,
        'Digit6' : 6,
        'Digit7' : 8,
        'Digit8' : 9,
        'Digit9' : 10,
        'Semicolon' : 11, // ;:
        'NumpadMultiply' : 11,
        'Equal' : 12,          // ;+
        'NumpadAdd' : 12,      // ;+
        'Comma' : 13,          // ,<
        'Minus' : 14,          // -=
        'NumpadSubtract' : 14, // -=
        'Period' : 16,         // .>
        'Slash' : 17,          // /?
        'NumpadDivide' : 17,   // /?
        'Backquote' : 18,      // @
        'KeyA' : 19,
        'KeyB' : 20,
        'KeyC' : 21,
        'KeyD' : 22,
        'KeyE' : 24,
        'KeyF' : 25,
        'KeyG' : 26,
        'KeyH' : 27,
        'KeyI' : 28,
        'KeyJ' : 29,
        'KeyK' : 30,
        'KeyL' : 32,
        'KeyM' : 33,
        'KeyN' : 34,
        'KeyO' : 35,
        'KeyP' : 36,
        'KeyQ' : 37,
        'KeyR' : 38,
        'KeyS' : 40,
        'KeyT' : 41,
        'KeyU' : 42,
        'KeyV' : 43,
        'KeyW' : 44,
        'KeyX' : 45,
        'KeyY' : 46,
        'KeyZ' : 48,
        'BracketLeft' : 49,  // [
        'Backslash' : 50,    // \
        'BracketRight' : 51, // ]
        'Quote' : 52,        // ^ = `
        'Space' : 54,
        'ArrowRight' : 56,
        'ArrowLeft' : 57,
        'Backspace' : 64,
        'ArrowUp' : 58,
        'ArrowDown' : 59,
        'NumpadEnter' : 60,
        'Enter' : 60,
        'ShiftLeft' : 66,
        'ShiftRight' : 66,
        'F1' : 65, // УС
        'F2' : 61, // РУС
        'F3' : 62, // Home
    };

    function keyEvent(e, pressed) {
        const code = keyTranslate[e.code];
        if (code !== undefined) {
            e.preventDefault();
            keyPressed(code, pressed);
        }
    }

    document.addEventListener('keydown', function(e) {
        keyEvent(e, true);
    });

    document.addEventListener('keyup', function(e) {
        keyEvent(e, false);
    });
}
