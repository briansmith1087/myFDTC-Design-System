# myFDTC Design System (CSS)

Small, versioned CSS design system for FDTC Ellucian Experience cards. Distributed via jsDelivr from this GitHub repo.

---

## CDN

Use one of these URLs:

**Pinned to a release tag (recommended)**
```
https://cdn.jsdelivr.net/gh/briansmith1087/myFDTC-Design-System@v0.1.0/dist/fdtc.css
```

**Pinned to a specific commit (immutable)**
```
https://cdn.jsdelivr.net/gh/briansmith1087/myFDTC-Design-System@<commit-sha>/dist/fdtc.css
```

**Main branch (testing only)**
```
https://cdn.jsdelivr.net/gh/briansmith1087/myFDTC-Design-System@main/dist/fdtc.css
```

---

## Usage in an Experience card

Load once per card at runtime:

```jsx
import { useEffect } from 'react';

export function useFdtcCss() {
    useEffect(() => {
        const id = 'fdtc-ds';
        if (document.getElementById(id)) return;

        const link = document.createElement('link');
        link.id = id;
        link.rel = 'stylesheet';
        link.href = 'https://cdn.jsdelivr.net/gh/briansmith1087/myFDTC-Design-System@v0.1.0/dist/fdtc.css';
        document.head.appendChild(link);
    }, []);
}
```

Example markup:

```jsx
<div className="fdtc-card">
    <div className="fdtc-card__header">
        <div className="fdtc-card__title">FDTC Styles Loaded</div>
        <button className="fdtc-btn fdtc-btn--sm">Help</button>
    </div>
    <div className="fdtc-card__body">
        <div className="u-surface">Surface block</div>
    </div>
    <div className="fdtc-card__footer">
        <button className="fdtc-btn fdtc-btn--accent">Advisors</button>
        <button className="fdtc-btn">Degree Progress</button>
    </div>
</div>
```

---

## Local development

This repo uses a simple PowerShell script (no PostCSS). It resolves `@import` in `src/index.css` and writes `dist/fdtc.css`.

Build:
```powershell
.\scriptsuild-css.ps1
```

Commit the result:
```powershell
git add dist\fdtc.css
git commit -m "build: update dist/fdtc.css"
```

Tag and push a release:
```powershell
git tag v0.1.0
git push origin main --tags
```

---

## Repository structure

```
src/
  tokens.css
  base.css
  utilities.css
  components/
    button.css
    card.css
  index.css           # imports the files above
dist/
  fdtc.css            # generated bundle (committed for CDN)
scripts/
  build-css.ps1       # concatenates imports into dist/fdtc.css
```

---

## Versioning & releases

- Pin consumers to an exact tag (e.g., `@v0.1.0`) for reproducible builds.
- Bump the tag whenever tokens or component styles change in a way that could affect cards.
- Avoid reusing tags. If you must, purge jsDelivr; pinning new tags is preferred.

---

## Changelog

### [Unreleased]
- (add notes for changes since the last tag)

### v0.1.0 — 2025-11-07
- Initial public bundle: `dist/fdtc.css`
- Base tokens (colors, spacing, radii, typography)
- Base layer (`base.css`) and utilities (`utilities.css`)
- Components: `button.css`, `card.css`
- Build script: `scripts/build-css.ps1`

---

## Notes

- Line endings: LF enforced via `.gitattributes`.
- Fonts: If you reference web fonts, prefer CDN-based `@import` or host assets in this repo so jsDelivr can serve them.
