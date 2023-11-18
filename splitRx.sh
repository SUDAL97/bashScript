#!/bin/sh

show_help() {
    echo "Usage: $0 [required_argument] [-o optional_argument] [-h]"
    echo "  -o optional_argument   Specify the second optional input argument"
    echo "  -h                     Display this help message"
    exit 0
}

while getopts ":o:h" opt; do
    case $opt in
        o)
            output="$OPTARG"
            ;;
        h)
            show_help
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

# 필수 입력 인자 확인
shift $((OPTIND - 1))
if [ $# -lt 1 ]; then
    echo "Usage: $0 [required_argument] [-o optional_argument] [-h]"
    exit 1
fi
input=$1

if [ -z ${output} ]; then
    output=output
fi

numLine=$(head -1 $input | wc -w)

for (( rx=1; rx * 2 <= $numLine; rx++ )); do
    start=$(($rx * 2 - 1))
    end=$(($start + 1))
    cut -f $start-$end -d ' ' $input > "$output-rx$rx.txt"
done