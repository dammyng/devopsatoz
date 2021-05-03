from flask import Flask, jsonify, request
import random
import string

app = Flask(__name__)

urls = {}

@app.route('/shorten', methods=['POST'])
def shorten_url():
    data = request.get_json()
    url = data['url']
    key = ''.join(random.choices(string.ascii_letters + string.digits, k=6))
    urls[key] = url
    return jsonify({'key': key})

@app.route('/<key>')
def redirect_url(key):
    return jsonify({'url': urls[key]}), 302

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
