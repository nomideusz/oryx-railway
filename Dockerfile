# Pinned: a silent upstream rebase would hit every deploy of this template at once.
FROM ossrs/oryx:v7.15.26

# The UI shows the RTMP server as rtmp://<the panel's hostname>:<port>, but on Railway
# OBS has to use the TCP proxy, which is a different host. Let both UI builds (en, zh)
# prefer window.ORYX_RTMP_ADDR, which the entrypoint writes into index.html at boot.
RUN for f in /usr/local/oryx/ui/build/*/static/js/main.*.js; do \
      sed -E -i 's/([A-Za-z_$]+)\.rtmpServer="rtmp:\/\/"\.concat\(([A-Za-z_$]+)\)\.concat\(([A-Za-z_$]+),"\/"\)/\1.rtmpServer="rtmp:\/\/".concat(window.ORYX_RTMP_ADDR||\2+\3,"\/")/' "$f" \
      && grep -q 'window.ORYX_RTMP_ADDR' "$f" || exit 1; \
    done

COPY --chmod=0755 railway-entrypoint.sh /railway-entrypoint.sh
CMD ["/railway-entrypoint.sh"]
