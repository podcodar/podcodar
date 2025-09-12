# Feature: Implement Search 

## Description

We need to implement an advanced search to provide intelligent and meaningful courses from a JSON file hosted at `https://github.com/podcodar/webapp/blob/main/priv/repo/data/courses.json`. The JSON file adheres to the schema defined in `scripts/validate.ts`.

Key considerations:
- The JSON file will be updated manually, so an automated update mechanism is unnecessary.
- All changes to the JSON file should be reviewed and validated by a human before being committed.
- Base the feature on the structure and ideas presented on the page https://techschool.dev/en/courses.
- Pagination is not required for this first version
- You have to create the courses.json file, if it doesn't exist yet.
- The page uses `pt-br` as the default language for texts.

## Tech Stack

- Backend: Phoenix Framework with LiveView (refer to the `AGENTS.md` file for more details)
- UI: DaisyUI and TailwindCSS
- Database: Ecto with SQLite3
- Deno for `scripts` (latest version is 2.5.0)
- More info at [AGENTS.md](../AGENTS.md)

## Definition of Work

1. Groundwork
    - Create the file `priv/repo/data/courses.json` and populate it with the data from the provided URL.
    - Ensure the `scripts/validate.ts` script is functional and correctly validates the JSON file.
    - GitHub Actions: implement a GitHub Action to run the `scripts/validate.ts` script on every pull request and push to the `main` branch to ensure the JSON file adheres to the defined schema.
2. Create a search page that:
   - Fetches and parses the JSON data from the provided URL.
   - Includes dynamic filters for categories, difficulty levels, and other relevant attributes.
   - Supports pagination for better user navigation.
   - Integrate the home page (search) with the courses results page.
3. Ensure the search page is responsive and visually appealing using DaisyUI and TailwindCSS.
5. Write automated tests to verify the functionality of the search feature, including edge cases, error handling, and accuracy of results.
6. Document the implementation details and usage instructions for future reference.

## Definition of Done

- The search feature is fully functional and integrated into the application.
- Accessible at the `/courses` route.
- All tests are created and passing.
- The JSON validation GitHub Action is set up and functioning correctly.
- Documentation is complete, reviewed, and includes instructions for maintaining and improving the AI model.

