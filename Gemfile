source "https://rubygems.org"

# Copyright 2020 seL4 Project a Series of LF Projects, LLC.
# SPDX-License-Identifier: BSD-2-Clause

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
gem "jekyll"

# Other dependencies
gem "html-proofer", "~>4"

# Ruby 3.3 warns about these being moved out of std lib and recommends adding
# them here:
gem "base64"
gem "csv"
gem "bigdecimal"

# If you have any plugins, put them here!
# Look here for supported github plugins: https://pages.github.com/versions/
group :jekyll_plugins do
  gem "jekyll-titles-from-headings"
  gem "jekyll-relative-links"
  gem "jekyll-optional-front-matter"
  gem "jekyll-sitemap"
  gem 'jekyll-toc'
  gem 'jekyll-redirect-from'
  gem 'jekyll-remote-theme'
  gem "jekyll-postcss-v2"
  gem "jekyll-inline-svg"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
