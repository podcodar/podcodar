# Copilot Instructions for Podcodar

This is a web application written using the Phoenix web framework (Elixir).

## Project Guidelines

- Use `mix precommit` alias when you are done with all changes and fix any pending issues
- Use the already included and available `:req` (`Req`) library for HTTP requests, **avoid** `:httpoison`, `:tesla`, and `:httpc`. Req is included by default and is the preferred HTTP client for Phoenix apps
- We use [mise](https://mise.jdx.dev/) for tools and system dependencies management (see `mise.toml`)
- The system has tmux available, which can be used to run long-running commands in the background
- Use Playwright for creating temporary scripts to validate UI interfaces

### Folder Structure

```
docs/    # docs folder (PT-BR)
specs/   # spec folder (EN-US)
lib/     # elixir source code
assets/  # frontend assets (js, css, etc)
test/    # elixir tests
priv/    # private data (migrations, seeds, etc)
config/  # configuration files
scripts/ # project related scripts (deno, bash, etc)
```

### Languages

#### PT-BR (Brazilian Portuguese)
- `/docs` directory
- `README.md`
- Any text content inside code (comments, user-facing strings)

#### EN-US (English)
- `/specs` directory
- `AGENTS.md`
- All code files
- All other files

## Deployment/Runtime Notes

- Uses SQLite in all environments. In production, the DB file path is resolved via `DATABASE_PATH` and defaults to `/data/podcodar.db` on Fly.io
- `config/runtime.exs` must begin with `import Config` and uses `PHX_SERVER`, `PHX_HOST`, `PORT`, and `SECRET_KEY_BASE`
- Dockerfile is multi-stage and compiles before asset build to support phoenix-colocated hooks
- Compose runs Phoenix on port 4000; Fly maps external port to internal 4000
- Keep `fly.toml` and `Dockerfile` in sync when changing ports or envs

## Phoenix v1.8 Guidelines

- **Always** begin your LiveView templates with `<Layouts.app flash={@flash} ...>` which wraps all inner content
- The `MyAppWeb.Layouts` module is aliased in the `my_app_web.ex` file, so you can use it without needing to alias it again
- Anytime you run into errors with no `current_scope` assign:
  - You failed to follow the Authenticated Routes guidelines, or you failed to pass `current_scope` to `<Layouts.app>`
  - **Always** fix the `current_scope` error by moving your routes to the proper `live_session` and ensure you pass `current_scope` as needed
- Phoenix v1.8 moved the `<.flash_group>` component to the `Layouts` module. You are **forbidden** from calling `<.flash_group>` outside of the `layouts.ex` module
- Out of the box, `core_components.ex` imports an `<.icon name="hero-x-mark" class="w-5 h-5"/>` component for hero icons. **Always** use the `<.icon>` component for icons, **never** use `Heroicons` modules or similar
- **Always** use the imported `<.input>` component for form inputs from `core_components.ex` when available. `<.input>` is imported and using it will save steps and prevent errors
- If you override the default input classes (`<.input class="myclass px-2 py-1 rounded-lg">`) with your own values, no default classes are inherited, so your custom classes must fully style the input

## Authentication

- **Always** handle authentication flow at the router level with proper redirects
- **Always** be mindful of where to place routes. `phx.gen.auth` creates multiple router plugs and `live_session` scopes:
  - A plug `:fetch_current_scope_for_user` that is included in the default browser pipeline
  - A plug `:require_authenticated_user` that redirects to the log in page when the user is not authenticated
  - A `live_session :current_user` scope - for routes that need the current user but don't require authentication, similar to `:fetch_current_scope_for_user`
  - A `live_session :require_authenticated_user` scope - for routes that require authentication, similar to the plug with the same name
  - In both cases, a `@current_scope` is assigned to the Plug connection and LiveView socket
  - A plug `redirect_if_user_is_authenticated` that redirects to a default path in case the user is authenticated - useful for a registration page that should only be shown to unauthenticated users
- **Always let the user know in which router scopes, `live_session`, and pipeline you are placing the route, AND SAY WHY**
- `phx.gen.auth` assigns the `current_scope` assign - it **does not assign a `current_user` assign**
- Always pass the assign `current_scope` to context modules as first argument. When performing queries, use `current_scope.user` to filter the query results
- To derive/access `current_user` in templates, **always use the `@current_scope.user`**, never use **`@current_user`** in templates or LiveViews
- **Never** duplicate `live_session` names. A `live_session :current_user` can only be defined __once__ in the router, so all routes for the `live_session :current_user` must be grouped in a single block

### Routes that require authentication

LiveViews that require login should **always be placed inside the __existing__ `live_session :require_authenticated_user` block**:

```elixir
scope "/", AppWeb do
  pipe_through [:browser, :require_authenticated_user]

  live_session :require_authenticated_user,
    on_mount: [{PodcodarWeb.UserAuth, :require_authenticated}] do
    # phx.gen.auth generated routes
    live "/users/settings", UserLive.Settings, :edit
    live "/users/settings/confirm-email/:token", UserLive.Settings, :confirm_email
    # our own routes that require logged in user
    live "/", MyLiveThatRequiresAuth, :index
  end
end
```

Controller routes must be placed in a scope that sets the `:require_authenticated_user` plug:

```elixir
scope "/", AppWeb do
  pipe_through [:browser, :require_authenticated_user]

  get "/", MyControllerThatRequiresAuth, :index
end
```

### Routes that work with or without authentication

LiveViews that can work with or without authentication, **always use the __existing__ `:current_user` scope**:

```elixir
scope "/", MyAppWeb do
  pipe_through [:browser]

  live_session :current_user,
    on_mount: [{PodcodarWeb.UserAuth, :mount_current_scope}] do
    # our own routes that work with or without authentication
    live "/", PublicLive
  end
end
```

Controllers automatically have the `current_scope` available if they use the `:browser` pipeline.

## Elixir Guidelines

- Elixir lists **do not support index based access via the access syntax**. Use `Enum.at/2`, pattern matching, or `List` module functions instead
- Elixir variables are immutable, but can be rebound. For block expressions like `if`, `case`, `cond`, etc., you *must* bind the result of the expression to a variable if you want to use it
- **Never** nest multiple modules in the same file as it can cause cyclic dependencies and compilation errors
- **Never** use map access syntax (`changeset[:field]`) on structs as they do not implement the Access behaviour by default. For regular structs, you **must** access the fields directly, such as `my_struct.field`
- Elixir's standard library has everything necessary for date and time manipulation. Familiarize yourself with the common `Time`, `Date`, `DateTime`, and `Calendar` interfaces
- Don't use `String.to_atom/1` on user input (memory leak risk)
- Predicate function names should not start with `is_` and should end in a question mark
- Use `Task.async_stream(collection, callback, options)` for concurrent enumeration with back-pressure. The majority of times you will want to pass `timeout: :infinity` as option

## Mix Guidelines

- Read the docs and options before using tasks (by using `mix help task_name`)
- To debug test failures, run tests in a specific file with `mix test test/my_test.exs` or run all previously failed tests with `mix test --failed`
- `mix deps.clean --all` is **almost never needed**. **Avoid** using it unless you have good reason

## Phoenix Guidelines

- Remember Phoenix router `scope` blocks include an optional alias which is prefixed for all routes within the scope. **Always** be mindful of this when creating routes within a scope to avoid duplicate module prefixes
- You **never** need to create your own `alias` for route definitions! The `scope` provides the alias
- `Phoenix.View` no longer is needed or included with Phoenix, don't use it

## Ecto Guidelines

- **Always** preload Ecto associations in queries when they'll be accessed in templates
- Remember `import Ecto.Query` and other supporting modules when you write `seeds.exs`
- `Ecto.Schema` fields always use the `:string` type, even for `:text` columns
- `Ecto.Changeset.validate_number/3` supports the `:allow_nil` option (added in Ecto 3.11). However, by default, Ecto validations only run if a change for the given field exists and the change value is not nil, so this option is rarely needed
- You **must** use `Ecto.Changeset.get_field(changeset, :field)` to access changeset fields
- Fields which are set programmatically, such as `user_id`, must not be listed in `cast` calls or similar for security purposes. Instead they must be explicitly set when creating the struct

## Phoenix HTML Guidelines

- Phoenix templates **always** use `~H` or .html.heex files (known as HEEx), **never** use `~E`
- **Always** use the imported `Phoenix.Component.form/1` and `Phoenix.Component.inputs_for/1` function to build forms. **Never** use `Phoenix.HTML.form_for` or `Phoenix.HTML.inputs_for` as they are outdated
- When building forms **always** use the already imported `Phoenix.Component.to_form/2` (`assign(socket, form: to_form(...))` and `<.form for={@form} id="msg-form">`), then access those forms in the template via `@form[:field]`
- **Always** add unique DOM IDs to key elements (like forms, buttons, etc) when writing templates, these IDs can later be used in tests
- For "app wide" template imports, you can import/alias into the `my_app_web.ex`'s `html_helpers` block
- Elixir supports `if/else` but **does NOT support `if/else if` or `if/elsif`**. **Never use `else if` or `elseif` in Elixir**, **always** use `cond` or `case` for multiple conditionals
- HEEx require special tag annotation if you want to insert literal curly braces like `{` or `}`. Use `phx-no-curly-interpolation` attribute on the parent tag
- HEEx class attrs support lists. You must **always** use list `[...]` syntax for multiple class values
- **Never** use `<% Enum.each %>` or non-for comprehensions for generating template content, instead **always** use `<%= for item <- @collection do %>`
- HEEx HTML comments use `<%!-- comment --%>`. **Always** use the HEEx HTML comment syntax for template comments
- HEEx allows interpolation via `{...}` and `<%= ... %>`, but the `<%= %>` **only** works within tag bodies. **Always** use the `{...}` syntax for interpolation within tag attributes

## Phoenix LiveView Guidelines

- **Never** use the deprecated `live_redirect` and `live_patch` functions, instead **always** use the `<.link navigate={href}>` and `<.link patch={href}>` in templates, and `push_navigate` and `push_patch` functions in LiveViews
- **Avoid LiveComponent's** unless you have a strong, specific need for them
- LiveViews should be named like `AppWeb.WeatherLive`, with a `Live` suffix
- Remember anytime you use `phx-hook="MyHook"` and that js hook manages its own DOM, you **must** also set the `phx-update="ignore"` attribute
- **Never** write embedded `<script>` tags in HEEx. Instead always write your scripts and hooks in the `assets/js` directory and integrate them with the `assets/js/app.js` file

### LiveView Streams

- **Always** use LiveView streams for collections to avoid memory ballooning and runtime termination
- When using the `stream/3` interfaces in the LiveView, the LiveView template must 1) always set `phx-update="stream"` on the parent element, with a DOM id on the parent element like `id="messages"` and 2) consume the `@streams.stream_name` collection
- LiveView streams are *not* enumerable, so you cannot use `Enum.filter/2` or `Enum.reject/2` on them. Instead, if you want to filter, prune, or refresh a list of items on the UI, you **must refetch the data and re-stream the entire stream collection, passing reset: true**
- LiveView streams *do not support counting or empty states*. If you need to display a count, you must track it using a separate assign
- **Never** use the deprecated `phx-update="append"` or `phx-update="prepend"` for collections

### LiveView Tests

- Use `Phoenix.LiveViewTest` module and `LazyHTML` (included) for making your assertions
- Form tests are driven by `Phoenix.LiveViewTest`'s `render_submit/2` and `render_change/2` functions
- Come up with a step-by-step test plan that splits major test cases into small, isolated files
- **Always reference the key element IDs you added in the LiveView templates in your tests**
- **Never** test against raw HTML, **always** use `element/2`, `has_element/2`, and similar functions
- Focus on testing outcomes rather than implementation details

### Form Handling

- **Always** use a form assigned via `to_form/2` in the LiveView, and the `<.input>` component in the template
- In the template **always access forms** as `<.form for={@form} id="my-form">` and `<.input field={@form[:field]} type="text" />`
- You are FORBIDDEN from accessing the changeset in the template as it will cause errors
- **Never** use `<.form let={f} ...>` in the template, instead **always use `<.form for={@form} ...>`**

## Additional Resources

For more detailed guidelines, see `AGENTS.md` in the repository root.
