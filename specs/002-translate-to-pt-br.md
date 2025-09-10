# Feature: Translate to Portuguese (pt-br)

## Description

The goal of this task is to translate the home page of the PodCodar application to Portuguese (pt-br) to better serve our Brazilian audience.

PodCodar targets individuals in Brazil who are looking to start or transition into a career in the technology sector. The platform features Amazon mentors as a key part of its offering.

## Tech Stack

- Backend: Phoenix Framework with LiveView (refer to the `AGENTS.md` file for more details)
- UI: DaisyUI and TailwindCSS
- Database: Ecto with SQLite3
- More info at [AGENTS.md][../AGENTS.md]

## Definition of Work

1. Translate all texts on the home page into Portuguese (pt-br).
2. Replace all instances of "TechSchool" with "PodCodar".
3. Review and update:
   - Images and links to ensure they are relevant and correct.
   - Form placeholders and image `alt` texts to match the Portuguese translation.
   - SEO tags (e.g., meta descriptions, keywords) to align with the Portuguese content.
4. Remove the `/en` segment from any internal links.

## Guidelines

- **Do not modify**:
  - Code-related names, structures, or logic.
  - External links or references to other websites.

## Definition of Done

- The translated home page is accessible and functioning correctly at the `/` route.
- Automated tests have been created and successfully pass for the updated page.

