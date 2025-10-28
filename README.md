# Podcodar 🎙️

[![CI](https://github.com/podcodar/podcodar/actions/workflows/elixir.yml/badge.svg)](https://github.com/podcodar/podcodar/actions/workflows/elixir.yml)

Bem-vindo ao **Podcodar**, uma plataforma de código aberto dedicada a tornar a educação em tecnologia acessível para todos no Brasil! Nossa missão é simples: acelerar sua jornada na área de tecnologia, oferecendo recursos gratuitos e de alta qualidade, desde o nível iniciante até sua primeira oportunidade de emprego.

## 🚀 Sobre o Projeto

Acreditamos que o conhecimento deve ser livre e acessível. A Podcodar é uma comunidade que seleciona, avalia e organiza os melhores conteúdos gratuitos disponíveis na internet. Além de uma curadoria de cursos, oferecemos:

- **Grupos de estudo:** Aprenda em conjunto com outros desenvolvedores.
- **Entrevistas simuladas:** Prepare-se para o mercado de trabalho.
- **Bolsas de estudo:** Apoiamos o seu desenvolvimento.
- **E muito mais!**

Este repositório contém o código-fonte da nossa plataforma, construída com [Phoenix Framework](https://www.phoenixframework.org/), Elixir e uma pitada de Deno.

## 🛠️ Começando

Quer rodar o projeto localmente? Siga os passos abaixo.

1.  **Instale as dependências:**
    ```bash
    mix setup
    ```
2.  **Inicie o servidor Phoenix:**
    ```bash
    mix phx.server
    ```

Pronto! Agora você pode acessar a plataforma em [`localhost:4000`](http://localhost:4000) no seu navegador.

### Usando Docker

Prefere usar Docker? Sem problemas! O banco de dados SQLite será persistido no diretório `/data`.

```bash
# Construir e iniciar os contêineres
docker compose up -d --build

# Parar os contêineres
docker compose down
```

## ✨ Contribua

Este projeto é feito pela comunidade, para a comunidade. Adoramos contribuições! Se você quer ajudar a melhorar a Podcodar, aqui estão algumas formas:

- **Adicione um curso:** Encontrou um curso incrível e gratuito? Adicione-o à nossa plataforma!
- **Reporte um bug:** Encontrou algo que não funciona como deveria? [Abra uma issue](https://github.com/podcodar/podcodar/issues).
- **Sugira uma funcionalidade:** Tem uma ideia para tornar a Podcodar ainda melhor? Adoraríamos ouvir!
- **Melhore o código:** É desenvolvedor? Faça um [fork do repositório](https://github.com/podcodar/podcodar/fork) e envie um pull request!

Para começar, leia nosso **[Guia de Contribuição](docs/contributing-guidelines.md)**.

## 💬 Comunidade

Junte-se a nós em nossa missão de transformar a educação em tecnologia no Brasil!

- **Discord:** [Participe da nossa comunidade no Discord](https://discord.gg/vnEAM9sFb7)
- **GitHub:** [Siga-nos no GitHub](https://github.com/podcodar)
- **Patrocine:** [Apoie nosso trabalho](https://github.com/sponsors/podcodar)

---

Feito com ❤️ pela comunidade Podcodar.
