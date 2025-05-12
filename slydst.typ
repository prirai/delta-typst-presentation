#let base-hue = 168
#let theme-light-bg = color.hsv(base-hue * 1deg, 20%, 95%, 50%)
#let theme-heading-2 = color.hsv(base-hue * 1deg, 40%, 75%, 100%)
#let theme-heading-3 = color.hsv(base-hue * 1deg, 50%, 65%, 100%)
#let theme-accent = color.hsv(base-hue * 1deg, 60%, 55%, 100%)
#let theme-dark-text = color.hsv(base-hue * 1deg, 80%, 20%, 100%)
#let theme-heading-top = theme-accent
#let theme-footer-bg = color.hsv(base-hue * 1deg, 10%, 90%, 100%)
#let theme-footer-text = color.hsv(base-hue * 1deg, 20%, 60%, 100%)

#let theme-definition-header = color.hsv(200 * 1deg, 40%, 75%, 100%)
#let theme-definition-body = color.hsv(200 * 1deg, 15%, 90%, 100%)
#let theme-theorem-header = color.hsv(260 * 1deg, 45%, 70%, 70%)
#let theme-theorem-body = color.hsv(260 * 1deg, 10%, 85%, 100%)
#let theme-lemma-header = color.hsv(160 * 1deg, 35%, 75%, 100%)
#let theme-lemma-body = color.hsv(160 * 1deg, 10%, 92%, 100%)
#let theme-corollary-header = color.hsv(40 * 1deg, 50%, 80%, 100%)
#let theme-corollary-body = color.hsv(40 * 1deg, 20%, 90%, 100%)
#let theme-algorithm-header = color.hsv(300 * 1deg, 50%, 75%, 100%)
#let theme-algorithm-body = color.hsv(300 * 1deg, 25%, 88%, 100%)

#let default-color = theme-heading-top
#let bg-color = theme-light-bg
#let title-color = theme-heading-top

#let layouts = (
  "small": ("height": 9cm, "space": 1.4cm),
  "medium": ("height": 10.5cm, "space": 1.6cm),
  "large": ("height": 12cm, "space": 1.8cm),
)
#let layout-space = state("space", v(-0.8cm))

#let default-font = "Source Serif Pro"
#let default-code-font = "Dank Mono"
#let default-font-size = 12pt

#show heading: it => [
  set text(theme-dark-text)
  set align(center)
]

show heading.where(level: 1): x => {
  set page(header: none, footer: context [
    #set text(0.5em)
    #v(2.8em)
    #set align(left)
    progress-slider
  ], fill: bg-color)
  set align(center + horizon)
  set text(1.3em, weight: "bold", fill: theme-dark-text)
  v(- layouts.at("medium").space / 3)
  x.body
}

show heading.where(level: 2): x => {
  set text(1.1em, weight: "bold", fill: theme-dark-text)
  pagebreak(weak: true)
  x.body
}

show heading.where(level: 3): x => {
  set text(1.0em, weight: "bold", fill: theme-dark-text)
  x.body
}

#show outline.entry: it => {
  show linebreak: [ ]
  it
}

#let title-slide(content) = {
  set page(footer: none)
  set align(center)
  context layout-space.get()
  content
  pagebreak(weak: true)
}

#let context-footer = context {
  let page = here().page()
  let headings = query(heading)
    .filter(h => h.location().page() <= page)
  let latest = ()
  let found_h2_on_current_page = headings
    .filter(h => h.level == 2 and h.location().page() == page)
    .len() > 0

  for level in range(1, 4) {
    if found_h2_on_current_page and level > 2 {
      break
    }
    let filtered = headings.filter(h => h.level == level)
    let found = if filtered.len() > 0 { filtered.last() } else { none }
    if found != none {
      latest += (found.body,)
    }
  }
  block(
    width: auto,
    inset: (x: 0.5em, y: 0.3em),
    fill: theme-footer-bg,
    radius: 0.3em,
    stroke: none,
    text(fill: theme-footer-text, latest.join(" > "))
  )
}

