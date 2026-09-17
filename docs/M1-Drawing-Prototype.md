# M1 — Drawing Prototype

This is the first playable Inkbound slice. It intentionally proves only the
drawing interaction described in the design docs:

- press `E` to enter drawing mode
- hold left mouse button or touch to draw
- see the stroke rendered as thick ink segments
- capture stroke points in a separable shared `Stroke` module
- release to finish the stroke; it cleans itself up after four seconds
- press `R` to clear the current prototype canvas

## Running it in Roblox Studio

The project is structured for [Rojo](https://rojo.space/). Sync the project
using `default.project.json`, then press Play in Studio. The prototype uses
only a `StarterPlayerScripts` LocalScript and a shared `ReplicatedStorage`
ModuleScript, so it can also be copied into a blank place manually:

1. Create `ReplicatedStorage/Inkbound` and add `Stroke.lua` as a ModuleScript.
2. Create a LocalScript named `InkboundDrawing` inside
   `StarterPlayer/StarterPlayerScripts` and paste in the contents of
   `InkboundDrawing.client.lua`.
3. Press Play and use the on-screen controls.

Shape recognition, world effects, creatures, persistence, and progression are
deliberately out of scope for M1.
