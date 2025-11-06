defmodule PodcodarWeb.PageLive do
  use PodcodarWeb, :live_view
  alias Podcodar.SearchQuery
  alias Podcodar.Courses
  alias Podcodar.Cache
  require Logger

  # list of suggested searches
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope} locale={@locale}>
      <section class="text-center min-h-svh flex flex-col justify-center items-center gap-12 mt-[-4rem] bg-pattern p-8 md:p-16">
        <div class="gap-6 flex flex-col">
          <h1 class="text-3xl sm:text-4xl md:text-5xl font-bold">
            {gettext("accessible_tech_education")}
          </h1>
        </div>

        <div class="w-full md:w-2xl">
          <.form for={@form} id="home-search-form" phx-change="validate" phx-submit="search">
            <.input
              field={@form[:query]}
              type="search"
              placeholder={gettext("search_courses_topics")}
              autocomplete="off"
              class="rounded-full px-8 py-6 rounded-full input input-bordered input-lg w-full"
              autofocus
            />

            <.button type="submit">{gettext("search")}</.button>
            <.link navigate={~p"/random"} class="btn btn-ghost">{gettext("im_feeling_lucky")}</.link>
          </.form>
        </div>

        <div class="flex flex-wrap justify-center gap-4 max-w-full md:max-w-2xl px-8">
          <.link
            :for={term <- @suggested_searches}
            navigate={~p"/courses?query=#{term}"}
            class="btn btn-sm btn-dash opacity-70"
          >
            {term}
          </.link>
          <a href="/courses" class="btn btn-sm btn-dash btn-accent">{gettext("much_more")}</a>
        </div>
      </section>

      <section class="max-w-full md:max-w-4xl mx-auto gap-12 flex flex-col p-8 md:p-16">
        <h2 class="text-center text-2xl font-semibold mb-6">{gettext("links")}</h2>

        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 max-w-full sm:max-w-xl md:max-w-2xl mx-auto">
          <.link navigate={~p"/discord"} target="_blank" rel="noopener" class="btn btn-outline">
            <.icon name="hero-chat-bubble-left-right" class="w-5 h-5" />
            <span class="ml-2">{gettext("discord")}</span>
          </.link>

          <.link navigate={~p"/github"} target="_blank" rel="noopener" class="btn btn-outline">
            <.icon name="hero-heart" class="w-5 h-5" />
            <span class="ml-2">{gettext("github")}</span>
          </.link>

          <.link navigate={~p"/sponsor"} target="_blank" rel="noopener" class="btn btn-outline">
            <.icon name="hero-currency-dollar" class="w-5 h-5" />
            <span class="ml-2">{gettext("sponsor")}</span>
          </.link>

          <.link
            href="https://github.com/podcodar/.github/blob/main/TRANSPARENCY.md"
            target="_blank"
            rel="noopener"
            class="btn btn-outline"
          >
            <.icon name="hero-document-text" class="w-5 h-5" />
            <span class="ml-2">{gettext("transparency")}</span>
          </.link>
        </div>
      </section>

      <section class="max-w-full md:max-w-4xl mx-auto flex flex-col gap-12 p-8 md:p-16">
        <h2 class="text-center text-3xl font-bold">{gettext("our_mission")}</h2>

        <div>
          <p class="mt-4">
            {gettext("mission_paragraph_1")}
          </p>
          <p class="mt-4">
            {gettext("mission_paragraph_2")}
          </p>

          <ol class="list-decimal list-inside ml-2 mt-4 space-y-2">
            <li>{gettext("mission_point_1")}</li>
            <li>{gettext("mission_point_2")}</li>
            <li>{gettext("mission_point_3")}</li>
            <ul class="list-disc list-inside ml-4 mt-4 space-y-2">
              <li>{gettext("study_groups")}</li>
              <li>{gettext("mock_interviews")}</li>
              <li>{gettext("scholarships")}</li>
              <li>{gettext("and_much_more")}</li>
            </ul>
          </ol>

          <p class="mt-4">
            {gettext("mission_call_to_action")}
          </p>
        </div>
      </section>

      <section class="max-w-full md:max-w-4xl mx-auto flex flex-col gap-12 p-8 md:p-16">
        <h2 class="text-center text-3xl font-bold">{gettext("platform_statistics")}</h2>
        <div>
          <div class="stats stats-vertical md:stats-horizontal shadow mt-4 w-full text-center">
            <div class="stat">
              <div class="stat-title">{gettext("active_members")}</div>
              <div class="stat-value">256</div>
            </div>
            <div class="stat">
              <div class="stat-title">{gettext("jobs_secured")}</div>
              <div class="stat-value">32</div>
            </div>
            <div class="stat">
              <div class="stat-title">{gettext("course_hours")}</div>
              <div class="stat-value">1421</div>
            </div>
          </div>
          <p class="text-sm text-secondary text-center mt-2">{gettext("last_updated_3_hours_ago")}</p>
        </div>

        <div class="mt-4 flex justify-center">
          <a
            href="https://github.com/podcodar/podcodar/blob/main/docs/contributing-guidelines.md"
            class="btn btn-accent"
            target="_blank"
            rel="noopener"
          >
            {gettext("add_a_course")}
          </a>
        </div>
      </section>

      <section class="max-w-full md:max-w-4xl mx-auto flex flex-col gap-12 p-8 md:p-16">
        <h2 class="text-center text-2xl font-semibold">
          {gettext("special_thanks_to_contributors")}
        </h2>

        <div class="flex flex-wrap justify-center gap-4 px-4">
          <div :for={contrib <- @contributors} class="tooltip">
            <div class="tooltip-content">
              <div class="animate-bounce text-orange-400 text-xs md:text-xl font-black">
                @{contrib.login}
              </div>
            </div>

            <div class="avatar">
              <div class="w-12 rounded-full ring ring-primary ring-offset-base-100 ring-offset-2">
                <a
                  href={"https://github.com/#{contrib.login}"}
                  target="_blank"
                  rel="noopener"
                >
                  <img src={contrib.avatar_url} alt={contrib.login} />
                </a>
              </div>
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
     |> assign(:form, to_form(changeset))
     |> assign(:contributors, [])
     |> assign(suggested_searches: Courses.suggested_searches())
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
      query = Ecto.Changeset.get_field(changeset, :query)
      params = %{"query" => query}

      {:noreply,
       socket
       |> assign(:form, to_form(changeset))
       |> push_navigate(to: ~p"/courses?#{params}")}
    else
      {:noreply, assign(socket, :form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_info(:load_contributors, socket) do
    callback = fn -> fetch_contributors() end
    {:ok, contributors} = Cache.cache(:contributors, callback, 3600)

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
