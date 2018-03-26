Given(/^I( (?:can|successfully))? create a short URL for "([^"]*)"$/) do |can, url|
    step 'I send and accept JSON'

    request_body = %(
        {
            "url": "#{url}"
        }
    )
    step 'I POST "/" with body:', request_body
    step 'the HTTP response status code is 200' unless can.nil?
end

When("I GET the short URL") do
    step 'I accept HTML'
    short_uri = URI.parse last_short_url
    step "I GET \"#{short_uri.path}\""
end

Then("the redirect URL is {string}") do |string|
    expect(@response.headers[:location]).to eq(string)
end

When("I GET the short URL through the API") do
    step 'I send and accept JSON'
    short_uri = URI.parse last_short_url
    step "I GET \"#{short_uri.path}\""
end