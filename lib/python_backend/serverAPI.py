import flask
import pandas as pd
from flask import jsonify, request
import recommender.HybridRecommender as hr

app = flask.Flask(__name__)

@app.route("/login", methods=["GET"])
def login():
    userId = request.args.get("userId")
    ids = pd.read_csv('recommender/ratings.csv')
    ids = ids['user'].unique()

    if userId in ids:
        return True
    return False




if __name__ == "__main__":
    app.run(debug= True, host="0.0.0.0", port=5000)