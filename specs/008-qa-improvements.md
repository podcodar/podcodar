## QA-driven UX and Performance Improvements

### Context

Exploratory QA on `podcodar.fly.dev` identified low-risk, high-value improvements across copy, 404 UX, external link behavior, performance on the Courses page, and responsiveness.

### In Scope

- Copy corrections (PT-BR) on public pages:
  - "acessível há todos" → "acessível a todos"
  - "gratúito" → "gratuito"
  - "O essential do Spring" → "O essencial do Spring"
- 404 UX: render a branded 404 page using `Layouts.app` with a clear message and a CTA back to Home.
- External links behavior: open in new tab with `target="_blank"` and `rel="noopener"` for Discord, GitHub, Transparência (and other external anchors).
- Courses page performance:
  - Prefer click-to-play thumbnails over immediately embedding YouTube iframes, or at minimum add `loading="lazy"` to iframes.
  - Keep visual parity (titles, tags, flags), but defer heavy player scripts until interaction.
- Mobile responsiveness: verify and adjust grid/spacing on Courses and Home for ~375px width (no overflow; readable spacing).

### Out of Scope

- Sponsor link/page changes. A dedicated internal Sponsor page will be handled in a future spec.

### Goals

- Improve first paint and reduce third-party requests on Courses by deferring YouTube player loads.
- Fix visible copy errors to increase trust and clarity.
- Provide a consistent, branded 404 experience that keeps users in flow.
- Ensure external links behave as expected and safely.
- Preserve clean mobile experience.

### Acceptance Criteria

- Copy
  - The three occurrences above are corrected everywhere they appear on the site.
- 404 Page
  - Visiting a non-existent route returns HTTP 404 and renders a page wrapped by `<Layouts.app flash={@flash} current_scope={@current_scope}>`.
  - Page includes a friendly message (PT-BR), a visible link/button to return to `/`, and retains site branding.
- External Links
  - Links to Discord, GitHub, Transparência (and any other external URLs) include `target="_blank"` and `rel="noopener"`.
- Courses Performance
  - On initial load of `/courses`, YouTube iframe requests are not issued until the user interacts (click-to-play), OR if using iframes initially, each iframe includes `loading="lazy"`.
  - Visual regressions are avoided; course cards still show preview images/titles/tags.
- Mobile
  - At 375×720 viewport, Home and Courses content stack without horizontal scroll. Spacing is readable; iframe/thumbnails scale to width.

### Implementation Notes

- Phoenix v1.8 templates
  - Always start LiveView templates with `<Layouts.app flash={@flash} current_scope={@current_scope}>`.
  - If a `phx-hook` is used for click-to-play behavior that manages its own DOM, set `phx-update="ignore"` on the root element rendered by the hook.
- 404
  - Implement a 404 rendering that uses the app layout. Options:
    - Route fallback to a LiveView/component that renders the 404 within `Layouts.app`.
    - Or customize the error HTML rendering to ensure layout usage.
- Courses click-to-play (preferred)
  - Render a thumbnail: `https://i.ytimg.com/vi/<VIDEO_ID>/sddefault.jpg` with a play overlay.
  - On click, replace thumbnail with the YouTube iframe (embed URL), minimizing initial third-party requests.
  - If not implementing click-to-play now, add `loading="lazy"` to existing iframes as a minimal improvement.
- External links
  - Audit visible external anchors on Home and Courses; add `target="_blank" rel="noopener"`.
- Copy fixes
  - Update strings in the HEEx templates and any server-rendered text.

### Test Plan (manual QA)

- Home
  - Confirm corrected PT-BR copy and external links behavior.
  - Resize to 375px width; verify layout integrity and no horizontal scroll.
- Courses
  - Initial load: verify no immediate `youtube` player script requests if click-to-play is implemented; otherwise ensure `loading="lazy"` on iframes.
  - Filter by query via UI and URL (`/courses?query=elixir`) still works.
  - Mobile width: cards/thumbnails scale; spacing remains readable.
- 404
  - Navigate to a non-existent route (e.g., `/__qa_not_found__`); confirm HTTP 404, branding via `Layouts.app`, and a visible CTA back to Home.

### Risks / Considerations

- Click-to-play requires small JS or LiveView state; ensure it doesn’t conflict with LiveView updates. If a JS hook manipulates DOM, set `phx-update="ignore"`.
- YouTube thumbnail legality: i.ytimg.com thumbnails are the standard approach for previews; ensure correct VIDEO_ID extraction.
- Be mindful of the `current_scope` assign when adding new templates/LiveViews.
