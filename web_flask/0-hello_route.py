#!/usr/bin/python3
'''this module is a script that starts a flask web application'''
#import the Flask class 
from flask import Flask

#create an instance of the class
app = Flask(__name__)

#use the route decorator to tell flask which url(path) should trigger the root function
@app.route("/", strict_slashes=False)
def root():
    '''handles the app logic for the root query (/)'''
    return "Hello HBNB!"


if __name__ == "__main__":
    app.run()
