#import "../slydst.typ": *

#show: slides.with(
  title: "Delta",
  subtitle: "A Fork of Slydst",
  authors: "Priyanshu Kumar Rai",
  subslide-numbering: "(i)",
  logo: "template/logo.png",
)

== Outline

#outline()

= Introduction

== Welcome to Delta

- Delta is an enhanced fork of Slydst, designed for creating professional presentations with Typst.
- This presentation showcases new features and customization options.

#v(2fr)

#lorem(15)

= Customization Options

== Changing Themes and Colors

- You can also set a custom `base-hue` (e.g., current hue is #text(fill: color.hsv(base-hue * 1deg, 60%, 55%, 100%), str(base-hue) + "deg")) for a unique color scheme.
- Override colors directly via `title-color` if needed.

```
#show: slides.with(
title: "My Presentation",
title-color: rgb(255, 100, 100) // Custom title color
)
```

== Customizing Fonts and Sizes

- Change the font for text and code blocks with `font` and `code-font` parameters.
- Adjust text size globally with `font-size`.

```
#show: slides.with(
title: "My Presentation",
font: "Roboto", // Custom text font
code-font: "JetBrains Mono", // Custom code font
font-size: 10pt // Smaller text size
)
```

#v(1fr)

#lorem(20)

= New Slide Types

== Focus Slide for Emphasis

- Use `#focus-slide` to create a standout slide with a custom background and text color.
- Ideal for key points or announcements.

#focus-slide[
  This is a Focus Slide!
  Highlight your most important message here.
]

== Two-Column Slide Layout

- Use `#two-column-slide` for side-by-side content.
- Customize column ratios with `left-ratio` and `right-ratio`.

#two-column-slide(
  [
    *Left Column Content*
    - Point 1
    - Point 2
    #lorem(15)
  ],
  [
    *Right Column Content*
    - Image or data here
    #figure(rect(width: 100%, height: 3em, fill: blue), caption: "Placeholder")
  ],
  title: "Custom Two-Column Slide",
  left-ratio: 2fr,
  right-ratio: 1fr
)

= Components

== Definitions, Theorems, and Others

#definition(title: "An Interesting Definition")[
  #lorem(10)
]

#theorem(title: "An interesting theorem", radius: 0.2em)[
  Let $p(x, y)$ a probability distribution, we have,
  $
    p(x, y) &= p(x) p(y | x).
  $
]

#lemma(title: "An interesting lemma")[
  #lorem(20)
]

#corollary(title: "An interesting corollary")[
  #lorem(30)
]

= Summary

== Summary

- Slydst provides simple static slides.
- New features include theme switching, font customization, highlight boxes, columns, and focus slides.
- Customize colors, fonts, and layouts to suit your needs.
- *Todo* - Support custom theme colors
