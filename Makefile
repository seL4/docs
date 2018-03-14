
# The following rules generate a yaml file that contains file modification metadata
# provided by git.  The format is:
#
# date: Tue Mar 13 19:11:51 2018 +1100
# timestamps:
#   - page: BuildSystemAnatomy/index.md
#     date: Tue Mar 13 19:11:51 2018 +1100
#   - page: CAmkESDifferences.md
#     date: Tue Mar 13 19:11:51 2018 +1100
# ...
# If this prebuild _data generation step gets more complicated then it should
# probably be moved to a python script.

FILE_NAME=_data/generated.yml

UPDATE_DATE:= $(shell git log -1 --format='%cd %h')
FILES:= $(shell find -iname "*.md" | grep -ve "./README.md" | sed 's/.\///')

_generate_git_site_timestamp:
	echo "date: $(UPDATE_DATE)" > $(FILE_NAME)

_generate_git_per_page_timestamps: _generate_git_site_timestamp
	echo timestamps: >> $(FILE_NAME) && \
	for i in $(FILES); do \
		echo "  - page: $$i" >> $(FILE_NAME) &&\
		echo "    date: `git log -1 --format='%cd %h' -- $$i`" >> $(FILE_NAME); \
	done

generate_data_files: _generate_git_per_page_timestamps

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