#! /usr/bin/env python

# Copyright 2020 Data61, CSIRO
# SPDX-License-Identifier: BSD-2-Clause

import sys
from sys import stdin
import requests
import json
from multiprocessing import Pool

from HTMLParser import HTMLParser
from junit_xml import TestSuite, TestCase

AATT_SITE_ENDPOINT = "http://localhost:3000/sniffURL"
JEKYLL_SITE_URL = "http://localhost:4000"


def run_test(page):

    class SimpleHTMLParser(HTMLParser):
        '''
        This pulls out the number of errors which is the data in the span
        with class `result-count-errors`.
        '''
        get_error = False
        num_errors = 0

        def handle_starttag(self, tag, attrs):
            if tag == "span":
                for (key, val) in attrs:
                    if key == "class" and "result-count-errors" in val:
                        self.get_error = True

        def handle_data(self, data):
            if self.get_error:
                self.num_errors = data
                self.get_error = False

        def get_result(self):
            return self.num_errors

    # POST request with url to AATT endpoint
    url = AATT_SITE_ENDPOINT
    headers = {'content-type': 'application/x-www-form-urlencoded'}
    r = requests.post(url, data='engine=htmlcs&msgErr=true&textURL=%s/%s' %
                      (JEKYLL_SITE_URL, page), headers=headers)
    output = json.loads(r.text)

    # Parse result using simple parser to get number of errors.
    parser = SimpleHTMLParser()
    parser.feed(output['data'])
    result = parser.get_result()

    # Put error number into junit TestCase and return to caller.
    tc = TestCase(page, 'some.class.name', 1, output['data'])
    if (parser.get_result() != "0"):
        tc.add_failure_info("Detected %s error(s)." % (parser.get_result()))
    return tc


def main():
    # Read list of html files in from stdin line by line.
    # This is to enable piping result from `find`
    # Use a multiprocessing pool to get some parallelism
    pool = Pool()

    queries = []
    test_cases = []

    for line in sys.stdin:
        queries.append(pool.apply_async(run_test, [line.strip()]))

    for query in queries:
        test_cases.append(query.get(timeout=10))

    # Dump test results to stdout
    ts = [TestSuite("my test suite", test_cases)]
    print(TestSuite.to_xml_string(ts))
    return 0


if __name__ == "__main__":
    main()
