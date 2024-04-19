#import "util.typ"
#import "_pkg.typ"

#let _numbering = numbering
#let _label = label

#let sub-figure-counter = counter("__subpar:subfigure-counter")

#let subpar(
  kind: image,

  numbering: "1",
  numbering-sub: "(a)",
  numbering-sub-ref: "1a",

  // TODO: somehow resolve this as good as we can for common kinds and for more languages
  supplement: [Figure],
  caption: none,
  placement: none,
  gap: 0.65em,
  outlined: true,
  outlined-sub: false,
  label: none,

  body,
) = {
  _pkg.t4t.assert.any-type(str, function, kind)

  _pkg.t4t.assert.any-type(str, function, numbering)
  _pkg.t4t.assert.any-type(str, function, numbering-sub)
  _pkg.t4t.assert.any-type(str, function, numbering-sub-ref)

  _pkg.t4t.assert.any-type(str, content, supplement)
  _pkg.t4t.assert.any-type(str, content, type(none), caption)
  _pkg.t4t.assert.any(top, bottom, auto, none, placement)
  _pkg.t4t.assert.any-type(length, gap)
  _pkg.t4t.assert.any-type(bool, outlined)
  _pkg.t4t.assert.any-type(bool, outlined-sub)
  _pkg.t4t.assert.any-type(_label, label)

  context {
    let n-super = counter(figure.where(kind: kind)).get().first() + 1

    [#figure(
      kind: kind,
      numbering: n => _numbering(numbering, n),
      supplement: supplement,
      caption: caption,
      placement: placement,
      gap: gap,
      outlined: outlined,
      {
        // TODO: simply setting it for all doesn't seem to work
        show: util.apply-for-all(
          util.gather-kinds(body),
          kind => inner => {
            show figure.where(kind: kind): set figure(numbering: _ => _numbering(
              numbering-sub-ref, n-super, sub-figure-counter.get().first() + 1
            ))
            inner
          },
        )

        set figure(
          supplement: supplement,
          outlined: outlined-sub,
          placement: none,
        )

        show figure: it => {
          let n-sub = sub-figure-counter.get().first() + 1
          show figure.caption: it => {
            _numbering(numbering-sub, n-sub)
            [ ]
            it.body
          }

          sub-figure-counter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        sub-figure-counter.update(0)
        body
      },
    )#label]
  }
}
