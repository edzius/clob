#!/usr/bin/env bash

img_list_dir()
{
	local target_dir
	local target_files

	target_dir=$1
	[ ! -d "$target_dir" ] && echo "No target dir: $target_dir" && return 1
	[ -z "$OP_RECURSE" ] && target_ops="-maxdepth 1"

	find $target_dir $target_ops -type f -exec ls -dgG {} \; | awk '{ printf "%-64s %+16s kb\n", $7, $3 / 1000; sum += $3 } END { print "Total size: " sum / 1000000 " Mb" }'
}

img_scale_dir()
{
	local output_dir
	local scale_ops
	local target_ops
	local target_dir
	local target_files
	local target_name

	case "$IMG_SCALE" in
		*%) scale_ops="-resize $IMG_SCALE";;
		*x*) scale_ops="-resize $IMG_SCALE";;
		*) usage "Unknown scale method";;
	esac

	target_dir=$1
	[ ! -d "$target_dir" ] && echo "No target dir: $target_dir" && return 1
	[ -z "$OP_RECURSE" ] && target_ops="-maxdepth 1"
	target_files=`find ${target_dir} ${target_ops} -type f -iname '*.jpg' -o -iname '*.png'`
	[ -z "$target_files" ] && echo "No images in target dir: $target_dir" && return 1

	[ -n "$OP_VERBOSE" ] && echo "Initial images:" && img_list_dir $target_dir

	output_dir=$target_dir
	if [ -z "$IMG_UPDATE" ]; then
		output_dir=$target_dir/resized
		mkdir -p $output_dir
	fi

	[ -n "$OP_VERBOSE" ] && echo "Converting images:"
	for target_path in $target_files; do
		output_name=`basename $target_path`
		#For more info see tools usage online:
		#http://www.imagemagick.org/Usage/resize/
		if [ -n "$DRY_RUN" ]; then
			echo convert $target_path -verbose "$scale_ops" $output_dir/$output_name
		else
			convert $target_path -verbose $scale_ops $output_dir/$output_name
		fi

	done

	[ -n "$OP_VERBOSE" ] && echo "Resized images:" && img_list_dir $output_dir
}

usage()
{
	[ -n "$1" ] && echo $1;
	echo "Usage: $0 [options] dirA ..."
	echo "  -s <scale>       proportional scale value (e.g. 20% or 500x300)"
	echo "  -u               update original files"
	echo "  -r               recuse lookup"
	echo "  -f               force operation"
	echo "  -v               verbose operation"
	echo "  -h               show usage"
	[ -n "$1" ] && exit 1 || exit 0
}

##
# IMG scale functions:
# - Resize images with provided scale
# - Resize images recursively
# - Rewrite existing images
##

while getopts s:urfvdh OPT; do
	case "$OPT" in
		s) IMG_SCALE=$OPTARG;;
		u) IMG_UPDATE=1;;
		r) OP_RECURSE=1;;
		f) OP_FORCE=1;;
		v) OP_VERBOSE=1;;
		h) usage;;
		:) usage "option - $OPTARG missing argument";;
		\?) usage "invalid option - $OPTARG";;
		*) usage "unhandled option - $OPT $OPTARG";;
	esac
done

shift $((OPTIND - 1))

TARGETS=$@

[ -z "$TARGETS" ] && usage "No target directories provided"

if [ -n "$IMG_UPDATE" -a -z "$OP_FORCE" ]; then
	read -p "You are about to replace original images. Are you sure? [y/N] " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		echo "Aborted."
		return;
	fi
fi

for target in $TARGETS; do
	if [ -n "$IMG_SCALE" ]; then
		img_scale_dir $target
	else
		img_list_dir $target
	fi
done
