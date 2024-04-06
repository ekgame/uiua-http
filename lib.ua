# Experimental!

Request ~ "request.ua"
  Body ← Request~Body
  Header ← Request~Header
  Method ← Request~Method
  Url ← Request~Url
  Protocol ← Request~Protocol
  BasicAuth ← Request~BasicAuth
  BearerAuth ← Request~BearerAuth
  PerformRequest ← Request~PerformRequest
  FormatHttpRequest ← Request~FormatRequest

Response ~ "response.ua"
  ParseHttpResponse ← Response~ParseResponse

BuildRequest! ← Request~BuildRequest!^!
HttpRequest! ← PerformRequest BuildRequest!^!

---
AssertOk ← ⍤ "Fail" ≍200°□get "status"

AssertOk HttpRequest!(
  Url "https://httpbin.org/get"
)

AssertOk HttpRequest!(
  Url "https://httpbin.org/post"
  Method "POST"
  Body $ {"key": "value"}
)

AssertOk HttpRequest!(
  Url "https://httpbin.org/put"
  Method "PUT"
  Body $ {"key": "value"}
)

AssertOk HttpRequest!(
  Url "https://httpbin.org/delete"
  Method "DELETE"
)

AssertOk HttpRequest!(
  Url "https://httpbin.org/patch"
  Method "PATCH"
  Body $ {"key": "value"}
)

---
