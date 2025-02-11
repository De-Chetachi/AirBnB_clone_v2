#!/usr/bin/python3
'''this module is a script that starts a flask web application'''


from models import storage
from models.state import State
# import the Flask class
from flask import Flask
from flask import render_template
# create an instance of the class
app = Flask(__name__)
# app.jinja_env.lstrip_blocks = True
# app.jinja_env.trim_blocks = True
'''this module is a script that starts a flask web application'''


@app.teardown_appcontext
def teardown(exception):
    '''close session after each request to avoid complication with sess mnt'''
    storage.close()


@app.route("/states_list", strict_slashes=False)
def states_list_route():
    '''handles the app logic for the root query (/states_list)'''
    storage.reload()
    states = storage.all("State")
    result = {}
    for key, value in states.items():
        result["{}".format(value.id)] = value.name
    return render_template('7-states_list.html', states=result)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
