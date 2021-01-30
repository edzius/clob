.PHONY: install

MD=mkdir -p
IC=install -m644
IE=install -m755

BASH_COMPLETION_DIR=~/.bash_completion.d
USER_BIN_DIR=~/bin

all:

install: git-completion xcp

.PHONY: bash-completion
bash-completion:
	$(MD) $(BASH_COMPLETION_DIR)
	$(IC) .bash_completion ~/

.PHONY: git-completion
git-completion: bash-completion
	$(IC) git-completion.bash $(BASH_COMPLETION_DIR)

.PHONY: xcp
xcp: bash-completion
	$(MD) $(USER_BIN_DIR)
	$(IE) xcp.sh $(USER_BIN_DIR)/xcp
	$(IC) xcp-completion.bash $(BASH_COMPLETION_DIR)
