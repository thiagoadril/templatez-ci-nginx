FROM nginx:1.17.9-alpine AS Nginx

WORKDIR /app

COPY /deploy/nginx/nginx.conf /etc/nginx/nginx.conf

#RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Brazil/East /etc/localtime

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]