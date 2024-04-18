#import "util.typ" as _util

#let keys = (
  superfigure: "__subpar:superfigure-unprepared",
  counter: "__subpar:subfigure-counter",
)

#let subfigure-counter = counter(keys.counter)

#let apply-for-all(
  values,
  rule,
) = outer => {
  show: inner => {
    values.map(rule).fold(inner, (acc, f) => f(acc))
  }

  outer
}

#let super-figure-unprepared(
  kind: image,
  numbering-sub: "(a)",
  numbering-sub-ref: "1a",
  numbering-super: "1",
  // TODO: somehow resolve this as good as we can for common kinds and for more languages
  supplement: [Figure],
  caption: none,
  placement: none,
  gap: 0.65em,
  outlined: true,
  body,
) = figure(
  kind: keys.superfigure,
  placement: placement,
  caption: caption,
  supplement: supplement,
  gap: gap,
  outlined: outlined,
  _util.embed-payload(
    kind: kind,
    numbering-sub: numbering-sub,
    numbering-sub-ref: numbering-sub-ref,
    numbering-super: numbering-super,
    body
  ),
)

#let super-figure-prepared(
  kind-super: image,
  kinds-sub: (image, raw, table),

  numbering-sub: "(a)",
  numbering-sub-ref: "1a",
  numbering-super: "1",

  supplement: none,
  caption: none,
  placement: none,
  gap: 0.65em,
  outlined-super: true,
  outlined-sub: false,
  body,
) = {
  let n-super = counter(figure.where(kind: kind-super)).get().first() + 1

  figure(
    kind: kind-super,
    numbering: _ => numbering(numbering-super, n-super),
    supplement: supplement,
    caption: caption,
    placement: placement,
    gap: gap,
    outlined: outlined-super,
    {
      show: apply-for-all(
        kinds-sub,
        kind => body => {
          show figure.where(kind: kind): set figure(numbering: _ => numbering(
            numbering-sub-ref, n-super, subfigure-counter.get().first() + 1
          ))
          body
        }
      )

      set figure(supplement: supplement, outlined: outlined-sub, placement: none)
      set figure.caption(separator: none)

      show figure: it => {
        let n-sub = subfigure-counter.get().first() + 1
        show figure.caption: it => {
          numbering(numbering-sub, n-sub)
          it.separator
          [ ]
          it.body
        }

        subfigure-counter.step()
        it
        counter(figure.where(kind: it.kind)).update(n => n - 1)
      }

      subfigure-counter.update(0)
      body
    },
  )
}
