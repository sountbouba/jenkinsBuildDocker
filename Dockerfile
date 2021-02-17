FROM ngnix:latest

RUN sed -i 's/nginx/bouba/g' /usr/share/nginx/html/index.html
EXPOSE 80

