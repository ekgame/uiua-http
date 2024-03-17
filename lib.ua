# Experimental!

Request ~ "request.ua"
  Body ← Request~Body
  Header ← Request~Header
  Method ← Request~Method
  Url ← Request~Url
  PerformRequest ← Request~PerformRequest

Response ~ "response.ua"
  ParseResponse ← Response~ParseResponse

BuildRequest! ← Request~BuildRequest!^!
HttpRequest! ← ParseResponse PerformRequest BuildRequest!^!

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
