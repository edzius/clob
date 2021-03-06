.PHONY: install

MD=mkdir -p
IC=install -m644
IE=install -m755

BASH_COMPLETION_DIR=~/.bash_completion.d
USER_BIN_DIR=~/bin

all:

install: git-completion xcp ssh-id xkcdpw imgscale

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

.PHONY: ssh-id
ssh-id:
	$(MD) $(USER_BIN_DIR)
	$(IE) ssh-copy-id-dropbear.sh $(USER_BIN_DIR)/ssh-copy-id-dropbear

.PHONY: xkcdpw
xkcdpw:
	$(MD) $(USER_BIN_DIR)
	$(IE) xkcdpw.js $(USER_BIN_DIR)/xkcdpw

.PHONY: imgscale
imgscale:
	$(MD) $(USER_BIN_DIR)
	$(IE) imgscale.sh $(USER_BIN_DIR)/imgscale
