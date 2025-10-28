# Contributing

We love our contributors! Here's how you can contribute:

- [Open an issue](https://github.com/podcodar/podcodar/issues) if you believe you have found a bug.
- Make a [pull request](https://github.com/podcodar/podcodar/pull) to add new features, improve the Developer Experience, or fix bugs.

## Adding a new course

- Add a new entry to the JSON file `priv/repo/data/courses.json`. The file should have the following structure:

```jsonc
{
  "title": "Course Title",
  "link": "Embeddable YouTube URL of the course",
  "description": "Brief description of the course (minimum 20 characters)",
  "locale": "br",
  "technologies": ["technology 1", "technology 2"]
}
```

- To get the `link`, go to the course page on YouTube and copy the last part of the URL. For example, for a video, if the URL is `https://www.youtube.com/watch?v=kUMe1FH4CHE`, the `link` is `https://www.youtube.com/embed/kUMe1FH4CHE`. For a playlist, use the format `https://www.youtube.com/embed/videoseries?list=playlist_id`.

### Important notes

- Make sure that the technologies listed in `technologies` are included in the [validation file](../scripts/validate.ts).
- Courses should focus on specific topics. If the course covers only one framework, list only that framework in `technologies`. If the course covers multiple subjects, list them all comprehensively.

Example:

"Complete Web Development" Course:

```jsonc
{
  "title": "Complete Web Development",
  "link": "https://www.youtube.com/embed/videoseries?list=PL1234567890",
  "description": "Course that teaches HTML, CSS, JavaScript, and more!",
  "locale": "br",
  "technologies": ["HTML", "CSS", "JavaScript", "React", "Node.js"]
}
```

## FAQ

### This is a lot of work, I just want to add a course!

We understand. We are working to make this whole process easier. In the meantime, if you want to add a course, just open an issue with the course details and we will add it for you.

### What kind of content can I add?

The main focus of this platform is web development courses. But feel free to add content about: Artificial Intelligence, Data Science, Machine Learning, DevOps, Mobile Development, etc.

### What kind of content can I not add?

- Content that is not related to programming. This includes: music, movies, TV shows, etc.
- Content from creators with any kind of inappropriate behavior, such as: racism, sexism, homophobia, etc. This is completely unacceptable and will not be tolerated in this community.

## Back

[README](../README.md)
