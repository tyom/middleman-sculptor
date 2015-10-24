# Middleman Sculptor

[Middleman](https://middlemanapp.com/) extension for creation of interactive styleguides and code examples.

## Installation

    $ gem install middleman-sculptor

## Usage

Middleman Sculptor has an excecutable `middleman-sculptor`. It is also aliased to `sculpt`.

To see the list of available commands run `sculpt help`. Sculptor extends [Middleman](https://github.com/middleman/middleman) so all Middleman commands also apply, although they currently do not appear under the `sculptor help` command.

### New project

To start a new project:

    $ middleman-sculptor init project-name

This will create a new directory `project-name` with templates for a new styleguide. It also installs Ruby and NPM dependencies.

Aliases: `i` and `n`.

### Configuring external Sass load paths and assets

Middleman Sculptor uses [Webpack](https://webpack.github.io/) to bundle up its JavaScript. This allows writing JS in CommonJS or AMD style. Then JS is passed to Asset Pipiline to be served.

To use an NPM JS Library just `npm install` it and Webpack will pick it up. To use Sass library or make images discoverable by Asset Pipeline (e.g. [Mojular GOV.UK Elements](https://github.com/mojular/govuk-elements)) add relevant paths to `Sass.load_paths` and Sprockets in `config.rb`:

```ruby
# Sass load paths
govuk_elements_path = File.join(root, 'node_modules/mojular-govuk-elements')
JSON.parse(IO.read("#{govuk_elements_path}/package.json"))['paths']['sass'].each do |p|
  Sass.load_paths << File.expand_path("#{govuk_elements_path}/#{p}")
end

# Sprockets
ready do
  moj_images = File.join(root, 'node_modules', 'mojular-govuk-elements', 'assets', 'images')
  sprockets.append_path moj_images

  Dir.chdir(moj_images) do
    Dir['**/*.{js,png,jpg}'].each do |asset|
      sprockets.import_asset(asset)
    end
  end
end
```

#### Project structure

When Sculptor generates a new project it adds a few files and directories that are used for the styleguide UI. They are called or prefixed with the word *glyptotheque* and can be edited to customise the look and feel of the styleguide.

### Existing project

To update Sculptor in an existing project run `middleman-sculptor init` in the project folder. It's recommended to have the existing project in a version control system so that any conflicting local changes can be easily reapplied.


### Running local server

Bundle up JavaScript using Webpack:

    $ node_modules/.bin/webpack

Or install it globally `npm install -g webpack` and run using `webpack` command. You can leave it running in another terminal tab `webpack --watch`.

During the development run local [Middleman server](https://middlemanapp.com/basics/development_cycle/):

    $ middleman server

`server` is optional and is the default command so can be omitted.

*Recommended* way is to run both using [Foreman](https://github.com/ddollar/foreman) (included in Gemfile):

    $ foreman start

This will launch Middleman server and Webpack watch together.


## Creating a styleguide

A styleguide is a collection of html snippets called **models**. Sculptor extends Middleman with several new helpers and templates that wrap these snippets.

Middleman supports a [number of templates](https://middlemanapp.com/basics/template_engine_options/) so any ERB, Haml or Slim should all work the same but it's mostly been tested with Slim.

To start, create a new page anywhere in `source` directory. It should have a [Frontmatter](https://middlemanapp.com/basics/frontmatter/) with at least one property `title`.

Let's say we create a new page `source/button.html.slim`

```slim
---
title: Button
---

= model
  button Click me
```

Now if we run `middleman server` and go to http://localhost:4567/, we'll see a menu in the left-hand side sidebar with *Button* entry. There is also a box in the main section called *Button*. They both link to our new page.

<img src=docs/styleguide-index.png width=800>

The Button page shows the model, and toggles to show its source and structure outline.

<img src=docs/styleguide-page.png width=800>

Each additional model will appear on the page and can be mixed with any other HTML. For example, documentation on usage of a particular component.

NB: Due to the way Sculptor extracts models from template to make them accessible by URLs, some pages may require a server restart after they are added/renamed.


## Adding stylesheets

Sculptor uses Sass by default but other CSS preprocessors or vanilla CSS can be used.

Styles can be placed in the same directory as the HTML file, or in the `assets` directory. To ensure the styles properly integrate with the assets pipeline, it's recommended to place styles in the `assets/styles` directory or anywhere within the `source` directory as long as they are in subdirectory called `styles`. Then the Sass can correctly import other stylesheets (including external dependencies) and find images.

Let's create a new stylesheet for our button. Create a new file `source/styles/generic.scss` with the following contents:

```scss
button {
  padding: 20px;
  background: #ddd;
  font-size: 1em;
  border: 0;
}
```

To include this stylesheet in the file add the `stylesheet` property to file's Frontmatter:

```yaml
---
title: Button
stylesheet: styles/generic
---
```

The path is relative to the file's location. It can also include relative paths (e.g. `../another-directory/style.scss`). To use `source` directory as root start path with `/` (e.g. `/styles/generic.scss`).

The property can also be called `stylesheets` and include a list of files, either comma-separated or list separated, e.g.:

```yaml
stylesheets: base, form, footer
```

```yaml
stylesheets:
  - base
  - form
  - footer
```

## Adding JavaScript

Similarly to styles, JS files can be injected.

```yaml
javascript: js/button.js
```

## Models

Each page can contain any number of *models*, the extracts of HTML that are rendered on HTML page several treatments:

- The snippet is rendered on HTML page in a special container  
  <img src=docs/styleguide-model.png width=400>  

- It has an **Outline** toggle that shows the structure of the HTML snippet
  <img src=docs/styleguide-outline.png width=400>  

- It has an **HTML Source** toggle that shows the HTML snippet code
  <img src=docs/styleguide-html.png width=400>  

There are two types of models: **inline** and **iframe**.

### Inline models

Good for rendering isolated components which styles are scoped in components selector and don't affect the rest of the page.

This is a standard model helper. It renders its contents and styles directly in the page.

[Slim Template Language](https://github.com/slim-template/slim) also parses standard HTML which makes it great for quickly generating pages. Although currently Slim minifies rendered HTML. Slim also allows [embedding of other languages](https://github.com/slim-template/slim#embedded-engines-markdown-). I recommend embedding your code in `erb:`

```slim
= model
  erb:
    <h1 class="page-title">Sculptor</h1>
```

This way the white spaces are preserved.

### iframe models

When the embedded styles or JS need to be encapsulated, use iframe model. It will render its contents in the iframe and resize appropriately.

The first parameter is required and used to generate a file for each model which is used as iframe source.

This model also adds an **isolate** button which links to those individual files, allowing you to view each component on its own without any of Sculptor's UI.

```slim
= model 'title',
  iframe: true
  erb:
    <h1 class="page-title">Sculptor</h1>
```

Or using an alias:

```slim
= imodel 'title'
  erb:
    <h1 class="page-title">Sculptor</h1>
```

### Remote grab

Model can also have a remote source.

```slim
= imodel 'bbc',
  url: 'http://www.bbc.co.uk/',
  css: '#h4weather'
```

- `url` points to any public webpage (JS is not loaded)  
- `css` grabs only the specified CSS selector. If multiple elements match, they are all returned. To pick a specific element within multiple returned, select it by the 0-index (separate selector from index by at least 1 space): `css: 'h2 #2'`

It's also possible to include remote CSS and JS.

```yaml
---
stylesheet: http://static.bbci.co.uk/h4weather/0.82.2/style/h4weather.css
javascript: http://code.jquery.com/jquery-2.1.4.min.js
---
```

---

### Examples

- [Playground for GOV.UK elements](http://ministryofjustice.github.io/bower-playground/)
