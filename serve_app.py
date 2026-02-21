#!/usr/bin/env python3
import http.server
import socketserver
import os
import webbrowser
from pathlib import Path

PORT = 8080
DIRECTORY = "neo_bank_flutter/build/web"

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)
    
    def end_headers(self):
        self.send_header('Cross-Origin-Embedder-Policy', 'require-corp')
        self.send_header('Cross-Origin-Opener-Policy', 'same-origin')
        super().end_headers()

if __name__ == "__main__":
    web_dir = Path(DIRECTORY)
    if not web_dir.exists():
        print(f"❌ Build directory not found: {DIRECTORY}")
        print("⏳ Flutter is still building...")
        exit(1)
    
    print(f"🚀 Serving Neo Bank app at http://localhost:{PORT}")
    print(f"📂 Directory: {DIRECTORY}")
    print("🛑 Press Ctrl+C to stop")
    
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n👋 Server stopped")