from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({"message": "Welcome to the Basic Math API! Use /add, /subtract, /multiply, /divide endpoints."})

@app.route('/add', methods=['GET'])
def add():
    try:
        a = float(request.args.get('a'))
        b = float(request.args.get('b'))
        result = a + b
        return jsonify({"operation": "addition", "a": a, "b": b, "result": result})
    except (TypeError, ValueError):
        return jsonify({"error": "Please provide valid numbers as query parameters a and b"}), 400

@app.route('/subtract', methods=['GET'])
def subtract():
    try:
        a = float(request.args.get('a'))
        b = float(request.args.get('b'))
        result = a - b
        return jsonify({"operation": "subtraction", "a": a, "b": b, "result": result})
    except (TypeError, ValueError):
        return jsonify({"error": "Please provide valid numbers as query parameters a and b"}), 400

@app.route('/multiply', methods=['GET'])
def multiply():
    try:
        a = float(request.args.get('a'))
        b = float(request.args.get('b'))
        result = a * b
        return jsonify({"operation": "multiplication", "a": a, "b": b, "result": result})
    except (TypeError, ValueError):
        return jsonify({"error": "Please provide valid numbers as query parameters a and b"}), 400

@app.route('/divide', methods=['GET'])
def divide():
    try:
        a = float(request.args.get('a'))
        b = float(request.args.get('b'))
        if b == 0:
            return jsonify({"error": "Division by zero is not allowed"}), 400
        result = a / b
        return jsonify({"operation": "division", "a": a, "b": b, "result": result})
    except (TypeError, ValueError):
        return jsonify({"error": "Please provide valid numbers as query parameters a and b"}), 400

if __name__ == '__main__':
    app.run(debug=True)
