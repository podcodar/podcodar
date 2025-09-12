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
end
