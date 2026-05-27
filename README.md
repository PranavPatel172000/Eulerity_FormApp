# Eulerity FormApp

A take-home project for Eulerity's iOS Developer interview.

---

## 1. Approach & Architecture

I wanted the app to work as a generic form engine — not just for this JSON but for any payload. MVVM felt like the right fit. The ViewModel handles all state and validation, views just render what they're told.

A router view reads the `type` from each field and picks the right component. Adding a new field type in future means adding one case and one component — nothing else changes.

**Swift, SwiftUI, MVVM, iOS 16, no third party libraries.**

---

## 2. Decisions I Made

**Unknown types** — anything the app doesn't recognise like `COLOR_PICKER` is silently skipped. No crash, no error screen.

**Missing order 7** — the payload has 9 fields, order 7 is missing. Since fields are always sorted by their `order` integer and never by array index, the gap is handled naturally. Drop in a new field tomorrow and it appears in the right place automatically.

**Empty dropdown** — `billing_account` has no options so validating it as required makes no sense. It shows a warning and gets skipped during validation.

**Validation timing** — errors only show on Save, not while typing. Once Save is tapped, fixing a field clears its error immediately.

**Theming** — colors are applied directly from the JSON as-is. Since the sample payload uses a dark theme with near-black backgrounds, some elements may appear low contrast but it reflects exactly what the JSON defines.

---

## 3. What I'd Improve With More Time

- Keyboard toolbar with Next and Done to cycle through fields
- Animate error messages
- More unit tests around validation edge cases

---

## 4. What I Got Stuck On

The empty dropdown was still failing validation even after I tried clearing the error in the view. Turns out the fix needed to be in `validate()` in the ViewModel, not in the component — validation was running before the view had a chance to clear anything.

---

## Running The App

1. Open in Xcode
2. Ensure `form_config.json` is under Target Membership
3. Run on iOS 16+ simulator or device
4. Fill the form and tap Save

---

## AI Collaboration

Built with Claude (claude.ai) as encouraged by the exercise.
