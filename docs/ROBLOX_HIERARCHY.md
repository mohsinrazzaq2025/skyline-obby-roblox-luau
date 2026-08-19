# Roblox Hierarchy and Script Placement

The live Roblox place uses the following relevant hierarchy.

```text
Workspace
├── Checkpoints
│   ├── Checkpoint1
│   └── Checkpoint2
├── Coins
│   ├── Coin01
│   ├── Coin02
│   ├── Coin03
│   ├── Coin04
│   └── Coin05
├── FadingPlatform01
│   └── FadeScript
├── FadingPlatform02
│   └── FadeScript
├── FadingPlatform03
│   └── FadeScript
├── FinishPlatform
│   ├── FinishScript
│   └── VictoryParticles
├── KillFloor
│   └── killScript
├── MovingPlatform01
│   └── MovingPlatformScript
├── MovingPlatformEnd
└── RotatingBeam
    └── RotatingBeamScript

ReplicatedStorage
├── CheckpointEvent
├── CoinVisibilityEvent
├── FeedbackEvent
├── FinishEvent
└── RestartEvent

ServerScriptService
├── CheckpointSystem
├── CoinSystem
└── PlayerDataScript

StarterPlayer
└── StarterPlayerScripts
    ├── AudioControlClient
    ├── CameraRespawnClient
    ├── CheckpointClient
    ├── CoinVisibilityClient
    ├── ObjectiveClient
    ├── SoundEffectsClient
    └── TimerClient
```

## Repository-to-Studio Mapping

| Repository file | Roblox Studio destination |
| --- | --- |
| `src/server/CheckpointSystem.server.lua` | `ServerScriptService/CheckpointSystem` |
| `src/server/CoinSystem.server.lua` | `ServerScriptService/CoinSystem` |
| `src/server/PlayerDataScript.server.lua` | `ServerScriptService/PlayerDataScript` |
| `src/client/AudioControlClient.client.lua` | `StarterPlayer/StarterPlayerScripts/AudioControlClient` |
| `src/client/CameraRespawnClient.client.lua` | `StarterPlayer/StarterPlayerScripts/CameraRespawnClient` |
| `src/client/CheckpointClient.client.lua` | `StarterPlayer/StarterPlayerScripts/CheckpointClient` |
| `src/client/CoinVisibilityClient.client.lua` | `StarterPlayer/StarterPlayerScripts/CoinVisibilityClient` |
| `src/client/ObjectiveClient.client.lua` | `StarterPlayer/StarterPlayerScripts/ObjectiveClient` |
| `src/client/SoundEffectsClient.client.lua` | `StarterPlayer/StarterPlayerScripts/SoundEffectsClient` |
| `src/client/TimerClient.client.lua` | `StarterPlayer/StarterPlayerScripts/TimerClient` |
| `src/workspace/FadeScript.server.lua` | Each of `FadingPlatform01–03/FadeScript` |
| `src/workspace/FinishScript.server.lua` | `FinishPlatform/FinishScript` |
| `src/workspace/KillFloor.server.lua` | `KillFloor/killScript` |
| `src/workspace/MovingPlatformScript.server.lua` | `MovingPlatform01/MovingPlatformScript` |
| `src/workspace/RotatingBeamScript.server.lua` | `RotatingBeam/RotatingBeamScript` |

## Required Non-Script Objects

- Five `BasePart` coins inside `Workspace/Coins`
- Checkpoint `BasePart` instances inside `Workspace/Checkpoints`
- A `ParticleEmitter` named `VictoryParticles` under `FinishPlatform`
- A `BasePart` named `MovingPlatformEnd`
- The five `RemoteEvent` instances listed above
