from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def simple_app():
    return "My first app in a container is up and running!"


if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0',port=5000)

