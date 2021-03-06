default: all
##############################################################
PASSH=$(shell command -v passh)
GIT=$(shell command -v git)
SED=$(shell command -v gsed||command -v sed)
NODEMON=$(shell command -v nodemon)
FZF=$(shell command -v fzf)
BLINE=$(shell command -v bline)
UNCRUSTIFY=$(shell command -v uncrustify)
PWD=$(shell command -v pwd)
FIND=$(shell command -v find)
EMBED_BINARY=$(shell command -v embed)
JQ_BIN=$(shell command -v jq)
DIR=$(shell pwd)	
TESTS_LIST_LOG_FILE = $(shell pwd)/.tests-list.log
TESTS_SUITES_LOG_FILE=$(shell pwd)/.tests-suites.log
TESTS_TESTS_LOG_FILE=$(shell pwd)/.tests-tests.log
##############################################################
TIDIED_FILES = deps*/*.c deps*/*.h term*/*.c term*/*.h ctable*/*.c ctable*/*.h *table*/*.c *table*/*.h cgif-test/*.c *-test/*.c *-test/*.h chan-test/*.c chan-test/*.h \
			   introspect-test/*.c introspect-test/*.h \
			   introspect/*.c introspect/*.h \
			   reproc-test/*.c reproc-test/*.h \
			   list-test/*.c list-test/*.h \
			   *-test/*.c *-test/*.h \
			   intro*/*.c intro*/*.h 
########################################################
TRIGGER_FILE=.trigger.c
##############################################################
do-setup:
	@[[ -d submodules ]] || mkdir submodules
git-add:
	@git add meson/deps/*/meson.build
	@git add subprojects/*.wrap
	@git add deps*/*.c deps*/*.h
	@git add scripts/*.sh
	@git status
fmt-scripts:
	@shfmt -w scripts/*.sh
uncrustify:
	@$(UNCRUSTIFY) -c etc/uncrustify.cfg --replace $(TIDIED_FILES)||true
uncrustify-clean:
	@find  . -type f -maxdepth 2 -name "*unc-back*"|xargs -I % unlink %
clean: rm-make-logs
	@rm -rf build .cache
fix-dbg:
	@$(SED) 's|, % c);|, %c);|g' -i $(TIDIED_FILES)
	@$(SED) 's|, % u);|, %u);|g' -i $(TIDIED_FILES)
	@$(SED) 's|, % s);|, %s);|g' -i $(TIDIED_FILES)
	@$(SED) 's|, % lu);|, %lu);|g' -i $(TIDIED_FILES)
	@$(SED) 's|, % d);|, %d);|g' -i $(TIDIED_FILES)
	@$(SED) 's|, % zu);|, %zu);|g' -i $(TIDIED_FILES)
install: do-install
do-install: all
	@meson install -C build
rm-make-logs:
	@rm .make-log* 2>/dev/null||true
do-meson:
	@eval cd . && {  meson build || { meson build --reconfigure || { meson build --wipe; } && meson build; }; }
do-sync:
	rsync -arv ~/repos/meson_deps \
		~/repos/c_ansi/submodules/. \
		--exclude="*/.git/*" \
		--exclude=".git/*" \
		--exclude '.git'
do-nodemon:
	@$(PASSH) -L .nodemon.log $(NODEMON) \
		--delay .3 \
		-w "dbgp-test/*.h" -w "dbgp-test/*.c"\
		-w 'meson/meson.build' -w 'meson/deps/*/meson.build' -w 'meson.build' \
		-w Makefile \
		-i '*/embeds/*' -i 'subprojects/*/' -i submodules -i 'build/*' \
		-w "term-tests" \
		-w "chan-test/*.c" -w "chan-test/*.h" \
		-w "reproc-test/*.c" -w "reproc-test/*.h" \
		-w "*-test/*.c" -w "*-test/*.h" \
		-w "*/*.c" -w "*/*.h" \
	    -w "introspect-test/*.c" -w "introspect-test/*.h" \
	    -w "introspect/*.c" -w "introspect/*.h" \
		-w "term-tests-test" \
		-i build \
			-e Makefile,tpl,build,sh,c,h,Makefile \
			-x env -- bash -c 'make||true'
git-submodules-pull:
	@git submodule foreach git pull origin master --jobs=10
git-submodules-update:
	@git submodule update --init
git-pull:
	@git pull --recurse-submodules
do-uncrustify: uncrustify uncrustify-clean fix-dbg
do-build: do-meson
	@meson compile -C build
do-test:
	@passh meson test -C build -v --print-errorlogs	
test: do-test
build: do-meson do-build
ansi: all do-sync do-ansi-make
tidy: \
	rm-make-logs \
	do-setup \
	fmt-scripts do-uncrustify \
	do-build \
	git-add
dev: do-nodemon
all: do-setup do-build do-test
trigger:
	@[[ -f $(TRIGGER_FILE) ]] && unlink $(TRIGGER_FILE)
	@touch $(TRIGGER_FILE)
meson-introspect-all:
	@meson introspect --all -i meson.build
meson-introspect-targets:
	@meson introspect --targets -i meson.build
meson-binaries:
	@meson introspect --targets  meson.build -i | jq 'map(select(.type == "executable").filename)|flatten|join("\n")' -Mrc|xargs -I % echo build/%
meson-binaries-loc:
	@make meson-binaries|xargs -I % echo %.c|sort -u|xargs Loc --files|bline -a bold:green -r yellow -R 1-6

do-pull-submodules-cmds:
	command find submodules -type d -maxdepth 1|xargs -I % echo -e "sh -c 'cd % && git pull'"

run-binary:
	@make meson-binaries | fzf --reverse | xargs -I % sh -xc "./%" 
meson-tests-list:
	@meson test -C build --list
meson-tests:
	@make meson-tests-list|fzf --reverse -m | xargs -I % env cmd="\
		meson test --num-processes 1 -C build -v --no-stdsplit --print-errorlogs \"%\"" \
			env bash -c '\
	passh "$$cmd" && \
	ansi -n --green --bold "OK" && \
	echo -n "> " && \
	ansi -n --yellow --italic "$$cmd" && \
	echo \
'	
