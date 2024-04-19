#import "util.typ"
#import "_pkg.typ"

#let _numbering = numbering
#let _label = label

#let sub-figure-counter = counter("__subpar:subfigure-counter")

/// Creates a figure which may contain other figures, a #emph[super]figure. For
/// the meaning of parameters take a look at the regular figure documentation.
///
/// - kind (str, function): The image kind which should be used, this is mainly
///   relevant for introspection and defaults to `image`. This cannot be
///   automatically resovled like for normal figures and must be set.
/// - numbering (str, function): This is the numbering used for this super
///   figure.
/// - numbering-sub (str, function): This is the numbering used for the sub
///   figures.
/// - numbering-sub-ref (str, function): This is the numbering used for
///   _references_ to the sub figures. If this is a function, it receives both
///   the super and sub figure numbering respectively.
/// - supplement (content): The supplement used for this _and_ the inner
///   figures, this must be set independently of `kind`.
/// - caption (content): The caption of this super figure.
/// - placement (alignement, auto, none): The float placement of this super
///   figure.
/// - gap (length): The gap between this super figure's caption and body.
/// - outlined (bool): Whether this super figure should appear in an outline of
///   figures.
/// - outlined-sub (bool): Whether the sub figures should appear in an outline
///   of figures.
/// - label: The label to attach to this super figure.
/// -> content
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
