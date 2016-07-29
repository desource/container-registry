FROM scratch

ADD bin/registry   /bin/registry
ADD etc/registry.yml /etc/registry.yml

VOLUME /data

EXPOSE 5000

ENTRYPOINT ["/bin/registry"]

CMD ["/etc/registry.yml"]