#let progress-slider = context {
  let total = counter(page).final().at(0)
  let current = counter(page).at(here()).at(0)
  let width = 100%
  let progress = if total > 0 { (current / total) * 100 } else { 0 }
  v(5pt)
  box(
    width: width,
    height: 0.5em,
    fill: theme-footer-bg,
    radius: 0.2em,
    stroke: color.hsv(0 * 1deg, 0%, 70%, 100%),
    box(
      width: progress * 1%,
      height: 0.5em,
      fill: theme-accent,
      radius: 0.2em
    )
  )
}

#let focus-slide(content, bg-fill: theme-dark-text, text-fill: theme-light-bg) = {
  set page(header: none, footer: none, fill: bg-fill)
  set align(center + horizon)
  set text(1.5em, weight: "bold", fill: text-fill)
  content
  pagebreak(weak: true)
}

#let two-column-slide(left-content, right-content, title: none, left-ratio: 1fr, right-ratio: 1fr) = {
  set page(header: context {
    let page = here().page()
    let headings = query(selector(heading.where(level: 2)))
    let heading = headings.rev().find(x => x.location().page() <= page)
    if heading != none {
      set align(top)
      set text(1.2em, weight: "bold", fill: title-color)
      v(layouts.at("medium").space / 3)
      block(if title != none { title } else { heading.body })
    }
  }, footer: context [
    #set text(0.7em)
    #grid(
      columns: 1,
      rows: (auto, 0.8em),
      grid.cell(
        colspan: 1,
        grid(
          columns: (1fr, auto),
          align(left)[#context-footer],
          align(right)[#counter(page).display("1 of 1", both: true)]
        )
      ),
      grid.cell(
        colspan: 1,
        progress-slider
      )
    )
  ], footer-descent: 1.2em)
  set align(top)
  grid(
    columns: (left-ratio, right-ratio),
    gutter: 1em,
    left-content,
    right-content
  )
  pagebreak(weak: true)
}

#let slides(
  content,
  title: none,
  subtitle: none,
  date: none,
  authors: (),
  layout: "medium",
  ratio: 4/3,
  title-color: none,
  subslide-numbering: none,
  logo: none,
  theme: "default",
  base-hue: 168,
  font: default-font,
  code-font: default-code-font,
  font-size: default-font-size
) = {
  if layout not in layouts {
    panic("Unknown layout " + layout)
  }
  let (height, space) = layouts.at(layout)
  let width = ratio * height
  layout-space.update(v(- space / 2))

  if title-color == none {
    title-color = default-color
  }

  if title != none {
    set document(title: smallcaps[title], author: authors)
  }
  set page(
    width: width,
    height: height,
    margin: (x: 0.5 * space, top: space, bottom: space),
    header: context{
      let page = here().page()
      let headings = query(selector(heading.where(level: 2)))
      let heading = headings.rev().find(x => x.location().page() <= page)
      if heading != none {
        set align(top)
        set text(1.2em, weight: "bold", fill: title-color)
        v(space / 3)
        block(heading.body + if not heading.location().page() == page and subslide-numbering != none [
          #{ numbering(subslide-numbering, page - heading.location().page() + 1) }
        ])
      }
    },
    header-ascent: 0%,
    footer: context [
      #set text(0.7em)
      #grid(
        columns: 1,
        rows: (auto, 0.8em),
        grid.cell(
          colspan: 1,
          grid(
            columns: (1fr, auto),
            align(left)[#context-footer],
            align(right)[#counter(page).display("1 of 1", both: true)]
          )
        ),
        grid.cell(
          colspan: 1,
          progress-slider
        )
      )
    ],
    footer-descent: 1.2em,
  )
  set outline(target: heading.where(level: 1), title: none)

  set bibliography(title: none)

  set text(font: font, lang: "en", size: font-size)
  show raw: set block(fill: silver.lighten(65%), width: 100%, inset: 1em)
  show raw: set text(font: code-font)

  show figure.caption: set text(style: "italic", size: 0.7em)
  show heading.where(level: 1): x => {
    set page(header: none, footer: context [
      #set text(0.5em)
      #v(0.8em)
      #set align(left)
      #progress-slider
    ], fill: bg-color)
    set align(center + horizon)
    set text(1.3em, weight: "bold", fill: theme-heading-top)
    v(- space / 3)
    x.body
  }
  show heading.where(level: 2): pagebreak(weak: true)
  show heading: set text(1.1em, fill: theme-heading-2)

  if title != none {
    if (type(authors) != array) {
      authors = (authors,)
    }
    title-slide[
      #v(50pt)
      #text(2.2em, weight: "bold", fill: title-color, upper(title))
      #v(20pt, weak: true)
      #if subtitle != none { text(1.2em, weight: "regular", subtitle) }
      #if subtitle != none and date != none { text(1.1em)[ | ] }
      #if date != none { text(1.0em, date) }
      #v(20pt)
      #if subtitle != none or date != none {
        place(center, text(0.9em, authors.join(", ", last: " and ")))
      } else {
        align(center, text(0.9em, authors.join(", ", last: " and ")))
      }
      #v(20pt)
      #if logo != none { figure(image(logo, width: 30%))}
    ]
  }

  content
}

