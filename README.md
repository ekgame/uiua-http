# HTTP client for Uiua

A library to facilitate programmatically building and performing HTTP requests.

## About

While you can make HTTP requests in Uiua, it's a bit cumbersome - you have to open a socket, build a raw HTTP request and you get a raw HTTP response. This library enables you to programmatically build a request, perform it and parse the response in one step. Properly opening the socket and formatting the request is handled by the library. 

# Usage

The simplest method to perform a request is to call the `HttpRequest!` macro with a function that defines the request options. The result will be a map with the parsed response.

```uiua
# Experimental!

# Import the library and relevant functions
~ "git: github.com/ekgame/uiua-http"
  ~ BasicAuth Body Header Method Url
  ~ HttpRequest!

HttpRequest!(
  # Set the request URL
  # This is the only required function call, all the other ones are optional
  Url "http://example.org/"

  # Set the request method
  # Defaults to "GET"
  Method "POST"

  # Set headers as required
  Header "Content-Type" "text/plain"
  Header "Accept" "application/json"

  # Set authorization if needed
  # Note that for "Basic" auth, the value is base64 encoded by the library
  BasicAuth "user:password"

  # Set the body for the request as required
  # "Content-Length" header is set automatically based on the body
  Body "name=John&age=25"
)
```

If you want more control over when the request is built and when it's performed, you can build the request and perform it separately. The result is exactly the same as just calling `HttpRequest!`.

```uiua
# Experimental!

~ "git: github.com/ekgame/uiua-http"
  ~ Body Method Header Url
  ~ BuildRequest! PerformRequest

# Step 1 - Build the request and return a map of values
BuildRequest!(
  Url "http://example.org/"
  Method "GET"
  Header "Content-Type" "text/plain"
  Header "Accept" "application/json"
  Body "name=John&age=25"
)

# Step 2 - Perform the request and return a parsed response
PerformRequest
```

## Available methods

### Types

You can't define custom types in Uiua, but for the sake of documentation specific types of values will be referred to as a "type" described below:

| Type              | Definition                                                                                                    |
|-------------------|---------------------------------------------------------------------------------------------------------------|
| `RequestMap`      | A map with the data needed to perform an HTTP request                                                         |
| `ResponseMap`     | A map parsed from a raw HTTP response.                                                                        |
| `BuilderFunction` | A function for builder macros. At the start of a builder function a `RequestMap` value is on top of the stack |
| `MethodString`    | A string literal, one of "GET", "POST", "PUT", "DELETE", "PATCH", "HEAD", "OPTIONS", "TRACE" or "CONNECT"     |

### Macros

| Function        | Arguments         | Returns       | Explanation                                            |
|-----------------|-------------------|---------------|--------------------------------------------------------|
| `HttpRequest!`  | `BuilderFunction` | `ResponseMap` | Build and perform an HTTP request                      |
| `BuildRequest!` | `BuilderFunction` | `RequestMap`  | Build an HTTP request (without performing the request) |

### Functions

| Function         | Arguments    | Returns       | Explanation                                        |
|------------------|--------------|---------------|----------------------------------------------------|
| `PerformRequest` | `RequestMap` | `ResponseMap` | Perform an HTTP request built with `BuildRequest!` |

### Request builder functions

These are the functions you are expected to use in a `BuilderFunction`. Note that at the beginning of a `BuilderFunction` there is an implicit `RequestMap` value on top of the stack. All these functions take a new `RequestMap` as the last argument and return a `RequestMap` as the only output.

| Function | Arguments | Returns | Explanation |
|-|-|-|-|
| `Url` | `string RequestMap` | `RequestMap` | Set the URL for the request. Must be a full URL with either "http" or "https" schema. The port will be assigned by the schema if it's not declared in the URL. |
| `Method `| `MethodString RequestMap` | `RequestMap` | The method to use for this request.
| `Header` | `string string RequestMap` | `RequestMap` | Add or replace a header for the request. The first argument is the header key, the second argument of the header value. |
| `Body` | `string RequestMap` | `RequestMap` | Set the body for the request. This function will also add an appropriate "Content-Length" header.
| `BasicAuth` | `string RequestMap` | `RequestMap` | Adds "Authorization: Basic" header with the input as base64 encoded value.|
| `BearerAuth` | `string RequestMap` | `RequestMap` | Adds "Authorization: Bearer" header with input value appended to the end.|