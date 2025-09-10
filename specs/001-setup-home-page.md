# Feature: New PodCodar Home Page

## Description

PodCodar is a free and open tech learning community that provides resources and support for individuals interested in finding a new career in tech.
The platform offers a variety of learning materials, including tutorials, articles, and videos, covering topics such as programming languages, web development, artificial intelligence, data science, and more.
PodCodar aims to create an inclusive environment where learners can connect with mentors and peers to enhance their skills and knowledge in the tech industry.

For this feature, we need to implement PodCodar's home page, based on https://techschool.dev/en.

## Tech Stack

- Phoenix Framework with liveview (Refer to AGENTS.md file)
- UI: DaisyUI + TailwindCSS
- Ecto with sqlite3 as database

## Definition of Work

- clean up unnecessary files from the default Phoenix project
- implement a copy of https://techschool.dev/en as PodCodar's home page
- Mock the page data for now, no need to connect to the database
- persist images if needed in `priv/static/images` folder
- add navbar and footer to layout

## Definition of Done

- page is up and running at `/` route
- tests were created and passing for the new page
