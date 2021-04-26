.PHONY: build, run

build:
	sudo docker build -t ft_server .

run:
	sudo docker run -it -p 80:80 -p 443:443 -e TZ=Europe/Moscow ft_server

# сделать ssl статичным и сдавать
