# Experimental!

~ "utils.ua" ~ BuildMap! InsertBoxed
~ "deps.ua" ~ EncodeBsfString ParseUri
~ "response.ua" ~ ParseResponse

DefaultRequest ↚ |0 BuildMap!(
  InsertBoxed "uri" {}
  InsertBoxed "method" "GET"
  InsertBoxed "protocol" "HTTP/1.0"
  InsertBoxed "headers" BuildMap!(
    InsertBoxed "User-Agent" "uiua-http"
    InsertBoxed "Content-Length" "0"
  )
  InsertBoxed "body" ""
)

BuildRequest! ← ^! DefaultRequest

Header ← ⍜⊙⊙(°□get "headers") InsertBoxed

SchemaToPort ↚ BuildMap!(
  InsertBoxed "http" "80"
  InsertBoxed "https" "443"
)

ValidSchemas ↚ ◌: °map SchemaToPort

ValidateUrl ↚ (
  : ValidSchemas get "schema" .
  $"Invalid schema: \"_\", expecting one of _"
  ⍤ : ∊:ValidSchemas get "schema" :
)

NormalizeUrl ↚ (
  ⍥(
    insert "port" get:SchemaToPort get "schema" .
  )≍□"" get "port" .
)

Url ← (
  ParseUri
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

ValidMethods ↚ {"GET" "POST" "PUT" "DELETE" "PATCH" "HEAD" "OPTIONS" "TRACE" "CONNECT"}

Method ← (
  $"Invalid method: \"_\", expecting one of _" :ValidMethods.
  ⍤ :⊙:∊□:ValidMethods.:
  InsertBoxed "method"
)

Protocol ← InsertBoxed "protocol"

BasicAuth ← Header "Authorization" ⊂"Basic " EncodeBsfString
BearerAuth ← Header "Authorization" ⊂"Bearer "

FormatMethod ↚ °□get "method"

FormatPath ↚ (
  °□get "uri"
  °□get "path".
  ⍥("/"◌)≍"".
  °□get "query":
  ⟨◌|⊂:$"?_"⟩¬≍"".
)

FormatHeaders ↚ (
  °□get "headers"
  ⍚$"_: _" °map
  /$"_\r\n_"
)

FormatBody ↚ °□get "body"

FormatProtocol ↚ °□get "protocol"

FormatAddress ↚ (
  °□get "uri"
  ⊃(°□get "domain"|°□get "port")
  $"_:_"
)

FormatRequest ← (
  ⊃(FormatMethod|FormatPath|FormatProtocol|FormatHeaders|FormatBody)
  $"_ _ _\r\n_\r\n\r\n_"
)

PerformRequest ← (
  ⊃(FormatAddress|FormatRequest)
  &httpsw : &tcpc
  ParseResponse
)
