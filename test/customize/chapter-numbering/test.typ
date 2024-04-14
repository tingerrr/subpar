#import "/test/util.typ": *

#import "/src/lib.typ": subpar, super-figure
#show: subpar

// TODO: how do we make it easy to configure the numbering
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  counter(figure.where(kind: image)).update(0)
  it
}

#show figure.where(kind: image): set figure(numbering: n => numbering(
  "1.1a",
  counter(heading).get().first(),
  n,
))

#outline(target: figure.where(kind: image))

= Chapter
#figure(fake-image, caption: [aaa])

#super-figure(
  grid(columns: (1fr, 1fr),
    [#figure(fake-image, caption: [Inner caption]) <a>],
    [#figure(fake-image, caption: [Inner caption]) <b>],
  ),
  caption: [Outer caption],
) <full1>

#figure(
  fake-image,
  caption: [aaa],
)

= Another Chapter
#super-figure(
  grid(columns: (1fr, 1fr),
    [#figure(`adas`, caption: [Inner caption]) <c>],
    [#figure(fake-image, caption: [Inner caption]) <d>],
  ),
  caption: [Outer caption],
) <full2>

#figure(
  fake-image,
  caption: [aaa],
)

See @full1, @a and @b.

See also @full2, @c and @d.

