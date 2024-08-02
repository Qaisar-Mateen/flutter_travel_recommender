import flask
import warnings
import pandas as pd
from flask import request
import recommender.HybridRecommender as recommender

warnings.simplefilter(action='ignore', category=DeprecationWarning)

app = flask.Flask(__name__)

@app.route("/login", methods=["GET"])
def login():
    userId = request.args.get("userId")
    if userId is None:
        return {'valid', False}, 400
    
    ids = pd.read_csv('recommender/ratings.csv')
    ids = ids['user'].unique()

    if userId in ids:
        return {"valid", True}
    return {"valid", False}, 400


@app.route("/recommend", methods=["GET"])
def recommend():
    userId = request.args.get("userId")
    if userId is None:
        return "No userId provided", 400
    
    hr = recommender.HybridRecommender(collaborative_model=(True, userId, 'CF_Neural_Model3.7.bin'),
        popularity_model=True, content_model=True,
        popular_weight=0.15, collab_weight=0.7, content_weight=0.15
    )

    recommendations = hr.recommend()
    return recommendations.to_json(orient='records')

if __name__ == "__main__":
    app.run(debug= True, host="0.0.0.0", port=5000)
