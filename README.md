# ⚡ DIGITAL CODE LAB

> **"Understand how computers turn characters, numbers and messages into digital signals."**

A modern, highly interactive educational laboratory and cyberpunk visual simulator built with React, TypeScript, Tailwind CSS, Framer Motion, and Web Audio API.

---

## 🎯 Features & Modules

1. **ASCII Code Simulator (`ASCII Lab`)**
   - Live transformation pipeline: `Character` ➔ `ASCII (Decimal)` ➔ `Binary (8-bit)` ➔ `Hexadecimal (0x..)`.
   - Interactive 8-bit switchboard: mutate any bit live (demonstrating the Bit 5 case toggle between `'A'` and `'a'`).
   - Full message serializer: convert multi-character sentences into byte arrays.
   - Complete 0–127 ASCII lookup table with control code definitions, binary streams, and category filters.

2. **BCD Simulator (`Binary-Coded Decimal`)**
   - Independent 4-bit nibble decomposition (8-4-2-1 weight).
   - Side-by-side comparison: **Pure Binary vs BCD**.
   - Step-by-step division and practice drills with instant feedback and explanations.

3. **Matrix Display Simulator (`8×8 LED Grid`)**
   - Interactive glowing LED grid with click & drag painting.
   - Pre-loaded patterns: Letters (`A`, `B`, `C`), Digits (`0`–`9`), Symbols (`Heart`, `Arrow`, `Smile`), and Retro Icons (`Space Invader`, `Pacman`).
   - Hardware **Scan Mode**: animated row-by-row multiplexing with adjustable scan speed.
   - Live binary row streams & C/Arduino byte array code export.

4. **Morse Code Simulator (`Optical & CW Audio`)**
   - Bidirectional translation: **Text ➔ Morse** and **Morse ➔ Text**.
   - Blinking optical beacon transmitter.
   - Native Web Audio API CW oscillator (real 750Hz tones, no external audio files required).
   - Interactive straight telegraph key: tap for dots, hold for dashes.

5. **Binary Number Lab (`Base 2 Switchboard`)**
   - 8-bit physical toggle switches with powers-of-2 weights (`128 64 32 16 8 4 2 1`).
   - Real-time conversion HUD: Decimal, Binary, Hex, Octal, ASCII, and Two's Complement.
   - Step-by-step Division-by-2 algorithm visualizer.
   - Bitwise logic gate laboratory (`AND`, `OR`, `XOR`, `NOT`, `<<`, `>>`).

6. **Digital Code Playground (`Signal Oscilloscope`)**
   - 3-column live laboratory:
     - **Left**: Character, decimal, and bit inputs.
     - **Center**: Real-time oscilloscope square wave showing HIGH (+5V) and LOW (0V) logic levels.
     - **Right**: Unified real-time conversion into ASCII, Hex, Binary, BCD, and Morse.

7. **Curriculum Roadmap & Quizzes**
   - 8-step structured progression.
   - Interactive quizzes with explanations, final score computation, and confetti celebratory effects.
   - Student Learning Dashboard with badges and local persistence in `localStorage`.

---

## 🚀 Getting Started

### Development Server
```bash
npm install
npm run dev
```
Open [http://localhost:5173] in your browser.

### VS Code / IDE Launch
Open the **Run & Debug** panel (`Ctrl + Shift + D` or `F5`) and select:
- **"Launch Chrome against Digital Code Lab (localhost:5173)"**
- Or **"Launch Microsoft Edge against Digital Code Lab (localhost:5173)"**

### Production Build
```bash
npm run build
```
Generates production assets in `dist/` with relative paths (`base: './'`), suitable for Apache (`htdocs`), GitHub Pages, or static hosting.

https://digitalcodelab.lovable.app/