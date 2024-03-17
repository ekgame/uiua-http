# Experimental!
~ "lib.ua"
  ~ Body Header Method Url
  ~ HttpRequest!

HttpRequest!(
  Url "https://httpbin.org/post"
  Method "POST"
  Header "Content-Type" "text/plain"
  Header "Accept" "application/json"
  Body "name=John&age=25"
)
