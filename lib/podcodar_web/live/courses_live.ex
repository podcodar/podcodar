defmodule PodcodarWeb.CoursesLive do
  use PodcodarWeb, :live_view

  alias Podcodar.Courses

  require Logger

  def mount(params, _session, socket) do
  query = Map.get(params, "query", "")

  {:ok, courses} = Courses.search_courses(query)

  {:ok,
  socket
  |> assign(
  page_title: gettext("Cursos"),
  courses: courses,
  search_form:
  to_form(%{
  "query" => query
  }),
  filters: %{},
    playing_videos: %{}
     )}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="container mx-auto py-8 px-4">
        <h1 class="text-2xl font-bold mb-4">{gettext("Cursos Disponíveis")}</h1>

        <div class="mb-4">
        <.form for={@search_form} id="search-form" phx-change="filter">
            <.input
              field={@search_form[:query]}
              type="search"
              placeholder={gettext("Pesquise cursos...")}
              phx-debounce="420"
              phx-hook="FocusAndCursorToEnd"
            />
          </.form>
        </div>

        <div :if={@courses == []} class="card-body">
          <p class="text-center">{gettext("Curso não encontrado 😭")}</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <div :for={course <- @courses} class="card">
            <div class="card bg-base-100 w-full h-full shadow-sm">
              <figure class="relative cursor-pointer" phx-click="play_video" phx-value-course-title={course.title}>
              <div :if={!Map.get(@playing_videos, course.title, false)} class="relative bg-gray-200 flex items-center justify-center" style="height: 180px;">
                <div class="absolute inset-0 flex items-center justify-center bg-black bg-opacity-50 hover:bg-opacity-30 transition-all duration-200 rounded-t-lg">
                  <div class="bg-white bg-opacity-90 rounded-full p-4 shadow-lg hover:scale-110 transition-transform duration-200">
                    <.icon name="hero-play" class="w-8 h-8 text-gray-800 ml-1" />
                  </div>
                </div>
                <div class="text-center text-gray-600 text-sm font-medium px-4 z-10 relative">
                {gettext("Clique para assistir")}
                </div>
              </div>
              <iframe
                  :if={Map.get(@playing_videos, course.title, false)}
                  width="100%"
                  height="180"
                  src={course.link}
                  title={course.title}
                  frameborder="0"
                  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                  allowfullscreen
                  loading="lazy"
                >
                </iframe>
              </figure>

              <div class="card-body gap-4">
                <h2 class="card-title">{course.title}</h2>

                <p class="badge badge-outline bg-current absolute top-2 right-2 overflow-auto">
                  {if course.locale == "br" do
                    "🇧🇷"
                  else
                    "🇺🇸"
                  end}
                </p>

                <p>{course.description}</p>

                <p class="gap-2 flex flex-wrap">
                  <span
                    :for={tech <- course.technologies}
                    class="badge badge-dash badge-secondary flex-grow"
                  >
                    {tech}
                  </span>
                </p>

                <div class="card-actions justify-end">
                <a
                href={course.link}
                class="btn btn-primary btn-outline"
                target="_blank"
                rel="noopener"
                >
                {gettext("Acessar Curso")}
                </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  def handle_event("filter", %{"query" => query}, socket) do
  Logger.info("Searching courses with query: #{query}")

  {:ok, courses} = Courses.search_courses(query)

  socket =
  socket
  |> assign(
  courses: courses,
  search_form: to_form(%{"query" => query}),
    playing_videos: %{}
  )
      |> push_navigate(to: ~p"/courses?query=#{query}")

    {:noreply, socket}
  end

  def handle_event("play_video", %{"course-title" => course_title}, socket) do
    playing_videos = Map.put(socket.assigns.playing_videos, course_title, true)
    {:noreply, assign(socket, playing_videos: playing_videos)}
  end
end
