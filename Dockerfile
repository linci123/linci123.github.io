FROM docker.io/library/nginx:latest
MAINTAINER liruilong
ADD ./public/  /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g","daemon off;"]
