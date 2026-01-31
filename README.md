# Super Mario Bros - Assembly Game

A classic side-scrolling platformer inspired by Super Mario Bros, implemented entirely in x86 Assembly language using MASM32 and the Irvine32 library.

## About The Game

This is a text-based recreation of the iconic Super Mario Bros game, featuring two challenging levels with platforming mechanics, enemies, power-ups, and scoring systems. Players control Mario through console-rendered levels, collecting coins, defeating enemies, and racing against time to reach the flag.

## Key Features

- **Two Distinct Levels**: Classic Mario-style layout with pitfalls and a pyramid-themed second level
- **Mario Power States**: Small Mario → Big Mario (via Mushroom) → Fire Mario
- **Combat System**: Stomp enemies, shoot fireballs, and use special freeze power
- **Double Jump Mechanics**: Enhanced movement with mid-air double jump capability
- **Enemy Variety**: Goombas and Koopas with shell mechanics
- **Score & Lives System**: Collect coins (50 coins = extra life), track high scores
- **Save/Load Progress**: Continue from where you left off
- **Sound Effects**: Audio feedback for jumps, coins, and power-ups using Windows API

## Core Game Mechanics

### Physics Engine
- Gravity simulation with velocity-based jumping
- Variable jump height based on button hold duration
- Ground collision detection and platform interactions
- Pitfall detection with life penalty system

### Collision System
- Enemy stomping from above (defeat) vs side collision (damage)
- Mystery block interactions (hit from below for power-ups)
- Breakable platform destruction
- Coin and power-up collection detection

### Power-Up System
- **Mushroom (M)**: Transforms Small Mario to Big Mario
- **Fire Flower**: Grants fireball shooting ability (SPACE key)
- **Freeze Power (C)**: Immobilizes all enemies for 5 seconds

### Enemy AI
- Directional movement with platform edge detection
- Reversal on collision with walls or other enemies
- Koopa shell mechanics (becomes projectile when stomped)
- Freeze state when special power is activated

### Scoring & Progression
- Enemy defeats: 100 points each
- Coin collection: 100 points each
- Time bonus upon level completion
- Level requirements: 700+ points to advance from Level 1
- Top 3 high score tracking with player names

## Learning Outcomes

### Assembly Programming Concepts
1. **Memory Management**: Direct manipulation of byte arrays for game state, sprite positions, and level maps
2. **Low-Level Graphics**: Console-based rendering using Windows API (SetConsoleCursorPosition, WriteConsoleOutputCharacter)
3. **Input Handling**: Real-time keyboard input detection without blocking game loop
4. **Procedure Organization**: Modular design with 50+ procedures for game logic separation

### Game Development Patterns
1. **Game Loop Architecture**: Frame-based update cycle with input → update → render pipeline
2. **State Machines**: Managing game states (menu, playing, paused, game over, level complete)
3. **Collision Detection**: AABB (Axis-Aligned Bounding Box) methods for entity interactions
4. **Delta Time Management**: Frame-independent movement and timer systems

### Technical Challenges Solved
1. **Performance Optimization**: Dirty rectangle rendering to minimize console writes
2. **Sound Integration**: MCI commands for MP3 playback and Windows Beep API for effects
3. **File I/O**: Binary save/load system for high scores and game progress
4. **Data Structures**: Parallel arrays for managing multiple entities (enemies, coins, fireballs)

## Technical Stack

- **Language**: x86 Assembly (MASM32)
- **Libraries**: Irvine32.inc, Windows API (winmm.lib)
- **Platform**: Windows Console Application
- **Sound**: MCI API for MP3 playback, Beep API for sound effects

## Key Takeaways

This project demonstrates that complex game mechanics traditionally implemented in high-level languages can be successfully recreated in Assembly. The experience provides deep insight into:
- How higher-level abstractions work at the machine level
- The importance of efficient algorithms when working close to hardware
- Memory layout and data structure design without automatic memory management
- The relationship between game logic and rendering systems

The project showcases that even "low-level" programming can create engaging, feature-rich applications with careful planning and execution.

---

**Author**: Muhammad Farhan
- Project Focus : Low level programming, systems
