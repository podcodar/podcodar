# Feature: Implement Discord redirect (/discord)

> [!WARNING]
> **REQUIRED**: If you are an LLM model, read the Agent instructions at [AGENTS.md](../AGENTS.md)

## Description

We need to implement a Discord Redirect using the route `/discord`.

This will redirect to the same link we use on the NavBar, inside the app layout. This link will be a configuration pointing to the "DISCORD_INVITE_URL" that will contain the invite link to our Discord server.

## Tech Stack

- GitHub Actions for CI workflows
- Elixir and Phoenix Framework
- SQLite3 for database testing
- TailwindCSS and DaisyUI for frontend linting (if applicable)

## Definition of Work

1. create configs for :podcodar, discord_invite_url pointing to the  environment variable "DISCORD_INVITE_URL"
2. create a new route in the router.ex file for "/discord" that points to a new controller action
3. create tests for the new route and controller action

## Definition of Done

- Route is implemented and tested

