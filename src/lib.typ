#import "core.typ"
#import "util.typ"

#let super-figure(
  kind-super: image,
  kinds-sub: (image, raw, table),

  numbering-sub: "(a)",
  numbering-sub-ref: "1a",
  numbering-super: "1",

  // TODO: somehow resolve this as good as we can for common kinds and for more languages
  supplement: [Figure],
  caption: none,
  placement: none,
  gap: 0.65em,
  outlined-super: true,
  outlined-sub: false,
  label: none,
  body,
) = context {
  let n-super = counter(figure.where(kind: kind-super)).get().first() + 1

  [#figure(
    kind: kind-super,
    numbering: _ => numbering(numbering-super, n-super),
    supplement: supplement,
    caption: caption,
    placement: placement,
    gap: gap,
    outlined: outlined-super,
    {
      show: util.apply-for-all(
        kinds-sub,
        kind => body => {
          show figure.where(kind: kind): set figure(numbering: _ => numbering(
            numbering-sub-ref, n-super, core.subfigure-counter.get().first() + 1
          ))
          body
        }
      )

      set figure(supplement: supplement, outlined: outlined-sub, placement: none)
      set figure.caption(separator: none)

      show figure: it => {
        let n-sub = core.subfigure-counter.get().first() + 1
        show figure.caption: it => {
          numbering(numbering-sub, n-sub)
          it.separator
          [ ]
          it.body
        }

        core.subfigure-counter.step()
        it
        counter(figure.where(kind: it.kind)).update(n => n - 1)
      }

      core.subfigure-counter.update(0)
      body
    },
  )#label]
}

#let subpar(
  sub-figure-kinds: (image, raw, table),
  outline-subfigures: false,
  body,
) = {
  body
}
