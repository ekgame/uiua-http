# Experimental!
~ "lib.ua"
  ~ Body BuildRequest!
  ~ FormatAddress FormatHeaders FormatPath FormatRequest
  ~ Header Method PerformRequest Url
  ~ ParseResponse

BuildRequest!(
  Url "https://httpbin.org/post"
  Method "POST"
  Header "Content-Type" "text/plain"
  Header "Accept" "application/json"
  Body "name=John&age=25"
)
◌ ⸮ FormatRequest.
PerformRequest
ParseResponse
