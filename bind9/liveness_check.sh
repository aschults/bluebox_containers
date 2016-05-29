#!/bin/sh

dig @localhost -t TXT keepalive-test.localhost. +time=2 | grep here-i-am
