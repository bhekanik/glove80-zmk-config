# Portable hybrid keymap design

This documents the thinking behind the current Glove80 keymap. The goal is a layout that feels native on the Glove80, but still ports cleanly to a 46-key Moonlander or Corne-style board.

## Goals

- Keep the main 46-key core complete. Extra Glove80 keys may duplicate, speed up, or expose hardware controls, but should not be required for normal typing, coding, or navigation.
- Preserve learned high-value habits: Backspace left of `A`, thumb `Space`, thumb `Enter`, one-handed HJKL arrows, and index-finger shifts on the extra keys below `V` and `M`.
- Remove writer-hostile surprises from alpha keys. Plain letters should stay letters unless there is a proven benefit and low misfire risk.
- Put coding symbols in predictable pairs and make editing commands live behind the Nav layer rather than accidental same-layer combos.
- Keep hardware and rescue controls available, but out of the normal typing path.

## Physical vocabulary

Viewed from above while typing:

```text
left half                                               right half

outer edge                  center gap                  center gap                  outer edge
L_C6 ... L_C1        L_T4 L_T5 L_T6          R_T6 R_T5 R_T4        R_C1 ... R_C6
```

The most important non-alpha keys in this map:

```text
left lower extras and thumbs

below C        below V        L_T4          L_T5          L_T6
one-shot Nav   Left Shift     Enter/Nav     unused        Cmd+Shift

right thumbs and lower extras

R_T6          R_T5              R_T4          below M       below ,       below .    below /
Cmd+Shift     Symbols tap/hold  Space/Nav     Right Shift   Symbols lock  -          +
```

Avoid interpreting these as "near" or "far"; use the Glove80 labels above.

## Default layer

Conceptual 46-key core:

```text
`  1  2  3  4  5        6  7  8  9  0  =
Esc Q  W  E  R  T        Y  U  I  O  P  \
Bsp A  S  D  F  G        H  J  K  L  ;  '
Tab Z  X  C  V  B        N  M  ,  .  /  _

S/F/J/L keep existing home-row mods.
Z and / keep Ctrl holds.
G and H are plain letters again.
```

Thumbs and extras:

```text
left:  one-shot Nav below C, Left Shift below V, Enter/Nav on L_T4
right: Symbols tap/hold on R_T5, Space/Nav on R_T4,
       Right Shift below M, Symbols lock below comma
```

Backspace stays left of `A`. Holding Shift while pressing Backspace sends Delete, and this now works with either Shift side.

## Combos

```text
S + D      sticky Left Shift
K + L      sticky Right Shift
D + F      Hyper, tap for sticky / hold for held
J + K      Hyper, tap for sticky / hold for held
, + .      hyphen
```

Why Hyper moved:

- Hyper on `G/H` caused occasional real misfires.
- Hyper on Backspace would overload a destructive key and disturb a habit that already works.
- Same-hand combos keep Hyper available without requiring both hands and without putting it on a plain alpha hold.
- `D+F` and `J+K` are close to the shift combos but one key inward, so the mental model stays consistent.

The Hyper combos are intentionally conservative:

```text
timeout-ms = 30
require-prior-idle-ms = 120
slow-release
```

If Hyper is too hard to hit, raise timeout to 35 or 40. If it misfires, raise prior idle to 150 before changing the combo.

## Nav layer

Nav is for one-handed movement and common editor actions.

```text
Hold Space/Nav or Enter/Nav:

A        Caps Word
F        macOS screenshot area
H J K L  Left Down Up Right
Z X C V  Cmd+Z Cmd+X Cmd+C Cmd+V
N M , .  Home PgDn PgUp End
U I O P  app/tab navigation
```

One-shot Nav exists below `C`. It is mainly useful for one-shot commands like copy, paste, cut, undo, Caps Word, and screenshot. It is less useful for repeated movement, so Space/Nav and Enter/Nav remain the main movement entry points.

## Symbols layer

Symbols is for numbers and coding punctuation.

```text
top alpha row:     !  @  #  $  %        ^  &  *  (  )
home alpha row:    1  2  3  4  5        6  7  8  9  0
lower alpha row:   ~  `  [  {  (        )  }  ]  -  =
```

The bracket cluster moved away from the awkward `./` claw. It now keeps pairs visible:

```text
[  {  (        )  }  ]
```

R_T5 is Symbols tap/hold:

- tap: one-shot Symbols
- hold: momentary Symbols

The key below comma is a persistent Symbols lock. Press it again on the Symbols layer to return to Default.

## Magic and Factory Test

Magic stays low-left and is hardware-only:

- Bluetooth profile controls
- output selection
- RGB controls
- bootloader and reset
- Factory Test entry

Factory Test is still present, but now has an explicit return to Default. It is no longer a one-way trap during normal experimentation.

## Porting rule

When porting to Moonlander or Corne:

1. Preserve the 46-key core first.
2. Preserve thumb `Space/Nav`, thumb `Enter/Nav`, and Symbols access.
3. Preserve HJKL arrows on Nav.
4. Preserve Backspace left of `A`.
5. Preserve same-hand Shift and Hyper combos as the fallback for boards without the Glove80 extra below-column keys.
6. Treat below `C`, below `V`, below `M`, below comma, media keys, brightness keys, Magic, and hardware controls as extras.

This keeps the layout transferable: the Glove80 gets more comfort keys, but the Corne does not lose essential behavior.

## Rejected changes

- Backspace on thumb: not worth spending a primary thumb key, and the left-of-`A` habit already works.
- Hyper on Backspace: less risky than `G/H`, but still overloads a destructive key and adds cognitive friction.
- Required two-hand arrows: conflicts with the split-keyboard workflow and one-handed navigation habit.
- Alpha-key layer holds on `A`, quote, `G`, or `H`: too much misfire risk for normal typing and prose.
- Editing combos on the default layer: convenient in theory, but too easy to trigger while writing. Editing now lives on Nav.
- Shift+Enter for Caps Word: clever, but it overloads Enter. Nav+A is clearer.

## Validation

Built successfully with:

```sh
./build.sh v25.11
```

The generated firmware was `glove80.uf2`.

The build is pinned to MoErgo ZMK `v25.11` in:

- `.github/workflows/build.yml`
- `Dockerfile`
- `build.sh`

`config/keymap.json` was removed because it was stale and not part of the firmware build.

## Tuning watchlist

- Hyper combos: adjust only after real use. First try `timeout-ms`, then `require-prior-idle-ms`.
- Home-row mods: existing timings remain mostly unchanged. If prose typing rolls feel sticky, tune the specific finger behavior rather than removing all home-row mods.
- Symbols: bracket placement should be judged by real coding sessions, especially TypeScript, shell, Markdown, and JSON.
- Nav one-shot: keep only if it earns its place for commands like copy, paste, undo, Caps Word, and screenshot.
