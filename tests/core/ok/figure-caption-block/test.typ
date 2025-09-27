// Test for https://forum.typst.app/t/6149 and
// https://github.com/tingerrr/subpar/pull/40.
#import "/src/lib.typ" as subpar

#let count = counter("par")
#let step = count.step()
#show par: it => {
  if it.body.at("children", default: ()).at(0, default: none) == step {
    return it
  }
  par(step + it.body)
}

= Heading

#lorem(10)

#subpar.super(
  grid(
    columns: (1fr,) * 3,
    figure(rect(), caption: [An image]),
    figure(rect(), caption: [Another image]),
    figure(rect(), caption: [A third unlabeled image]),
  ),
  caption: [A figure composed of three sub figures.],
  label: <fig1>,
)

#lorem(10)

#figure(rect(), caption: [An image])

#lorem(10)

#context assert.eq(count.final().first(), 3)
