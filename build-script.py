#!/usr/bin/python
import os
import re
import sys


EMIT = 1
READ_INCLUDE = 2


include_re = re.compile('^#begin_include\("([^"]+)"\)$', re.I)
end_include_re = re.compile('#end_include\(\)', re.I)


def build_script(script_path, base_path):
    lines = []
    with open(script_path, "r+") as f:
        for line in process_lines(f, base_path):
            lines.append(line)

    with open(script_path, "w+") as f:
        for line in lines:
            f.write(line)


def fatal_error(msg):
    print "ERROR: " + msg
    sys.exit(1)


def main():
    if len(sys.argv) < 2:
        fatal_error("Missing script path")
    
    script_path = sys.argv[1]
    base_path = os.path.dirname(os.path.realpath(__file__))

    build_script(script_path, base_path=base_path)


def process_lines(input, base_path):
    input_state = EMIT
    for input_line in input:
        include_match = include_re.match(input_line)
        if include_match:
            yield input_line

            input_state = READ_INCLUDE
            include_path = include_match.group(1)
            for include_line in read_include_file(os.path.join(base_path, include_path)):
                yield include_line

        end_include_match = end_include_re.match(input_line)
        if end_include_match:
            input_state = EMIT

        if input_state == EMIT:
            yield input_line


def read_include_file(path):
    with open(path) as f:
        for line in f:
            yield line


if __name__ == "__main__":
    main()
