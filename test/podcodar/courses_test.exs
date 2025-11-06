defmodule Podcodar.CoursesTest do
  use ExUnit.Case, async: false

  alias Podcodar.Courses

  describe "list_courses/0" do
    test "returns a list of courses" do
      assert {:ok, courses} = Courses.list_courses()
      assert length(courses) == 1
      assert hd(courses).title == "Phoenix in Action"
    end

    test "returns an empty list when no courses are available" do
      # Assuming we have a way to clear the courses for testing purposes
      # This is just a placeholder for the actual implementation
      # Podcodar.Courses.clear_courses()
      filepath = Application.get_env(:podcodar, :courses_file_path)
      assert {:ok, courses} = Courses.list_courses()
      assert :ok = File.write(filepath, "[]")

      assert {:ok, []} = Courses.list_courses()
      assert :ok = File.write(filepath, Jason.encode!(courses))
    end

    test "handles invalid JSON gracefully" do
      filepath = Application.get_env(:podcodar, :courses_file_path)
      assert {:ok, courses} = Courses.list_courses()
      assert :ok = File.write(filepath, "{invalid_json}")

      assert {:ok, []} = Courses.list_courses()
      assert :ok = File.write(filepath, Jason.encode!(courses))
    end
  end

  describe "suggested_searches/0" do
    test "returns the list of topics" do
      topics = Courses.suggested_searches()

      assert "sql" in topics
      assert "ash" in topics
      assert "elixir" in topics
      assert "phoenix" in topics
    end
  end

  describe "get_random/0" do
    test "returns one of the topics" do
      topics = Courses.suggested_searches()
      random_topic = Courses.get_random()
      assert random_topic in topics
    end
  end
end
