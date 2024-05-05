// Synopsis:
// - show-figure poduces the same visual output as a regular figure

#import "/test/util.typ": *
#import "/src/lib.typ" as subpar

#show figure: subpar.default.show-figure

#figure([a])
