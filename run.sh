#!/bin/bash
docker run --rm --name myiris -h myiris -p 51773:51773 -p 52773:52773 \
       wolfman0719/faq:demo
