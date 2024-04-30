#import "@local/mantys:0.1.3" as mantys
#import "@preview/hydra:0.4.0": hydra

#import "/src/lib.typ": subpar-grid

#let package = toml("/typst.toml").package

#let issue(n) = text(
  eastern,
  link("https://github.com/tingerrr/subpar/issues/" + str(n))[subpar\##n],
)

#show "Subpar": mantys.package

#show: mantys.mantys.with(
  ..package,
  title: [subpar],
  date: datetime.today().display(),
  abstract: [
    Subpar provides easy to use sub figures with sensible default numbering and an easy-to-use
    no-setup API.
  ],
)

#show raw: it => {
  show "{{VERSION}}": package.version
  it
}

= Manifest
Subpar aims to be:
- simple to use
  - importing a function and using it should be all that is needed
  - setup required to make the package work should be avoided
- unsurprising
  - parameters should have sensible names and behave as one would expect
  - deviations from this must be documented and easily accesible to Typst novices
- interoperable
  - Subpar should be easy to use with other packages by default or provide sufficient configuration to allow this in other ways
- minimal
  - it should only provide features which are specifically used for sub figures

If you think its behvior is surprising, you believe you found a bug or think its defaults or parameters are not sufficient for your use case, please open an issue at #text(eastern, link("https://github.com/tingerrr/subpar")[GitHub:tingerrr/subpar]).
Contributions are also welcome!

= Guide
== Labeling
Currently to refer to a super figure the label must be explicitly passed to `subpar` using `label: <...>`.

== Grid Layout
The default `subpar` function provides only the style rules to make sub figures correctly behave with respect to numbering.
To arrange them in a specific layout, you can use any other Typst function, a common choice would be `grid`.

```typst
#import "@preview/subpar:{{VERSION}}": subpar

#subpar(
  grid(
    [#figure(image("image1.png"), caption: [An image]) <a>],
    [#figure(image("image2.png"), caption: [Another image]) <b>],
    figure(image("image2.png"), caption: [A third unlabeled image]),
    columns: (1fr,) * 3,
  )
  caption: [A figure composed of three sub figures.],
  label: <fig>,
)

We can refer to @fig, @fig1 and @fig2.
```

Because this quickly gets cumbersome, subpar provides a default grid layout wrapper called `subpar-grid`.
It provides good defaults like `gutter: 1em` and hides options which are undesireable for sub figure layouts like `fill` and `stroke`.
You can pass labeled sub figures as arrays of the figure and its label.

```typst
#import "@preview/subpar:{{VERSION}}": subpar-grid

#subpar-grid(
  figure(image("image1.png"), caption: [An image]), <a>,
  figure(image("image2.png"), caption: [Another image]), <b>,
  figure(image("image2.png"), caption: [A third unlabeled image]),
  columns: (1fr,) * 3,
  caption: [A figure composed of three sub figures.],
  label: <fig>,
)

We can refer to @fig, @fig1 and @fig2.
```

== Numbering
`subpar` and `subpar-grid` take three different numberings:
/ `numbering`: The numbering used for the sub figures when displayed or referenced.
/ `numbering-sub`: The numbering used for the sub figures when displayed.
/ `numbering-sub-ref`: The numbering used for the sub figures when referenced.

Similarly to a normal figure, these can be functions or string patterns. The `numbering-sub` and `numbering-sub-ref` patterns will receive both the super figure an sub figure number.

== Supplements
Currently, supplements for super figures propagate down to super figures, this ensures that the supplement in a reference will not confuse a reader, but it will cause reference issues in multilingual documents (see #issue(4)).

#subpar-grid(
  columns: (1fr, 1fr),
  figure(
    ```typst
    Hello Typst!
    ```,
    caption: [Typst Code],
  ), <sup-ex-code>,
  figure(
    lorem(10),
    caption: [Lorem],
  ),
  caption: [A figure containing two super figures.],
  label: <sup-ex-super>,
)

When refering the the super figure we see "@sup-ex-super", when refering to the sub figure of a different kind, we still see the same supplement "@sup-ex-code".

To turn this behavior off, set `propagate-supplement` to `false`, this will also resolve the issues from #issue(4).

#subpar-grid(
  columns: (1fr, 1fr),
  propagate-supplement: false,
  figure(
    ```typst
    Hello Typst!
    ```,
    caption: [Typst Code],
  ), <sup-ex-no-prop-code>,
  figure(
    lorem(10),
    caption: [Lorem],
  ),
  caption: [A figure containing two super figures.],
  label: <sup-ex-no-prop-super>,
)

Now when refering the the super figure we see still see "@sup-ex-no-prop-super", but when refering to the sub figure of a different kind, we the inferred supplement "@sup-ex-no-prop-code".

= Reference
#mantys.tidy-module(read("/src/lib.typ"), name: "subpar")
