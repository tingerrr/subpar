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
/// - show-sub (function, auto): A show rule override for sub figures. Recevies
///   the sub figure.
/// - show-sub-caption (function, auto): A show rule override for sub figure's
///   captions. Receives the realized numbering and caption element.
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

  show-sub: auto,
  show-sub-caption: auto,

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

  _pkg.t4t.assert.any-type(function, type(auto), show-sub)
  _pkg.t4t.assert.any-type(function, type(auto), show-sub-caption)

  show-sub = _pkg.t4t.def.if-auto(it => it, show-sub)
  show-sub-caption = _pkg.t4t.def.if-auto((num, it) => {
    num
    [ ]
    it.body
  }, show-sub-caption)

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

        show figure: show-sub
        show figure: it => {
          let n-sub = sub-figure-counter.get().first() + 1
          show figure.caption: show-sub-caption.with(_numbering(numbering-sub, n-sub))

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

/// Provides a convenient wrapper around @@subpar() which puts sub figures in a
/// grid.
///
/// - columns (auto, int, relative, fraction, array): Corresponds to the grid's
///   `columns` parameter.
/// - rows (auto, int, relative, fraction, array): Corresponds to the grid's
///   `rows` parameter.
/// - gutter (auto, int, relative, fraction, array): Corresponds to the grid's
///   `gutter` parameter.
/// - column-gutter (auto, int, relative, fraction, array): Corresponds to the
///   grid's `column-gutter` parameter.
/// - row-gutter (auto, int, relative, fraction, array): Corresponds to the
///   grid's `row-gutter` parameter.
/// - align (auto, array, alignement, function): Corresponds to the grid's
///   `align` parameter.
/// - inset (relaltive, array, dictionary, function): Corresponds to the grid's
///   `inset` parameter.
/// - numbering (): Corressponds to the super figure's `numbering`.
/// - numbering-sub (): Corressponds to the super figure's `numbering-sub`.
/// - numbering-sub-ref (): Corressponds to the super figure's
///   `numbering-sub-ref`.
/// - supplement (): Corressponds to the super figure's `supplement`.
/// - caption (): Corressponds to the super figure's `caption`.
/// - placement (): Corressponds to the super figure's `placement`.
/// - gap (): Corressponds to the super figure's `gap`.
/// - outlined (): Corressponds to the super figure's `outlined`.
/// - outlined-sub (): Corressponds to the super figure's `outlined-sub`.
/// - label (): Corressponds to the super figure's `label`.
/// - show-sub (): Corressponds to the super figure's `show-sub`.
/// - show-sub-caption (): Corressponds to the super figure's
///   `show-sub-caption`.
/// -> content
#let subpar-grid(
  columns: auto,
  rows: auto,
  gutter: 1em,
  column-gutter: auto,
  row-gutter: auto,
  align: horizon,
  inset: (:),

  kind: image,

  numbering: "1",
  numbering-sub: "(a)",
  numbering-sub-ref: "1a",

  // TODO: see subpar
  supplement: [Figure],
  caption: none,
  placement: none,
  gap: 0.65em,
  outlined: true,
  outlined-sub: false,
  label: none,

  show-sub: auto,
  show-sub-caption: auto,
  ..args,
) = {
  if args.named().len() != 0 {
    panic("Unexpectd arguments: `" + repr(args.named()) + "`")
  }

  let figures = args.pos()

  let unwrap-figure(f) = if _pkg.t4t.is.elem(figure, f) {
    f
  } else if _pkg.t4t.is.arr(f) and f.len() == 2 and _pkg.t4t.is.elem(figure, f.first()) and _pkg.t4t.is.label(f.last()) {
    [#f.first()#f.last()]
  } else {
    panic("Expected either a figure, or an array containing a figure and a label")
  }

  // NOTE: the mere existence of an argument seems to change how grid behaves, so we discard any that are auto ourselves
  let grid-args = (
    columns: columns,
    rows: rows,
    align: align,
    inset: inset,
  )

  if gutter != auto {
    grid-args.gutter = gutter
  }
  if column-gutter != auto {
    grid-args.column-gutter = column-gutter
  }
  if row-gutter != auto {
    grid-args.row-gutter = row-gutter
  }

  subpar(
    numbering: numbering,
    numbering-sub: numbering-sub,
    numbering-sub-ref: numbering-sub-ref,

    supplement: supplement,
    caption: caption,
    placement: placement,
    gap: gap,
    outlined: outlined,
    outlined-sub: outlined-sub,
    label: label,

    show-sub: show-sub,
    show-sub-caption: show-sub-caption,

    grid(
      ..figures.map(unwrap-figure),
      ..grid-args,
    ),
  )
}
