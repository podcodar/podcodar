defmodule PodcodarWeb.PageLive do
  use PodcodarWeb, :live_view
  alias Podcodar.SearchQuery
  require Logger

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <section class="text-center min-h-svh flex flex-col justify-center items-center gap-12 mt-[-6rem] bg-pattern p-6">
        <div class="gap-4 mt-24">
          <h1 class="text-5xl font-bold">Educação em tecnologia acessível para todos!</h1>
          <h2 class="text-2xl">Do zero ao seu primeiro emprego sem pagar nada</h2>
        </div>

        <div class="min-w-full md:min-w-3xl">
          <.form for={@form} id="home-search-form" phx-change="validate" phx-submit="search">
            <.input
              field={@form[:query]}
              type="search"
              placeholder="Pesquise cursos, tópicos..."
              autocomplete="off"
              autofocus
            />

            <.link navigate={~p"/courses"} class="btn btn-ghost">Estou com sorte</.link>
            <.button type="submit">Pesquisar</.button>
          </.form>
        </div>

        <div class="flex flex-wrap justify-center gap-4 max-w-full md:max-w-2xl">
          <a href="/courses?query=golang" class="btn btn-sm btn-dash btn-secondary">Go</a>
          <a href="/courses?query=elixir" class="btn btn-sm btn-dash btn-secondary">Elixir</a>
          <a href="/courses?query=python" class="btn btn-sm btn-dash btn-secondary">Python</a>
          <a href="/courses?query=ruby" class="btn btn-sm btn-dash btn-secondary">Ruby</a>
          <a href="/courses?query=react.js" class="btn btn-sm btn-dash btn-secondary">React</a>
          <a href="/courses?query=node.js" class="btn btn-sm btn-dash btn-secondary">Node</a>
          <a href="/courses?query=laravel" class="btn btn-sm btn-dash btn-secondary">Laravel</a>
          <a href="/courses?tool=sql" class="btn btn-sm btn-dash btn-secondary">Postgres</a>
          <a href="/courses?query=phoenix" class="btn btn-sm btn-dash btn-secondary">Phoenix</a>
          <a href="/courses" class="btn btn-sm btn-dash btn-accent">Muito mais</a>
        </div>
      </section>

      <section class="my-20 px-6 py-12 max-w-full md:max-w-4xl mx-auto gap-12 flex flex-col ">
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
            <span class="ml-2">Patrocinar</span>
          </a>
          <a
            href="https://github.com/podcodar/.github/blob/main/TRANSPARENCY.md"
            target="_blank"
            class="btn btn-outline"
          >
            <.icon name="hero-document-text" class="w-5 h-5" />
            <span class="ml-2">Transparência</span>
          </a>
        </div>
      </section>

      <section class="my-20 px-6 py-12 max-w-full md:max-w-4xl mx-auto flex flex-col gap-12">
        <h2 class="text-center text-3xl font-bold">Nossa missão</h2>

        <div>
          <p class="mt-4">
            Acreditamos que a educação em tecnologia deve ser acessível a todos. Por isso, criamos a PodCodar para impulsionar sua jornada profissional nas áreas de tecnologia!
          </p>
          <p class="mt-4">
            Como fazemos isso? Pesquisamos, avaliamos e organizamos conteúdos de alta qualidade, garantindo que você tenha acesso às melhores oportunidades de aprendizado. Além disso, oferecemos um espaço seguro para troca de ideias, além de mentorias personalizadas, entrevistas simuladas, e muito mais!
          </p>
          <p class="mt-4">
            Junte-se a nós para transformar a educação em tecnologia no Brasil, tornando-a mais inclusiva e acessível! Comece hoje mesmo a se qualificar gratuitamente e alavanque sua carreira nas áreas de TI!
          </p>
        </div>
      </section>

      <section class="my-20 px-6 py-12 max-w-full md:max-w-4xl mx-auto flex flex-col gap-12">
        <h2 class="text-center text-3xl font-bold">Estatísticas da plataforma</h2>
        <div>
          <div class="stats stats-horizontal shadow mt-4 w-full">
            <div class="stat">
              <div class="stat-title">💬 Membros</div>
              <div class="stat-value">253</div>
            </div>
            <div class="stat">
              <div class="stat-title">👩🏾‍💻 Empregos Conquistados</div>
              <div class="stat-value">29</div>
            </div>
            <div class="stat">
              <div class="stat-title">🌐 Horas de cursos</div>
              <div class="stat-value">1421</div>
            </div>
          </div>
          <p class="text-sm text-secondary text-center mt-2">Última atualização: há 7 horas</p>
        </div>

        <div class="mt-4 flex justify-center">
          <a
            href="https://github.com/podcodar/podcodar/blob/main/docs/contributing-guidelines.md"
            class="btn btn-accent"
            target="_blank"
          >
            Adicionar um curso
          </a>
        </div>
      </section>

      <section class="my-20 px-3 max-w-full md:max-w-4xl mx-auto flex flex-col gap-12">
        <h2 class="text-center text-2xl font-semibold">
          Agradecimentos especiais aos nossos colaboradores 🚀
        </h2>

        <div class="flex flex-wrap justify-center gap-4 mt-6">
          <div :for={contrib <- @contributors} class="tooltip">
            <div class="tooltip-content">
              <div class="animate-bounce text-orange-400 text-xl font-black">@{contrib.login}</div>
            </div>

            <div class="avatar">
              <div class="w-12 rounded-full ring ring-primary ring-offset-base-100 ring-offset-2">
                <a
                  href={"https://github.com/#{contrib.login}"}
                  target="_blank"
                  rel="noopener noreferrer"
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
