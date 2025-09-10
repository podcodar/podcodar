defmodule PodcodarWeb.PageLive do
  use PodcodarWeb, :live_view
  alias Podcodar.SearchQuery
  require Logger

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <section class="text-center min-h-svh flex flex-col justify-center items-center gap-12 mt-[-6rem] bg-pattern p-6">
        <div class="gap-4">
          <h1 class="text-5xl font-bold">Free technology education for everyone</h1>
          <h2 class="text-2xl">Go from zero to your first job without any financial loss</h2>
        </div>

        <div class="min-w-full md:min-w-3xl">
          <.form for={@form} id="home-search-form" phx-change="validate" phx-submit="search">
            <.input
              field={@form[:query]}
              type="search"
              placeholder="Search courses, topics..."
              autocomplete="off"
              autofocus
            />

            <.link navigation={~p"/#"} class="btn btn-ghost">I'm Feeling Lucky </.link>
            <.button type="submit">Search</.button>
          </.form>
        </div>

        <div class="flex flex-wrap justify-center gap-4 max-w-full md:max-w-2xl">
          <a href="/en/courses?language=golang" class="btn btn-sm btn-dash btn-accent">Go</a>
          <a href="/en/courses?language=elixir" class="btn btn-sm btn-dash btn-accent">Elixir</a>
          <a href="/en/courses?language=python" class="btn btn-sm btn-dash btn-accent">Python</a>
          <a href="/en/courses?language=ruby" class="btn btn-sm btn-dash btn-accent">Ruby</a>
          <a href="/en/courses?framework=react.js" class="btn btn-sm btn-dash btn-accent">React</a>
          <a href="/en/courses?framework=node.js" class="btn btn-sm btn-dash btn-accent">Node</a>
          <a href="/en/courses?framework=laravel" class="btn btn-sm btn-dash btn-accent">Laravel</a>
          <a href="/en/courses?tool=sql" class="btn btn-sm btn-dash btn-accent">Postgres</a>
          <a href="/en/courses?framework=phoenix" class="btn btn-sm btn-dash btn-accent">Phoenix</a>
          <a href="/en/courses" class="btn btn-sm btn-dash btn-accent">Much more</a>
        </div>
      </section>

      <section class="my-20 px-6 py-12 max-w-full md:max-w-4xl mx-auto gap-10 flex flex-col">
        <h2 class="text-center text-2xl font-semibold mb-6">Links</h2>

        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 max-w-full sm:max-w-xl md:max-w-2xl mx-auto">
          <a href="https://discord.gg/podcodar" target="_blank" class="btn btn-outline">
            <.icon name="hero-chat-bubble-left-right" class="w-5 h-5" />
            <span class="ml-2">Discord</span>
          </a>
          <a href="https://github.com/podcodar" target="_blank" class="btn btn-outline">
            <.icon name="hero-heart" class="w-5 h-5" />
            <span class="ml-2">GitHub</span>
          </a>
          <a href="https://github.com/sponsors/podcodar" target="_blank" class="btn btn-outline">
            <.icon name="hero-currency-dollar" class="w-5 h-5" />
            <span class="ml-2">Sponsor</span>
          </a>
          <a
            href="https://github.com/podcodar/.github/blob/main/TRANSPARENCY.md"
            target="_blank"
            class="btn btn-outline"
          >
            <.icon name="hero-document-text" class="w-5 h-5" />
            <span class="ml-2">Transparency</span>
          </a>
        </div>
      </section>

      <section class="my-20 px-6 py-12 max-w-full md:max-w-4xl mx-auto flex flex-col gap-10">
        <div>
          <h2 class="text-center text-3xl font-bold">Our mission</h2>
          <p class="mt-4">
            TechSchool is all about making tech education accessible to everyone for free. There are tons of awesome courses online, but we don't have big bucks for marketing. So, newbies often run into the expensive courses first, making it seem like you have to shell out a ton of money.
          </p>
          <p class="mt-4">
            That's where TechSchool steps in. We're here to shine a light on those awesome free courses that might be flying under the radar. Our website has a bunch of courses covering different areas. The goal? Help anyone go from zero to landing their first job without breaking the bank. We want to tackle the expensive course culture and make tech education fair and equal for everyone.
          </p>
        </div>
      </section>

      <section class="my-20 px-6 py-12 max-w-full md:max-w-4xl mx-auto flex flex-col gap-10">
        <div>
          <h2 class="text-center text-3xl font-bold">Platform Statistics</h2>
          <div class="stats stats-horizontal shadow mt-4 w-full">
            <div class="stat">
              <div class="stat-title">Courses</div>
              <div class="stat-value">189</div>
            </div>
            <div class="stat">
              <div class="stat-title">Bootcamps</div>
              <div class="stat-value">10</div>
            </div>
            <div class="stat">
              <div class="stat-title">Total Views</div>
              <div class="stat-value">1584</div>
            </div>
          </div>
          <p class="text-sm mt-2">Last updated: 3 months ago</p>
          <div class="mt-4 flex justify-center">
            <a
              href="https://github.com/danielbergholz/techschool.dev/blob/main/docs/contributing-guide.md"
              class="btn btn-accent"
              target="_blank"
            >
              Add course to PodCodar
            </a>
          </div>
        </div>
      </section>

      <section class="my-20 px-3 max-w-full md:max-w-4xl mx-auto flex flex-col gap-10">
        <h2 class="text-center text-2xl font-semibold">Huge thanks to our contributors 🚀</h2>

        <div class="flex flex-wrap justify-center gap-4 mt-6">
          <div :for={contrib <- @contributors} class="avatar">
            <div class="w-12 rounded-full ring ring-primary ring-offset-base-100 ring-offset-2">
              <img src={contrib.avatar_url} alt={contrib.login} />
            </div>
          </div>
        </div>
      </section>
    </Layouts.app>
    """
  end

  def mount(_params, _session, socket) do
    changeset = SearchQuery.changeset(%SearchQuery{}, %{})

    {:ok,
     socket
     |> assign(:current_scope, nil)
     |> assign(:form, to_form(changeset))
     |> assign(:contributors, [])
     |> then(fn socket ->
       if connected?(socket), do: send(self(), :load_contributors)
       socket
     end)}
  end

  def handle_event("validate", %{"search_query" => params}, socket) do
    changeset =
      %SearchQuery{}
      |> SearchQuery.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("search", %{"search_query" => params}, socket) do
    changeset = SearchQuery.changeset(%SearchQuery{}, params)

    if changeset.valid? do
      {:noreply, assign(socket, :form, to_form(changeset))}
    else
      {:noreply, assign(socket, :form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_info(:load_contributors, socket) do
    contributors = fetch_contributors()

    {:noreply, assign(socket, :contributors, contributors)}
  end

  defp fetch_contributors do
    org = System.get_env("PODCODAR_GITHUB_ORG", "podcodar")

    with {:ok, response} <-
           Req.get("https://api.github.com/orgs/#{org}/members",
             headers: default_github_headers()
           ),
         200 <- response.status do
      Enum.map(response.body, fn member ->
        %{
          login: Map.get(member, "login"),
          avatar_url: Map.get(member, "avatar_url")
        }
      end)
    else
      error ->
        Logger.debug("Failed to load contributors: #{inspect(error)}")
        []
    end
  end

  defp default_github_headers do
    case System.get_env("GITHUB_TOKEN") do
      nil -> [{"accept", "application/vnd.github+json"}]
      token -> [{"accept", "application/vnd.github+json"}, {"authorization", "Bearer #{token}"}]
    end
  end
end
