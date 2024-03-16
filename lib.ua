# Experimental!

URI ~ "git: github.com/ekgame/uiua-uri-parser"

BuildMap! ← |0 ^! {}
InsertBoxed ← |3 insert ∩□

DefaultRequest ← |0 BuildMap!(
  InsertBoxed "uri" {}
  InsertBoxed "method" "GET"
  InsertBoxed "headers" BuildMap!(
    InsertBoxed "User-Agent" "uiua-http"
    InsertBoxed "Content-Length" "0"
  )
  InsertBoxed "body" ""
)

Header ← |3 λ(
  ⍜(°□get "headers") (InsertBoxed a b) c
)

SchemaToPort ← BuildMap!(
  InsertBoxed "http" "80"
  InsertBoxed "https" "443"
)

ValidSchemas ← ◌: °map SchemaToPort

ValidateUrl ← (
  : ValidSchemas get "schema" .
  $"Invalid schema: \"_\", expecting one of _"
  ⍤ : ∊:ValidSchemas get "schema" :
)

NormalizeUrl ← (
  ⍥(
    insert "port" get:SchemaToPort get "schema" .
  )≍□"" get "port" .
)

Url ← (
  URI~Parse
  ValidateUrl .
  NormalizeUrl
  InsertBoxed "uri" ⊙:.
  Header "Host" °□get "domain":
)

Body ← (
  ⊙:.
  InsertBoxed "body"
  Header "Content-Length" ⧻:
)

ValidMethods ← {"GET" "POST" "PUT" "DELETE" "PATCH" "HEAD" "OPTIONS" "TRACE" "CONNECT"}
Method ← (
  $"Invalid method: \"_\", expecting one of _" :ValidMethods.
  ⍤ :⊙:∊□:ValidMethods.:
  InsertBoxed "method"
)

BuildRequest! ← ^! DefaultRequest

FormatMethod ← °□get "method"

FormatPath ← (
  °□get "uri"
  °□get "path".
  ⍥("/"◌)≍"".
  °□get "query":
  ⟨◌|⊂:$"?_"⟩¬≍"".
)

FormatHeaders ← (
  °□get "headers"
  ⍚$"_: _" °map
  /$"_\r\n_"
)

FormatBody ← °□get "body"

FormatAddress ← (
  °□get "uri"
  ⊃(°□get "domain"|°□get "port")
  $"_:_"
)

# FormatRequest ← (
#   ⊃(FormatMethod|FormatPath|FormatHeaders|FormatBody)
#   $$ _ _ HTTP/1.0
#   $$ _
#   $$ 
#   $$ _
# )

FormatRequest ← (
  ⊃(FormatMethod|FormatPath|FormatHeaders|FormatBody)
  $"_ _ HTTP/1.0\r\n_\r\n\r\n_"
)

PerformRequest ← (
  ⊃(FormatAddress|FormatRequest)
  &httpsw : &tcpc
)

SplitHeaderAndBody ← (
  ⊜□≠1⦷ "\r\n\r\n".
  °□⊢.
  ⟨""◌|°□⊡1⟩>1⧻.:
)

ParseStatusLine ← (
  ↙2 ⊜□¬≡(⍥(0◌)>2.) ⦷" ".
  map {"protocol" "status"}
)

ParseHeaders ← (
  ⍚(⊜□≠1⦷ ": ".?)
  ≡(⊡1°□).
  ≡(⊡0°□):
  map
)

ParseHeader ← (
  ⊜□¬⦷ "\r\n".
  ⊃(°□⊢)(↘1)
  ParseStatusLine
  ParseHeaders:
  InsertBoxed "headers"
  InsertBoxed "body" :
)

ParseResponse ← (
  :SplitHeaderAndBody
  ParseHeader
)
