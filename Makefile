VERSION   := $(shell git describe --tags --abbrev=0 2>/dev/null)
ifeq ($(VERSION),)
  REVNUM  := 0
else
  REVNUM  := $(shell echo "$(VERSION)" | awk -F. '{print $$1"."$$2"."$$3+1}')
endif
DATE      := $(shell date +%Y-%m-%d)
HEAD      := $(shell git rev-parse --short HEAD)
PARAMS    := --attribute revnumber='$(REVNUM)' --attribute revdate='$(DATE)'

BUNDLE    := bundle exec
DOCKER_IMAGE := progit2-builder
DOCKER_RUN   := docker run --rm -v $(CURDIR):/build $(DOCKER_IMAGE)

SOURCES   := progit.asc $(shell find book -name "*.asc")
OUTPUTS   := progit.html progit.epub progit.fb2.zip progit.mobi progit.pdf progit-kf8.epub
CONTRIB   := book/contributors.txt

.PHONY: all html epub fb2 mobi pdf clean check \
        docker-build docker docker-html docker-epub docker-fb2 docker-mobi docker-pdf

all: html epub fb2 mobi pdf

html: progit.html
epub: progit.epub
fb2: progit.fb2.zip
mobi: progit.mobi
pdf: progit.pdf

$(CONTRIB):
	@echo "Contributors as of $(HEAD):" > $@
	@echo "" >> $@
	git shortlog -s HEAD | grep -v -E '(Straub|Chacon|dependabot)' | cut -f 2- | sort | column -c 120 >> $@

progit.html: $(SOURCES) progit-docinfo.html $(CONTRIB)
	@echo 'Converting to HTML...'
	$(BUNDLE) asciidoctor $(PARAMS) -a data-uri progit.asc
	@echo ' -- HTML output at progit.html'

progit.epub: $(SOURCES) $(CONTRIB)
	@echo 'Converting to EPub...'
	$(BUNDLE) asciidoctor-epub3 $(PARAMS) progit.asc
	@echo ' -- EPub output at progit.epub'

progit.fb2.zip: $(SOURCES) $(CONTRIB)
	@echo 'Converting to FB2...'
	$(BUNDLE) asciidoctor-fb2 $(PARAMS) progit.asc
	@echo ' -- FB2 output at progit.fb2.zip'

progit.mobi: $(SOURCES) $(CONTRIB)
	@echo 'Converting to Mobi (kf8)...'
	$(BUNDLE) asciidoctor-epub3 $(PARAMS) -a ebook-format=kf8 progit.asc
	@echo ' -- Mobi output at progit.mobi'

progit.pdf: $(SOURCES) progit-theme.yml $(CONTRIB)
	@echo 'Converting to PDF... (this one takes a while)'
	$(BUNDLE) asciidoctor-pdf $(PARAMS) -a pdf-theme=progit-theme.yml progit.asc
	@echo ' -- PDF output at progit.pdf'

check: progit.html progit.epub
	@echo 'Checking generated books'
	$(BUNDLE) htmlproofer progit.html
	$(BUNDLE) epubcheck progit.epub

clean:
	$(RM) $(OUTPUTS) $(CONTRIB)

docker-build:
	docker build -t $(DOCKER_IMAGE) .

docker:       docker-build; $(DOCKER_RUN)
docker-html:  docker-build; $(DOCKER_RUN) html
docker-epub:  docker-build; $(DOCKER_RUN) epub
docker-fb2:   docker-build; $(DOCKER_RUN) fb2
docker-mobi:  docker-build; $(DOCKER_RUN) mobi
docker-pdf:   docker-build; $(DOCKER_RUN) pdf
