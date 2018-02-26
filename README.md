# seL4 Documentation site.

Currently WIP

To build and host locally:
```
# If this doesn't work see: https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/
bundle install

bundle exec jekyll serve
#   Server address: http://127.0.0.1:4000/
#   Server running... press ctrl-c to stop.
```
Or with docker: 
```
docker run --network=host -v $PWD:/host -w /host -it ruby bash -c 'bundle install && bundle exec jekyll serve'
```
