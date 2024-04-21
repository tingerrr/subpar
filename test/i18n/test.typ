// Synopsis:
// - fallback order is region -> language -> english
// - currently there is no way to resolve the styles at the element location like the built in
//   auto does

#import "/test/util.typ": *
#import "/src/lib.typ": subpar, subpar-grid

German:
#set text(lang: "de")

#outline(target: figure.where(kind: image))

#figure(fake-image, caption: [Caption]) <normal1>

#subpar(
  grid(columns: (1fr, 1fr), gutter: 1em, align: horizon,
    [#figure(fake-image, caption: [Inner caption]) <a>],
    [#figure(fake-image, caption: [Inner caption]) <b>],
  ),
  caption: [Outer caption],
  label: <full1>,
)

First
- @normal1
- @full1
- @a
- @b

Second
- @normal2
- @full2
- @c
- @d

#pagebreak()

Chinese:
#set text(lang: "zh", region: "tw")

#outline(target: figure.where(kind: image))

#figure(fake-image, caption: [Caption]) <normal2>

#subpar(
  grid(columns: (1fr, 1fr), gutter: 1em, align: horizon,
    [#figure(fake-image, caption: [Inner caption]) <c>],
    [#figure(fake-image, caption: [Inner caption]) <d>],
  ),
  caption: [Outer caption],
  label: <full2>,
)

First
- @normal1
- @full1
- @a
- @b

Second
- @normal2
- @full2
- @c
- @d
