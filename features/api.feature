Feature: API to Shorten URL

    Big Earl supports creating a short URL by sending a POST
    request to the root path with a parameter containing the
    full URL to shorten

    Scenario: POST / to create a new short URL

        When I successfully create a short URL for "http://google.com"
        Then the JSON should have "short_url"

    Scenario: Get /:code to redirect to original URL

        Sending a GET request with any ACCEPT header other than
        Application/JSON should return a 302 (Permanent) redirect 
        to the original URL.

        Given I successfully create a short URL for "http://google.com"
        When I GET the short URL
        Then the HTTP response status code is 302
        And the redirect URL is "http://google.com" 

    Scenario: Get /:code with API to retrieve full URL

        Sending a GET request to the short code with an ACCEPT header
        of Application/Json, then the endpoint will return a JSON
        response describing the contents of the short URL record.

        Given I successfully create a short URL for "http://google.com"
        When I GET the short URL through the API
        Then the HTTP response status code is 200
        And the JSON should have "redirect_to"
        And the JSON should have "preview_url"

    Scenario: Try to create short link for invalid URL 

        Creating an invalid URL from the browser should cause the url
        to return back to the new code page with a status code of 403.

        Given I accept HTML
        When I create a short URL for "invalid_url"
        Then the HTTP response status code is 403

    Scenario: Try to create short link for empty URL 

        Creating an empty URL from the browser should cause the url
        to return back to the new code page with a status code of 403.

        Given I accept HTML
        When I create a short URL for ""
        Then the HTTP response status code is 403

    Scenario: Try to create short link for a data URL 

        Creating a data URL from the browser should cause the url
        to return back to the new code page with a status code of 403.

        Given I accept HTML
        When I create a short URL for "data:text/html,%3Ch1%3EHello%2C%20World!%3C%2Fh1%3E"
        Then the HTTP response status code is 403

    Scenario: Try to create short link for a Javascript literal 

        Creating a Javascript URL from the browser should cause the url
        to return back to the new code page with a status code of 403.

        Given I accept HTML
        When I create a short URL for "javascript:alert('Hello World');"
        Then the HTTP response status code is 403

    Scenario: Try to create short link for invalid URL through API

        Creating an invalid URL from an api client should cause the url
        to return a JSON document with a "messages" and return a status
        code of 403.

        Given I send and accept JSON
        When I create a short URL for "invalid_url"
        Then the HTTP response status code is 403
        And the JSON should have "messages"

        

    