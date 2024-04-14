#import "/src/core.typ": embed-payload, extract-payload

#set page(width: 1cm, height: 1cm)

#let payload = (key: "value")
#let body = [aaa]
#let embedded = [#metadata(payload)#body]

#assert.eq(embed-payload(body, ..payload), embedded)
#assert.eq(extract-payload(embedded), payload)
#assert.eq(extract-payload(body), none)
