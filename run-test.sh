#!/usr/bin/env bash

docker run --rm -it \
    -v /home/ozlevka/tmp/fluent-bit-config:/config \
    -v /home/ozlevka/tmp/fluent-bit-config/test:/output \
    -v /home/ozlevka/tmp/logs:/logs \
    -v /home/ozlevka/tmp/fluent-bit-config/script:/script \
    securebrowsing/es-fluent-bit:latest /fluent-bit/bin/fluent-bit --plugin /fluent-bit/bin/out_syslog.so --config /config/default.conf