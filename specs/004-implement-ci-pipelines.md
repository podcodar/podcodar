# Feature: Implement CI Pipelines for GitHub Actions

## Description

We need to set up Continuous Integration (CI) pipelines using GitHub Actions to ensure code quality, consistency, and reliability. The pipelines should focus primarily on linting and testing processes to enforce best practices and maintain a high-quality codebase. Additionally, the CI pipelines should include a quality gateway pipeline to prevent substandard code from being merged into the `main` branch.

Key considerations:
- The pipelines should be configured to run automatically on every pull request and push to the `main` branch.
- Ensure compatibility with the existing tech stack and tools.
- Include clear error messages and debugging information for any failing steps to assist developers in resolving issues quickly.
- Utilize existing tools and configurations wherever possible to minimize redundant work.

## Tech Stack

- GitHub Actions for CI workflows
- Elixir and Phoenix Framework
- SQLite3 for database testing
- Deno (latest version is 2.5.0) for script validation
- TailwindCSS and DaisyUI for frontend linting (if applicable)
- More info at [AGENTS.md](../AGENTS.md)

## Definition of Work

1. **Pipeline Setup**
   - Create a GitHub Actions workflow file named `.github/workflows/ci.yml`.
   - Configure the CI pipeline to include the following steps:
     - **Setup**: Install Elixir, SQLite3, Node.js, and Deno.
     - **Linting**: Run code linters for both backend (Elixir) and frontend (if applicable).
     - **Testing**: Execute all backend tests using the existing test suite.
     - **Quality Gateway**: Add a step to ensure all linting and testing steps pass before allowing code to be merged into the `main` branch.
   - Ensure that the pipelines are triggered on every pull request and push to the `main` branch.
2. **Deno Scripts Validation**
   - Add a separate step in the pipeline to validate scripts using Deno (e.g., `scripts/validate.ts`).
   - Ensure that the validation step checks the integrity and correctness of critical files, such as `courses.json`.
3. **Parallelization and Optimization**
   - Optimize the pipeline by running linting and testing steps in parallel to reduce execution time.
   - Cache dependencies (e.g., Elixir, Node.js, and Deno packages) to further improve the pipeline's efficiency.
4. **Error Reporting**
   - Ensure that failing steps provide detailed error messages and logs to assist developers in identifying and resolving issues.
   - Include links to relevant documentation or guidelines in the output.
5. **Documentation**
   - Document the CI pipeline workflow in the `README.md` file or a dedicated `docs/ci_pipelines.md` file.
   - Provide instructions for running the linting and testing steps locally to ensure consistency between local development and the CI pipeline.

## Definition of Done

- The CI pipelines are configured and functional.
- The `.github/workflows/ci.yml` file is created, committed, and successfully integrated into the repository.
- All steps (setup, linting, testing, and quality gateway) are implemented and pass successfully on every pull request and push to the `main` branch.
- The CI pipelines are optimized for execution time and reliability.
- Clear and detailed documentation is provided for the CI pipeline setup and usage.

