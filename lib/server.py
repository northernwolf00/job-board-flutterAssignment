
from flask import Flask, request, jsonify
import pdfplumber
import re
import os

app = Flask(__name__)

def extract_info_from_pdf(file_path):
    text = ""
    with pdfplumber.open(file_path) as pdf:
        for page in pdf.pages:
            text += page.extract_text() + "\n"

    email_regex = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b'
    phone_regex = r'(\+?\d{1,3}[-.\s]?)?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}'

    email_match = re.search(email_regex, text)
    phone_match = re.search(phone_regex, text)

    name = None
    for line in text.split("\n"):
        line = line.strip()
        if line and not any(c.isdigit() for c in line) and '@' not in line:
            name = line
            break

    return {
        "name": name,
        "email": email_match.group(0) if email_match else None,
        "phone": phone_match.group(0) if phone_match else None
    }

@app.route('/parse_cv', methods=['POST'])
def parse_cv():
    if 'file' not in request.files:
        return jsonify({"error": "No file provided"}), 400
    file = request.files['file']
    file_path = os.path.join("/tmp", file.filename)
    file.save(file_path)

    info = extract_info_from_pdf(file_path)
    os.remove(file_path)
    return jsonify(info)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5001)
