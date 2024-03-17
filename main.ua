# Experimental!
~ "lib.ua"
  ~ BearerAuth Body Header Method Url
  ~ BuildRequest! HttpRequest!

BuildRequest!(
  Url "https://httpbin.org/post"
  Method "POST"
  Header "Content-Type" "text/plain"
  Header "Accept" "application/json"
  BearerAuth "user:password"
  Body "name=John&age=25"
)
