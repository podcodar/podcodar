defmodule Podcodar.Courses do
  require Logger

  # define a course structure
  defmodule Course do
    @derive Jason.Encoder
    defstruct [:title, :description, :link, :locale, :technologies]
  end

  def list_courses do
    path = resolve_courses_file_path()
    {:ok, content} = File.read(path)

    case Jason.decode(content) do
      {:ok, courses} ->
        Logger.info("Successfully loaded courses from #{path}: #{inspect(courses)}")

        {:ok,
         Enum.map(courses, fn course_map ->
           %Course{
             title: Map.get(course_map, "title", ""),
             description: Map.get(course_map, "description", ""),
             link: Map.get(course_map, "link", ""),
             locale: Map.get(course_map, "locale", ""),
             technologies: Map.get(course_map, "technologies", [])
           }
         end)}

      {:error, reason} ->
        Logger.error("Failed to decode courses JSON: #{inspect(reason)}")
        {:ok, []}
    end
  end

  def search_courses(search_text) do
    {:ok, courses} = list_courses()

    query =
      search_text
      |> String.trim()
      |> String.downcase()

    courses =
      courses
      |> Enum.filter(fn %Course{} = course ->
        String.downcase(course.title) =~ query or
          String.downcase(course.description) =~ query or
          Enum.any?(course.technologies, fn tech ->
            String.downcase(tech) =~ query
          end)
      end)

    {:ok, courses}
  end

  defp resolve_courses_file_path do
    env_path = Application.get_env(:podcodar, :courses_file_path)

    cond do
      is_binary(env_path) and File.exists?(env_path) ->
        env_path

      true ->
        priv_dir = :code.priv_dir(:podcodar) |> List.to_string()
        Path.join(priv_dir, "repo/data/courses.json")
    end
  end
end
