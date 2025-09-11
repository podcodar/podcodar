#! which deno
import { z } from "npm:zod";

const locale = ["en", "es", "fr", "de"];
const technologies = [
	"phoenix",
	"liveview",
	"ecto",
	"channels",
	"deployment",
	"api",
	"testing",
	"fullstack",
];

const CourseSchema = z.object({
	title: z.string().min(5, "Title must be at least 5 characters long"),
	link: z.string().url("Link must be a valid URL"),
	description: z
		.string()
		.min(20, "Description must be at least 20 characters long"),
	// locale with options
	locale: z.enum(locale, {
		errorMap: () => ({ message: `Locale must be one of: ${locale.join(",")}` }),
	}),
	technologies: z
		.array(
			z.enum(technologies, {
				errorMap: () => ({
					message: `Technology must be one of: ${technologies.join(",")}`,
				}),
			}),
		)
		.min(1, "At least one technology must be specified"),
});

const CourseListSchema = z
	.array(CourseSchema)
	.min(1, "Course list cannot be empty");

const args = Deno.args();

if (args.length !== 1) {
	console.error(
		"Usage: deno run --allow-read scripts/validate.ts <path-to-json>",
	);
	Deno.exit(1);
}

const filePath = args[0];
const data = await Deno.readTextFile(filePath);

const courses = CourseListSchema.safeParse(JSON.parse(data));
if (!courses.success) {
	console.error("Validation errors:", courses.error.errors);
	Deno.exit(1);
}

console.log("All courses are valid!");
