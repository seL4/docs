
# Rules for local serving of the site using jekyll.
# Supports docker or running using local environment.
# The _production versions run with JEKYLL_ENV=production which will show additional content.
# The _production versions require `generate_data_files` to have been run separately.
JEKYLL_ENV:=development

docker_serve:
	docker run --network=host -v $(PWD):/host -w /host -it ruby bash -c 'bundle install && JEKYLL_ENV=$(JEKYLL_ENV) bundle exec jekyll serve'

docker_serve_production:
	$(MAKE) docker_serve JEKYLL_ENV=production

serve:
	JEKYLL_ENV=$(JEKYLL_ENV) bundle exec jekyll serve

serve_production:
	$(MAKE) serve JEKYLL_ENV=production