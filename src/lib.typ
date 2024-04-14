#import "core.typ"

#let super-figure = core.super-figure-unprepared

#let subpar(
  sub-figure-kinds: (image, raw, table),
  outline-subfigures: false,
  body,
) = {
  show figure.where(kind: core.keys.superfigure): it => {
    let payload = core.extract-payload(it.body)

    core.super-figure-prepared(
      kind-super: payload.kind,
      kinds-sub: sub-figure-kinds,

      numbering-sub: payload.numbering-sub,
      numbering-sub-ref: payload.numbering-sub-ref,
      numbering-super: payload.numbering-super,

      supplement: it.supplement,
      caption: if it.caption != none { it.caption.body },
      placement: it.placement,
      gap: it.gap,
      outlined-super: it.outlined,
      outlined-sub: outline-subfigures,
      it.body,
    )
  }

  // TODO: outline adjustement

  show ref: it => {
    if core.is-element(it.element, figure) and it.element.kind == core.keys.superfigure {
      let payload = core.extract-payload(it.element.body)
      link(it.element.location(), {
        it.element.supplement
        [ ]
        numbering(
          payload.numbering-super,
          counter(figure.where(kind: payload.kind)).at(it.element.location()).first() + 1
        )
      })
    } else {
      it
    }
  }

  body
}
