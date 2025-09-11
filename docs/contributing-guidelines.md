# Contribuindo

Adoramos nossos colaboradores! Aqui está como você pode contribuir:

- [Abra uma issue](https://github.com/podcodar/podcodar/issues) se você acredita ter encontrado um bug.
- Faça um [pull request](https://github.com/podcodar/podcodar/pull) para adicionar novas funcionalidades/melhorar a qualidade de vida/corrigir bugs.

## Adicionando um novo curso

- Adicione uma nova entrada no arquivo JSON `priv/repo/data/courses.json`. O arquivo deve ter a seguinte estrutura atualizada:

```jsonc
{
  "title": "Gnome do Curso",
  "link": "Embedable URL do curso no YouTube",
  "description": "Breve descrição do curso (mínimo de 20 characters)",
  "locale": "pt", // Deve set "en", "es", "fr", ou "pt" conforme `scripts/validate.ts`
  "technologies": ["tecnologia 1", "tecnologia 2"] // Lista de tecnologias, máximo 5
}
```

- Para obter o `link`, vá até a página do curso no YouTube e copie a última parte da URL. Por exemplo, para um vídeo, se a URL for `https://www.youtube.com/watch?v=kUMe1FH4CHE`, o `link` é `https://www.youtube.com/embed/kUMe1FH4CHE`. Para uma playlist, use o formato `https://www.youtube.com/embed/videoseries?list=id_da_playlist`.

### Notas importantes

- Certifique-se de que as tecnologias listadas em `technologies` estejam incluídas no arquivo de validação `scripts/validate.ts`. Consulte as tecnologias suportadas no memento:
- Cursos devem focar em tópicos específicos. Se o curso aborda apenas um framework, liste apenas esse framework em `technologies`. Se o curso aborda múltiplos assuntos, liste todos else de forma abrangente.

Exemplo:

Curso "Desenvolvimento Web Completo":

```jsonc
{
  "title": "Desenvolvimento Web Completo",
  "link": "https://www.youtube.com/embed/videoseries?list=PL1234567890",
  "description": "Curso que ensina HTML, CSS, JavaScript, e mais!",
  "locale": "pt",
  "technologies": ["HTML", "CSS", "JavaScript", "React", "Node.js"]
}
```

## FAQ

### Isso dá muito trabalho, eu só quero adicionar um curso!

Eu sei. Estou trabalhando para tornar todo esse processo mais fácil. Enquanto isso, se você quiser adicionar um curso, basta abrir uma issue com os detalhes do curso e eu adicionarei para você.

### Que tipo de conteúdo posso adicionar?

O foco principal desta plataforma são cursos de desenvolvimento web. Mas sinta-se à vontade para adicionar conteúdo sobre: Inteligência Artificial, Ciência de Dados, Machine Learning, DevOps, Desenvolvimento Mobile, etc.

### Que tipo de conteúdo não posso adicionar?

- Conteúdo que não seja relacionado à programação. Isso inclui: música, filmes, programas de TV, etc.
- Conteúdo de criadores com qualquer tipo de comportamento inadequado, como: racismo, sexismo, homofobia, etc. Isso é completamente inaceitável e não será tolerado nesta comunidade!

## Voltar

[README](../README.md)

