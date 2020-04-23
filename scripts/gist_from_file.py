#!/usr/bin/env python3
import argparse
import json


def transform_file(filename, *args, **kwargs):
    f = open(filename, 'r')

    data = {
        'files': {
            'Brewfile': {
                'content': f.read()
            }
        }
    }

    f.close()
    return json.dumps(data)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--filename', type=str, default='/tmp/Brewfile')
    args = parser.parse_args()
    json_data = transform_file(args.filename)
    print(json_data)
