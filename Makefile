all: build-function .terraform-init deploy

.terraform-init:
	terraform -chdir=infrastructure init
build-function:
	- npm --prefix email_sender_faas install
	- npm --prefix email_sender_faas run build
deploy:
	- terraform -chdir=infrastructure apply -auto-approve
clean:
	- terraform -chdir=infrastructure destroy -auto-approve
