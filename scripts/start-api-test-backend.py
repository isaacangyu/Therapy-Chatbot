#!/usr/bin/env python3

from http.server import HTTPServer, SimpleHTTPRequestHandler
import sys

PORT = 5000

class CustomHTTPRequestHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        SimpleHTTPRequestHandler.end_headers(self)

with HTTPServer(("", PORT), CustomHTTPRequestHandler) as httpd:
    try:
        print(f"Serving on http://localhost:{PORT}")
        httpd.serve_forever()
    finally:
        sys.exit(0)