#let frame(content, counter: none, title: none, fill-body: none, fill-header: none, radius: 0.2em) = {
  let header = none

  if fill-header == none and fill-body == none {
    fill-header = default-color.lighten(75%)
    fill-body = default-color.lighten(85%)
  }
  else if fill-header == none {
    fill-header = fill-body.darken(10%)
  }
  else if fill-body == none {
    fill-body = fill-header.lighten(50%)
  }

  if radius == none {
    radius = 0pt
  }

  if counter == none and title != none {
    header = [*#title.*]
  } else if counter != none and title == none {
    header = [*#counter.*]
  } else {
    header = [*#counter:* #title.]
  }

  show stack: set block(breakable: false, above: 0.8em, below: 0.5em)

  stack(
    block(
      width: 100%,
      inset: (x: 0.6em, top: 0.35em, bottom: 0.45em),
      fill: fill-header,
      radius: (top: radius, bottom: 0cm),
      header,
    ),
    block(
      width: 100%,
      inset: (x: 0.6em, top: 0.45em, bottom: 0.45em),
      fill: fill-body,
      radius: (top: 0cm, bottom: radius),
      content,
    ),
  )
}

#let d = counter("definition")
#let definition(content, title: none, ..options) = {
  d.step()
  frame(
    counter: context d.display(x => "Definition " + str(x)),
    title: title,
    content,
    fill-header: theme-definition-header,
    fill-body: theme-definition-body,
    ..options,
  )
}

#let t = counter("theorem")
#let theorem(content, title: none, ..options) = {
  t.step()
  frame(
    counter: context t.display(x => "Theorem " + str(x)),
    title: title,
    content,
    fill-header: theme-theorem-header,
    fill-body: theme-theorem-body,
    ..options,
  )
}

#let l = counter("lemma")
#let lemma(content, title: none, ..options) = {
  l.step()
  frame(
    counter: context l.display(x => "Lemma " + str(x)),
    title: title,
    content,
    fill-header: theme-lemma-header,
    fill-body: theme-lemma-body,
    ..options,
  )
}

#let c = counter("corollary")
#let corollary(content, title: none, ..options) = {
  c.step()
  frame(
    counter: context c.display(x => "Corollary " + str(x)),
    title: title,
    content,
    fill-header: theme-corollary-header,
    fill-body: theme-corollary-body,
    ..options,
  )
}

#let a = counter("algorithm")
#let algorithm(content, title: none, ..options) = {
  a.step()
  frame(
    counter: context a.display(x => "Algorithm " + str(x)),
    title: title,
    content,
    fill-header: theme-algorithm-header,
    fill-body: theme-algorithm-body,
    ..options,
  )
}
