# Skyline Obby — Roblox Luau Gameplay Portfolio

Skyline Obby is a published Roblox obstacle-course experience built as a gameplay-programming portfolio project. It demonstrates server-authoritative game rules, per-player state, persistent progression, client/server RemoteEvent communication, responsive UI, multiplayer validation, and reusable obstacle systems.

## Live Project

- [Play Skyline Obby on Roblox](https://www.roblox.com/games/73249354946869/Skyline-Obby)
- [Watch the single-player gameplay demo](https://youtu.be/EjIpwnyU-CU)

## Highlights

- Five-coin objective validated on the server before completion
- Per-player coin collection and client-only coin visibility
- Checkpoints with correctly oriented respawns
- Server-synchronized run timer
- Persistent Wins and Best Time using `DataStoreService`
- Protected finish flow with duplicate-completion prevention
- Play Again flow that resets coins, checkpoints, timer, UI, and character state
- Physical moving platform using `AlignPosition` and `AlignOrientation`
- Reusable fading platforms, rotating hazard, and kill floor
- Responsive desktop/mobile HUD and audio controls
- Independent two-client multiplayer verification

## Technology

- Roblox Studio
- Luau
- Roblox client/server architecture
- `RemoteEvent`
- `DataStoreService`
- `RunService`
- `TweenService`
- Physics constraints and server network ownership

## Repository Layout

```text
skyline-obby-portfolio/
├── src/
│   ├── client/       # StarterPlayerScripts LocalScripts
│   ├── server/       # ServerScriptService Scripts
│   └── workspace/    # Scripts parented to gameplay parts
├── docs/
│   ├── ARCHITECTURE.md
│   └── ROBLOX_HIERARCHY.md
└── README.md
```

The repository contains 15 unique Luau scripts. `FadeScript.server.lua` is reused by all three fading-platform instances in the live place.

## Core Architecture

| Layer | Responsibilities |
| --- | --- |
| Server | Coin validation, checkpoint state, finish validation, persistent player data, authoritative completion time, respawn/restart flow, and physical obstacles |
| Client | HUD, objective state, local coin visibility, checkpoint notifications, audio, camera alignment, and restart input |
| Shared events | `CheckpointEvent`, `CoinVisibilityEvent`, `FeedbackEvent`, `FinishEvent`, and `RestartEvent` |

See [Architecture](docs/ARCHITECTURE.md) for the complete event flows and [Roblox Hierarchy](docs/ROBLOX_HIERARCHY.md) for exact script placement.

## Gameplay Flow

1. The server creates per-player leaderstats and loads persistent Wins and Best Time.
2. Coins are collected independently for each player.
3. Checkpoints store the latest valid respawn point for the current run.
4. The finish platform requires all five coins and rejects incomplete runs.
5. On a valid finish, the server freezes the character, increments Wins, calculates completion time, updates Best Time, and notifies the client.
6. Play Again creates a fresh character and clears run-specific coins and checkpoint state without erasing persistent statistics.

## Persistent Data

`PlayerDataScript.server.lua` uses the DataStore name:

```text
SkylineObbyPlayerData_v1
```

Persistent values:

- `Wins`
- `BestTime`

The `Coins` value is intentionally run-specific and is not persisted.

## Testing

The published experience was tested for:

- Complete single-player runs
- Two-player simultaneous sessions
- Independent coin state and visibility
- Duplicate finish protection
- Checkpoint death and respawn
- Play Again state reset
- Desktop HUD behavior
- Mobile controls and responsive HUD behavior
- Persistent Wins and Best Time

## Running the Code in Roblox Studio

1. Create the objects and RemoteEvents shown in [Roblox Hierarchy](docs/ROBLOX_HIERARCHY.md).
2. Place each `.server.lua` file in its documented server or Workspace location.
3. Place each `.client.lua` file in `StarterPlayer/StarterPlayerScripts`.
4. For Studio DataStore testing, enable **Game Settings → Security → Enable Studio Access to API Services** only in a safe test place.
5. Test with **Test → Start** using two clients to verify independent multiplayer state.

## Portfolio Note

This repository is shared as a code sample for portfolio and technical-review purposes. Audio asset IDs reference third-party Roblox assets and remain subject to their respective owners' terms.
