# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a KiCad hardware design project for the **GT232** PCB board, centered on Infineon PSoC 4000-series microcontrollers. There are two design variants sharing the same custom schematic symbol:

| Variant | Folder | MCU Symbol |
|---|---|---|
| GROSSO (large/through-hole footprint) | `GT232_CYPRESS_GROSSO/` | `CY8C4014SXA` (custom) |
| TQFP | `GT232_CYPRESS_TQFP/` | `CY8C4014SXA` (custom) |

Each KiCad project consists of:
- `.kicad_pro` — project settings and design rules
- `.kicad_sch` — schematic
- `.kicad_pcb` — PCB layout
- `CY8C4014SXA.kicad_sym` — custom local symbol (referenced via `sym-lib-table`)
- `B232.k.gerbersingolo/` — exported Gerber output

## Component Libraries

Three Infineon PSoC 4000 component packages are stored as downloaded library bundles (KiCad, Altium, EAGLE, etc.):

| Folder | Part | Package | Pins |
|---|---|---|---|
| `CY8C4014LQI-421/` | CY8C4014LQI-421 | QFN | 17 |
| `CY8C4014LQI-422/` | CY8C4014LQI-422 | QFN | 25 |
| `CY8C4024LQI-S401/` | CY8C4024LQI-S401 | QFN | 25 |

Each bundle includes `KiCad/` with `.kicad_sym`, `.lib`, `.mod`, and `.kicad_mod` files ready to import.

The datasheet for all variants is `Infineon_PSoC_4_PSoC_4000_Family_...DataSheet_v06_00_EN.pdf`.

## KiCad CLI Commands

KiCad provides a CLI for scripted operations (requires KiCad installed):

```bash
# Run Electrical Rules Check on schematic
kicad-cli sch erc --output erc_report.txt GT232_CYPRESS_TQFP/GT232_CYPRESS_TQFP.kicad_sch

# Run Design Rules Check on PCB
kicad-cli pcb drc --output drc_report.txt GT232_CYPRESS_TQFP/GT232_CYPRESS_TQFP.kicad_pcb

# Export Gerbers
kicad-cli pcb export gerbers --output GT232_CYPRESS_TQFP/B232.k.gerbersingolo/ GT232_CYPRESS_TQFP/GT232_CYPRESS_TQFP.kicad_pcb

# Export drill files
kicad-cli pcb export drill --output GT232_CYPRESS_TQFP/B232.k.gerbersingolo/ GT232_CYPRESS_TQFP/GT232_CYPRESS_TQFP.kicad_pcb

# Export BOM from schematic
kicad-cli sch export bom GT232_CYPRESS_TQFP/GT232_CYPRESS_TQFP.kicad_sch
```

## PCB Design Rules (from project settings)

Key constraints configured in both variants:
- Min track width: 0.0 mm (no global minimum; netclass default 0.2 mm)
- Min clearance: 0.127 mm
- Min copper-to-edge clearance: 0.254 mm
- Min via diameter: 0.5 mm / drill: 0.3 mm
- Min via annular width: 0.1 mm
- Min through-hole diameter: 0.3 mm
- Standard track width presets: 0.2, 0.254, 0.508 mm
- Default via: 0.6 mm diameter / 0.3 mm drill
- Teardrops enabled on PTH pads, SMD pads, and vias

## Architecture Notes

- Both KiCad projects use a **project-local custom symbol** (`CY8C4014SXA.kicad_sym`) declared in `sym-lib-table` via `${KIPRJMOD}`. This symbol is not in the global KiCad library — it must stay in the project folder.
- Gerbers were last plotted to `B232.k.gerbersingolo/` (path is stored in `.kicad_pro`). The zip archive `B232.k.gerbersingolo.zip` is the fabrication package.
- Auto-backup zips are stored in `*-backups/` folders (KiCad auto-save feature).
- The GROSSO variant has one backup; the TQFP variant has three (more actively edited).
