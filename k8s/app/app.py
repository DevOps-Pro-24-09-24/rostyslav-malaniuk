from flask import Flask, jsonify
import os
import mysql.connector

app = Flask(__name__)

db_config = {
    'host': os.getenv('DB_HOST', 'db'),
    'user': os.getenv('DB_USER', 'root'),
    'password': os.getenv('DB_PASSWORD', 'password'),
    'database': os.getenv('DB_NAME', 'db'),
}


@app.route('/')
def index():
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        cursor.execute("SELECT DATABASE();")
        database_name = cursor.fetchone()[0]
        return jsonify({"message": f"Connected to database '{database_name}'!"}) # noqa
    except mysql.connector.Error as err:
        return jsonify({"error": str(err)}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
