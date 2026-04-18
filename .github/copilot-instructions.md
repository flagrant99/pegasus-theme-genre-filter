# Copilot instructions for pegasus-theme-genre-filter

Purpose: QML theme for Pegasus frontend that adds a Genre Filter to the Grid theme. This file gives Copilot quick context for automation, editing, and searches.

1) Build / test / lint
- No build, test, or lint toolchain in this repository (QML theme).
- Preview / install: copy the repository folder into your Pegasus themes directory and select the theme in Pegasus settings; Pegasus will load theme.qml as the entrypoint.
- Single-check quick validation: open theme.qml in a QML-aware editor (Qt Creator) to catch syntax errors.

2) High-level architecture
- Entrypoint: theme.qml — FocusScope that composes the UI and wires models/events.
- Metadata: theme.cfg contains theme metadata (name, author, screenshots referenced under assets/.meta/).
- Layers (subfolders):
  - layer_filter/: FilterLayer and FilterPanel — genre selector and filtering logic/UI.
  - layer_grid/: GameGrid, GameGridItem, BackgroundImage, FavoriteHeart — main grid and items.
  - layer_gameinfo/: GamePreview, PanelLeft/PanelRight, GamePanelButton — details/preview panel.
  - layer_platform/: PlatformBar, PlatformCard — topbar platform/collection selector.
- Assets: assets/ contains icons, logos, and screenshots used by the theme.
- folders.js: small helper used by the theme to populate folder/genre data.

3) Key conventions and repo-specific patterns
- API usage: code heavily relies on the Pegasus runtime API (api.collections, api.memory, api.keys, etc.). Search for api.* when tracing behavior.
- Memory keys used across files:
  - 'collection' — last selected collection stored via api.memory.set('collection', ...)
  - 'game' — last selected game stored via api.memory.set('game', ...)
  - 'genrefilter.fontsize' — font size override for genre filter (see README and theme_settings JSON reference)
- Genre metadata format: metadata.pegasus.txt must include a "genre: Parent/Child" string (slashes or backslashes allowed). Games without a genre fall under "ALL".
- Filtering: a SortFilterProxyModel (RegExpFilter) is used in theme.qml to filter by roleName: "genre" and pattern: filter.withFolder. This is the core of the Genre Filter mechanic.
- Visual scaling: code uses vpx(...) for pixel-scaling; preserve scaling arithmetic when changing layouts.
- Asset naming: platform logos live at assets/logos/<system>.svg — consistent names expected by PlatformBar.
- UI sizing: FilterLayer exposes gf_fontsize and gf_fontsizeSel (selected font is typically double unselected size).
- Minimal settings exposure: theme_settings/pegasus-theme-genre-filter.json may be used to expose settings (README shows {"genrefilter.fontsize":32}).

4) Files and entrypoints Copilot should prioritize when making changes or analyses
- theme.qml (entrypoint)
- theme.cfg (metadata)
- layer_filter/FilterLayer.qml
- layer_grid/GameGrid.qml and GameGridItem.qml
- layer_gameinfo/GamePreview.qml
- layer_platform/PlatformBar.qml
- folders.js

5) Existing AI assistant configs
- No CLAUDE.md, .cursorrules, AGENTS.md, .windsurfrules, CONVENTIONS.md, AIDER_CONVENTIONS.md, or .clinerules were found in the repo root. If such files are added later, merge relevant guidance into this instructions file.

---

Summary: created .github/copilot-instructions.md summarizing preview steps, architecture, and repository conventions to help future Copilot sessions. Update this file if new automation, tests, or AI configs are added.
