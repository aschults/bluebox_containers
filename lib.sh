# Utility functions

set -e

# Command based generation or filtering for config files
# Usage: expand_conf /dir/to/originals /dir/for/generated/config

expand_conf() {
  confdir=$1
  conf_gen=$2

	for fn in $confdir/*.conf ; do
		read bang < $fn
                fn2=`basename $fn`
		case $bang in
		\#\!*)
			 cmd="${bang#\#\!}"
			 eval "$cmd $fn" >$conf_gen/$fn2
			 ;;
		\#\|*)
			 cmd="${bang#\#\|}"
			 eval "cat $fn |$cmd" >$conf_gen/$fn2
			 ;;
		*)
			 cp $fn $conf_gen/$fn2
			 ;;
		esac
	done
}
