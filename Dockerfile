FROM kong:0.9.7

COPY insighter-nginx.conf /etc/kong/insighter-nginx.conf
COPY nginx/default.crt /usr/local/kong/ssl/default.crt
COPY nginx/default.key /usr/local/kong/ssl/default.key
#COPY add_apis.sh /add_apis.sh
#COPY dev.env /dev.env
#COPY docker-entrypoint.sh /docker-entrypoint.sh


#ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["kong", "start", "-vv", "--nginx-conf", "/etc/kong/insighter-nginx.conf" ]
# CMD ["kong", "migrations", "up"]
# CMD ["kong", "start", "-vv"]


# FROM kong

# COPY nginx_kong.template /etc/kong/nginx_kong.template
# COPY nginx/default.crt /usr/local/kong/ssl/default.crt
# COPY nginx/default.key /usr/local/kong/ssl/default.key
# #COPY add_apis.sh /add_apis.sh
# #COPY dev.env /dev.env
# #COPY docker-entrypoint.sh /docker-entrypoint.sh


# #ENTRYPOINT ["/docker-entrypoint.sh"]

# CMD ["kong", "start", "-vv" ]
