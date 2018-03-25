# From: https://github.com/cyberark/conjur/blob/master/cucumber/api/features/step_definitions/request_steps.rb
# -----------------------
When(/^I( (?:can|successfully))? GET "([^"]*)"$/) do |can, path|
  try_request can do
    get_json path
  end
end

When(/^I( (?:can|successfully))? POST "([^"]*)" with body:$/) do |can, path, body|
  try_request can do
    post_json path, body
  end
end

Then(/^the HTTP response status code is (\d+)$/) do |code|
    expect(@status).to eq(code.to_i)
end

# Adapted from: http://anthonyeden.com/2013/07/10/testing-rest-apis-with-cucumber-and-rack.html
# --------------------
Given /^I send and accept JSON$/ do
    headers[:accept] = 'application/json'
    headers[:content_type] = 'application/json'
end

Given /^I accept HTML$/ do
  headers[:accept] = 'text/html'
end