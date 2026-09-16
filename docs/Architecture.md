# INKBOUND — ARCHITECTURE

This document records finalized technical architecture.

Do not treat speculative ideas as finalized architecture.

## Current Principle

Keep the first prototype extremely small.

The drawing system should be separable from future shape recognition and gameplay effects.

## Planned Layers

Client:
- player input
- drawing interaction
- visual stroke presentation

Shared:
- stroke data structures
- future shape recognition

Server:
- authoritative gameplay effects created from recognized drawings

## Important

Do not implement future layers merely because they are planned.

Build only what the current task requires.
