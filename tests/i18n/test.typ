// Synopsis:
// - fallback order is region -> language -> english
// - currently there is no way to resolve the styles at the element location like the built in
//   auto does

#import "/tests/util.typ": *
#import "/src/lib.typ" as subpar

German:
#set text(lang: "de")

#outline(target: figure.where(kind: image))

#figure(fake-image, caption: [Regular]) <normal1>

#subpar.grid(
  figure(fake-image, caption: [Inner caption]), <a>,
  figure(fake-image, caption: [Inner caption]), <b>,
  columns: (1fr, 1fr),
  caption: [Super],
  label: <full1>,
)

German
- @normal1
- @full1
- @a
- @b

English
- @normal2
- @full2
- @c
- @d

#pagebreak()

English:
#set text(lang: "en")

#outline(target: figure.where(kind: image))

#figure(fake-image, caption: [Regular]) <normal2>

#subpar.grid(
  figure(fake-image, caption: [Inner caption]), <c>,
  figure(fake-image, caption: [Inner caption]), <d>,
  columns: (1fr, 1fr),
  caption: [Super],
  label: <full2>,
)

German
- @normal1
- @full1
- @a
- @b

English
- @normal2
- @full2
- @c
- @d
