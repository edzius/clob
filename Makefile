.PHONY: install

MD=mkdir -p
IC=install -m644
IE=install -m755

BASH_COMPLETION_DIR=~/.bash_completion.d

all:

install: git-completion

.PHONY: bash-completion
bash-completion:
	$(MD) $(BASH_COMPLETION_DIR)
	$(IC) .bash_completion ~/

.PHONY: git-completion
git-completion: bash-completion
	$(IC) git-completion.bash $(BASH_COMPLETION_DIR)
