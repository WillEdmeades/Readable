# Readable

Readable is a small SwiftUI notes app I built around a simple idea: notes should be easier to come back to, not just easy to capture.

I wanted something calmer. Bigger type when needed, more breathing room, less visual clutter, and built-in read-aloud support for the moments when reading feels heavier than it should.

## What The App Does

- lets you create, edit, pin, and delete notes
- keeps everything on device with SwiftData
- seeds a sample note on first launch so the reading experience is easy to inspect straight away
- includes reading settings for larger text, more spacing, and reduced visual noise
- adapts the note list and note detail views for larger Dynamic Type sizes
- respects users set dynamic text size and offers increased sizes based on what they currently use
- supports read-aloud playback using `AVSpeechSynthesizer`
- includes an "Add to Note" flow for quick text, cleaned text, or simple bullet points
- includes a small Swift Testing suite around note composition and reading-style rules

## Why I Built It

This started from a very ordinary problem. I often want to jot something down quickly. I wanted to try and take some time to understand peoples accessability needs and how Apple wants developers to utilise these needs.

Readable is my attempt to make a simple notes app with direct accessability options to make note taking easier for everyone. It is still a simple notes app, but the emphasis is on coming back to notes comfortably rather than squeezing in more features.

## What This Repo Covers

- SwiftUI app structure across list, detail, editor, and settings screens
- SwiftData persistence for a small local-first notes model
- shared reading presentation driven by `@AppStorage` preferences
- accessibility-minded UI decisions around type size, spacing, and reduced visual noise
- text-to-speech integration with AVFoundation
- small, focused Swift Testing coverage around note creation, text cleanup, and reading presets
- deliberate product scoping instead of trying to turn the app into an all-purpose notes platform

## Tech Stack

- SwiftUI
- SwiftData
- AVFoundation
- AppStorage / UserDefaults
- Swift Testing
- Xcode asset catalogs and Icon Composer

## Product Scope

Readable is intentionally small.

It does not try to be:

- a team collaboration app
- a cloud-sync notes platform
- a feature-heavy document editor

That is part of the point. I wanted the idea to stay focused and the codebase to stay easy to inspect.

## Project Structure

```text
Readable/
  App/
  Models/
  Views/
    Notes/
    Settings/
  Service/
  Accessability/
  Assets.xcassets/
ReadableTests/
```

## Running The App

1. Open [Readable.xcodeproj](Readable.xcodeproj) in Xcode.
2. Select an iPhone simulator or device.
3. Build and run the `Readable` target.
4. On first launch, open the seeded sample note to inspect the reading layout and settings.