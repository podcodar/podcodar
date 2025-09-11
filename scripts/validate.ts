import { z } from "zod";

const locale = ["en", "es", "fr", "de"];
const technologies = [
  "testing",
  "fullstack",
  "golang",
  "backend",
  "programming",
  "system",
  "network",
  "docker",
  "vm",
  "linux",
  "cli",
  "shell",
  "python",
  "data-science",
  "javascript",
  "frontend",
  "web",
  "data-structures",
  "algorithms",
  "fundamentals",
  "elixir",
  "functional",
  "java",
  "oop",
  "typescript",
  "spring",
  "terminal",
  "deploy",
];

const CourseSchema = z.object({
  title: z.string().min(5, "Title must be at least 5 characters long"),
  link: z.url("Link must be a valid URL"),
  description: z
    .string()
    .min(20, "Description must be at least 20 characters long"),
  // locale with options
  locale: z.enum(locale),
  technologies: z
    .array(z.enum(technologies))
    .min(1, "At least one technology must be specified")
    .max(5, "No more than five technologies can be specified"),
});

const CourseListSchema = z
  .array(CourseSchema)
  .min(1, "Course list cannot be empty");

if (Deno.args.length !== 1) {
  console.error(
    "Usage: deno run --allow-read scripts/validate.ts <path-to-json>",
  );
  Deno.exit(1);
}

const filePath = Deno.args[0];
const data = await Deno.readTextFile(filePath);

const courses = CourseListSchema.safeParse(JSON.parse(data));
if (!courses.success) {
  console.error("Validation errors:", courses.error);
  Deno.exit(1);
}

console.log("All courses are valid!");
