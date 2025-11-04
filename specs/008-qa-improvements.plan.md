# Implementation Plan: QA-driven UX and Performance Improvements

## Overview
This plan details the implementation steps for the improvements specified in
`specs/008-qa-improvements.md`. The scope includes PT-BR copy corrections,
branded 404 page, external links behavior, performance improvements on the
Courses page, and mobile responsiveness validation. Sponsor page/link changes
are explicitly out of scope.

## Guiding Principles
- Adhere to Phoenix v1.8 guidelines (layout usage, routing scopes, LiveView
  behaviors) as defined in `AGENTS.md`.
- Follow markdownlint rules for any Markdown changes.
- Keep changes minimal and incremental; prefer small PRs per area below.

## Phase 1 — Copy Corrections (PT-BR)

### Tasks
- [ ] Find and correct PT-BR strings:
  - [ ] "acessível há todos" → "acessível a todos"
  - [ ] "gratúito" → "gratuito"
  - [ ] "O essential do Spring" → "O essencial do Spring"

### Files to Review/Modify (expected)
- [ ] `lib/podcodar_web/*/*.heex` and/or LiveView templates rendering these
  strings (home and courses pages). Use semantic search to locate occurrences.

### Acceptance
- [ ] All occurrences corrected on pages where the text appears.

## Phase 2 — 404 UX (Branded Not Found)

### Tasks
- [ ] Implement a branded 404 page that renders within
  `<Layouts.app flash={@flash} current_scope={@current_scope}>`.
- [ ] Add a friendly message (PT-BR) and a CTA link/button to navigate back to
  `/`.
- [ ] Ensure HTTP 404 status is preserved.

### Implementation Notes
- Prefer a LiveView or function component used by the error view to ensure the
  layout is applied. Keep the logic consistent with Phoenix v1.8 error handling.

### Files to Review/Modify (likely)
- [ ] `lib/podcodar_web/*/error_html.ex` or LiveView-based error rendering
  pipeline.
- [ ] A small LiveView or component for the 404 content if needed.

### Acceptance
- [ ] Visiting a non-existent route returns 404 and shows the branded page with
  CTA back to `/`.

## Phase 3 — External Links Behavior

### Tasks
- [ ] Add `target="_blank"` and `rel="noopener"` to external links:
  - [ ] Discord
  - [ ] GitHub
  - [ ] Transparência
  - [ ] Any other external anchors found on Home/Courses

### Files to Review/Modify (expected)
- [ ] Home and Courses templates where external links are rendered.

### Acceptance
- [ ] External links open in a new tab and include `rel="noopener"`.

## Phase 4 — Courses Performance Improvements

### Option A (Preferred): Click-to-Play Thumbnails

#### Tasks
- [ ] Render YouTube thumbnails (e.g., `https://i.ytimg.com/vi/<VIDEO_ID>/sddefault.jpg`).
- [ ] On click, replace the thumbnail with the YouTube iframe (embed URL).
- [ ] Ensure any JS/Hook manipulating DOM uses `phx-update="ignore"` if needed.

#### Files to Review/Modify (likely)
- [ ] LiveView/template for `/courses` list rendering.
- [ ] Optional: small JS hook in `assets/js` and imported in `assets/js/app.js`.

#### Acceptance
- [ ] Initial load of `/courses` does not issue YouTube player requests until
  user interaction.
- [ ] Visual parity is preserved (title, tags, flags visible before click).

### Option B (Minimal): Lazy-load iframes

#### Tasks
- [ ] Add `loading="lazy"` attribute to each YouTube iframe.

#### Acceptance
- [ ] Iframes are lazily loaded by the browser; visual regressions are avoided.

## Phase 5 — Mobile Responsiveness (375×720 check)

### Tasks
- [ ] Validate Home and Courses at ~375px width (no horizontal scroll).
- [ ] Adjust grid and spacing if necessary (stacking, padding, margins).
- [ ] Ensure thumbnails/iframes scale to container width.

### Files to Review/Modify (likely)
- [ ] HEEx templates for Home and Courses.
- [ ] CSS utility classes in existing templates; avoid broad CSS changes.

### Acceptance
- [ ] Layouts remain readable and usable on small screens without horizontal
  scrolling.

## Out of Scope
- Sponsor page or link changes. A dedicated internal Sponsor page will be
  handled in a separate spec.

## Testing Plan
- Manual QA (Desktop and Mobile emulation):
  - [ ] Home: verify PT-BR corrections; external links behavior.
  - [ ] Courses: verify click-to-play (or `loading="lazy"`), no unexpected
    console errors, filters via UI and URL still work.
  - [ ] 404: navigate to a non-existent route; verify 404 status, layout,
    branding, and CTA.
- Optional: add basic LiveView tests for the 404 component/view and for presence
  of `target`/`rel` attributes on external links.

## Risks & Mitigations
- Click-to-play DOM management conflicting with LiveView updates:
  - Use a JS hook with `phx-update="ignore"` on the container.
- Thumbnail generation requires correct `VIDEO_ID` extraction:
  - Centralize helper that derives `VIDEO_ID` from the stored embed URL.
- 404 rendering path varies per Phoenix setup:
  - Keep changes minimal and follow Phoenix v1.8 recommended error handling.

## Deliverables
- PR 1: Copy fixes (PT-BR) + external links behavior.
- PR 2: 404 branded page.
- PR 3: Courses performance (Option A or Option B) + mobile tweaks.

## Definition of Done
- [ ] All acceptance criteria in `specs/008-qa-improvements.md` satisfied.
- [ ] No regressions on Home/Courses; navigation and filters work.
- [ ] `mix precommit` passes; CI green.
- [ ] Markdown changes conform to markdownlint.


