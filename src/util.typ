#import "_pkg.typ"

#let apply-for-all(
  values,
  rule,
) = outer => {
  show: inner => {
    values.map(rule).fold(inner, (acc, f) => f(acc))
  }

  outer
}

#let gather-kinds(body) = {
  if _pkg.t4t.is.elem(figure, body) {
    if body.at("kind", default: auto) != auto {
      return (figure.kind,)
    }
  } else if body.has("children") {
    return body.children.map(gather-kinds).flatten().dedup()
  }

  (image, raw, table)
}
