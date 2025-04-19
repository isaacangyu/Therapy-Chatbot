#!/usr/bin/env python3

from http.server import HTTPServer, SimpleHTTPRequestHandler
import sys

PORT = 5000

class CustomHTTPRequestHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Cache-Control")
        SimpleHTTPRequestHandler.end_headers(self)

    def do_OPTIONS(self):
        self.send_response(200)
        self.end_headers()

with HTTPServer(("", PORT), CustomHTTPRequestHandler) as httpd:
    try:
        print(f"Serving on http://localhost:{PORT}")
        httpd.serve_forever()
    finally:
        sys.exit(0)
