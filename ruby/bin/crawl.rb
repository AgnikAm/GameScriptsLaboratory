#!/usr/bin/env ruby
# bin/crawl.rb
require 'bundler/setup'
require 'nokogiri'
require 'open-uri'
require 'logger'

LOGGER = Logger.new($stdout)
USER_AGENT = 'Mozilla/5.0 (compatible; ProstyCrawlerAllegro/0.1; +mailto:twoj@email.com)'

def fetch_html(url)
  LOGGER.info "Fetching page: #{url}"
  URI.open(url, 'User-Agent' => USER_AGENT, &:read)
rescue OpenURI::HTTPError => e
  LOGGER.error "HTTP error: #{e.message}"
  nil
rescue => e
  LOGGER.error "Unexpected error: #{e.class} – #{e.message}"
  nil
end

def parse_example(html)
  doc = Nokogiri::HTML(html)
  title = doc.at_css('h1')&.text&.strip
  price_whole = doc.at_css('.a-offscreen')&.text&.strip
  { title: title, price_whole: price_whole }
end

if ARGV.empty?
  puts "Usage: #{$0} <URL to Amazon product>"
  exit 1
end

url = ARGV[0]
html = fetch_html(url)
if html
  result = parse_example(html)
  puts "Results: #{result.inspect}"
else
  puts "Could not fetch html"
end
