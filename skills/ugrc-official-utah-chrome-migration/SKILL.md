---
name: ugrc-official-utah-chrome-migration
description: Use this skill to migrate your project to the official Utah header/footer package with waffle links, external logo asset, and correct viewport/footer scroll behavior.
---

Replace app chrome with the official Utah Design System header/footer while preserving existing map UI behavior.

Requirements:

1. Use `@utahdts/utah-design-system-header` (NPM/Vite integration), not CDN script tags.
2. Import `@utahdts/utah-design-system-header/css` once at app startup.
3. Add `declare module '@utahdts/utah-design-system-header/css';` to an existing generic type file to satisfy TypeScript.
4. Configure chrome through `setUtahHeaderSettings()` in a dedicated adapter component (for example `UtahChrome`).
5. Render stable DOM targets for both header and footer via `domLocationTarget.cssSelector`.
6. Footer settings must explicitly disable the separator line:

- `showHorizontalRule: false`

7. Example header settings:

- `applicationType: 'custom application'`
- `title: 'Project Name'`
- `titleUrl: '/'`
- `skipLinkUrl: '#main-content'`
- `showTitle: true`
- `size: 'MEDIUM'`
- `mainMenu: false`
- `utahId: false`
- `notifications: false`
- `onSearch: false`

8. Move any existing top links into a single header action item popup menu and use the waffle icon trigger:

- Icon HTML: `<span class="utds-icon-before-waffle" aria-hidden="true" />`

9. Keep `SocialMedia` unchanged and in its current location if it exists. It is explicitly out of scope.
10. Preserve the existing branding by providing logo via official header `logo` setting using a separate SVG file, not a large inline string.

- Store logo as `public/logo.svg`
- Set `logo.imageUrl = '/logo.svg'`

11. Replace old UGRC `Header` and `Footer` component usage with the new official chrome adapter.

Possible layout fixes. If the existing app is a full-screen map, the new header/footer may push the map content and cause overflow/scroll issues. Ensure the following layout requirements are met:

- Header plus main content must fill exactly one viewport.
- Footer must be below that viewport and only appear when the user scrolls.
- Implement this by rendering a top wrapper with `h-screen` for header+main, and rendering footer target after that wrapper.
- Ensure map area remains usable with `main` as a flex child (`min-h-0`/`flex-1` pattern) and no footer overlap.

Lessons learned / pitfalls to avoid:

- If `logo` is omitted, no agency mark appears in the official header.
- Keeping logo as a giant inline SVG string works but is harder to maintain; use a standalone `public` asset.
- Small SVGs imported from `src` may be inlined by Vite; using `public/logo.svg` guarantees a separate served file.
- Putting footer in the same `min-h-screen` flex column as header/main can make it visible in the initial viewport; keep footer outside the viewport-height wrapper.

Validation checklist:

1. Manual verify in dev server:

- Official header renders with the app's original logo and title
- Waffle action menu contains all links
- Footer is positioned correctly and only appears after scrolling
- Map area remains usable and is not overlapped by the footer
