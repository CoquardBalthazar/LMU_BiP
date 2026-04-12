# PONG (Processing)

Classic Pong built with [Processing](https://processing.org/) (Java mode). Two players share one keyboard: the left player chooses **QWERTY** or **AZERTY** movement keys at startup; the right player uses the **arrow keys**. Long rallies increase difficulty: the ball speeds up and both paddles shrink until someone scores.

## Requirements

- **Processing 3.x or 4.x** — [Download Processing](https://processing.org/download) for Windows, macOS, or Linux.
- **No extra libraries** — the sketch uses only the Processing core API (`size`, drawing primitives, `keyPressed` / `keyReleased`, etc.).

Java is bundled with the Processing application; you do not need to install a separate JDK for normal use.

## Installation

1. Install Processing from the official site and start the **Processing** application (sometimes called “Processing IDE” or “PDE”).
2. Clone or copy this repository to your machine (any folder path is fine).
3. Open the sketch **as a folder**, not by opening the `.pde` file alone:
   - **File → Open…** and select one of the sketch folders below, **or**
   - Drag the sketch folder onto the Processing window.

## Where to open the sketch

You can run either of these; they implement the same game logic.

| Location | Notes |
|----------|--------|
| `dev/main/` | Development sketch. Entry file is set via `sketch.properties` (`main=pong_v001.pde`). |
| `Balthazar_Coquard_PONG/` | Standalone copy; main tab is `Balthazar_Coquard_PONG.pde` (name matches the folder). |

After the folder opens, press the **Run** button (play icon) or use **Sketch → Run**.

## How to play

1. **Welcome screen**
   - Press **Q** — left player uses **QWERTY**: **W** / **S** / **A** / **D** (up / down / left / right within the left half).
   - Press **A** — left player uses **AZERTY**: **Z** / **S** / **Q** / **D** (same roles).
2. **Right player** always uses **↑** **↓** **←** **→** (movement within the right half).
3. After a point, **Space** serves the ball (on-screen prompt: “Press SPACE to start”).

First player to let the ball pass their side loses the point; scores are shown at the top.

## Features (assignment-oriented)

- **Score** — points when the ball leaves the left or right edge.
- **Faster ball** — horizontal speed increases on each successful paddle hit (capped at a maximum).
- **Shrinking paddles** — paddle height decreases as the rally continues; reset after each point.
- **2D paddle movement** — both paddles move vertically and horizontally within their half of the court.

## Project layout (Pong-related)

```
dev/main/
  pong_v001.pde    # main game + Ball / Paddle / Element classes
  sketch.properties
Balthazar_Coquard_PONG/
  Balthazar_Coquard_PONG.pde
  sketch.properties
```

Other folders under `dev/` are earlier tutorials and exercises; only the paths above are needed to run this Pong build.

## Troubleshooting

- **Sketch won’t run / “main tab” errors** — Always open the **folder** (`dev/main` or `Balthazar_Coquard_PONG`), not a single `.pde` file copied elsewhere. The sketch must keep its `sketch.properties` and tab structure intact.
- **Window size** — The game uses a fixed `1000×1000` canvas (`size(1000, 1000)` in `setup()`).
- **Keys not responding** — Click the game window so it has keyboard focus. On some layouts, ensure you picked **Q** vs **A** on the welcome screen so the left player’s keys match your keyboard.

## License

Educational project (LMU BiP context). Add a license here if you redistribute the code publicly.
