#!/usr/bin/python3
'''this module is a script that starts a flask web application'''

# import the Flask class
from flask import Flask
from flask import render_template


# create an instance of the class
app = Flask(__name__)


# use the route decorator to tell flask which url(path) should use the root fxn
@app.route("/", strict_slashes=False)
def root_route():
    '''handles the app logic for the root query (/)'''

    return "Hello HBNB!"


@app.route("/hbnb", strict_slashes=False)
def hbnb_route():
    '''handles app logic for /hbnb query'''

    return "HBNB"


@app.route("/c/<text>", strict_slashes=False)
def c_route(text):
    '''handles app logic for /c/<text> query'''
    # new_text = text.replace("_", " ")
    return f'C {text.replace("_", " ")}'


@app.route("/python", strict_slashes=False)
@app.route("/python/<text>", strict_slashes=False)
def python_route(text='is cool'):
    '''handles app logic for /python/<text> query'''
    return f'Python {text.replace("_", " ")}'


@app.route("/number/<int:n>", strict_slashes=False)
def number_route(n):
    '''handles app logic for /number'''
    return f'{n} is a number'

@app.route("/number_template/<int:n>", strict_slashes=False)
def number_template_route(n):
    '''handles app logic for /number_template/<n>'''
    return render_template('5-number.html', n=n)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
