#let is-element(value, func) = type(value) == content and value.func() == func

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
  if is-element(body, figure) {
    if body.at("kind", default: auto) != auto {
      return (figure.kind,)
    }
  } else if body.has("children") {
    return body.children.map(gather-kinds).flatten().dedup()
  }

  (image, raw, table)
}
