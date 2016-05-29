FROM aschults/bluebox_squid:bind_latest

# Maximum age of the downloaded blackhole domains (in min)
ENV MAX_LIST_AGE=300
# IP to use for blackholed domains
ENV BLACKHOLE_IP=127.0.0.1


ADD conf /etc/bind
