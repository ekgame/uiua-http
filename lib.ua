# Experimental!

URI ~ "git: github.com/ekgame/uiua-uri-parser"

BuildMap! ← |0 ^! {}
InsertBoxed ← |3 λ(insert □a □ b c)

DefaultRequest ← |0 BuildMap!(
  InsertBoxed "uri" {}
  InsertBoxed "method" "GET"
  InsertBoxed "headers" BuildMap!(
    InsertBoxed "User-Agent" "uiua-http"
  )
  InsertBoxed "body" ""
)

Header ← |3 λ(
  ⍜(°□get "headers") (InsertBoxed a b) c
)

Url ← |2 (
  URI~Parse
  InsertBoxed "uri" ⊙:.
  Header "Host" °□get "domain" :
)

Body = InsertBoxed "body"

ValidMethods ← {"GET" "POST" "PUT" "DELETE" "PATCH" "HEAD" "OPTIONS" "TRACE" "CONNECT"}
Method ← (
  $"Invalid method: \"_\", expecting one of _" :ValidMethods.
  ⍤ :⊙:∊□:ValidMethods.: # TODO: Replace with bind
  InsertBoxed "method"
)

BuildRequest! ← ^! DefaultRequest
