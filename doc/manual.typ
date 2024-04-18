#import "@preview/mantys:0.1.1": *

#import "/src/lib.typ" as subpar

#let package = toml("/typst.toml")

#show: mantys.with(
  ..package,
  title: [subpar],
  date: datetime.today().display(),
  abstract: [
    Subpar provides easy to use subfigures with sensible default numbering and related features like chapter-relative numbering in mind.
  ],
  example-scope: (subpar: subpar)
)

#tidy-module(read("/src/lib.typ"))
