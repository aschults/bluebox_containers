# Basic Squid Docker image

Configuration by conf.d structure:

All files in /etc/squid/conf.d are included in config
(see also [Squid ConfigIncludes](http://wiki.squid-cache.org/Features/ConfigIncludes).

Files can additionally be set up to generate or filter configuration content
based on a comment in the first line:
  * `#! /some/command`: The filename is put as first arg and the command
    is executed (shebang).
  * `#| /some/command`: File is piped into the command. For environment
    variable expansion use `#| envsubst` (see [docs](https://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html)
  * An other first line: Just copies the file

