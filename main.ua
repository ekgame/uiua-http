# Experimental!
~ "lib.ua" ~ Body BuildRequest! DefaultRequest Header Method Url

BuildRequest!(
  Url "http://example.com"
  Method "POST"
  Header "Accepts" "application/json"
  Header "Content-Type" "application/x-www-form-urlencoded"
  Body "name=John&age=25"
)
