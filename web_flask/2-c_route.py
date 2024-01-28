#!/usr/bin/python3
'''this module is a script that starts a flask web application'''

# import the Flask class
from flask import Flask


# create an instance of the class
app = Flask(__name__)

# use the route decorator to tell flask which url(path) should use the root fxn
@app.route("/", strict_slashes=False)
def root():
    '''handles the app logic for the root query (/)'''

    return "Hello HBNB!"


@app.route("/hbnb", strict_slashes=False)
def hbnb():
    '''handles app logic for /hbnb query'''

    return "HBNB"


@app.route("/c/<text>", strict_slashes=False)
def c_is_fun(text):
    '''handles app logic for /c/<text> query'''
    # new_text = text.replace("_", " ")
    return f'C {text.replace("_", " ")}'


if __name__ == "__main__":
    app.run()
