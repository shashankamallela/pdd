import sqlite3
from pathlib import Path
import json
from uuid import uuid4

from flask import Flask, jsonify, request, send_from_directory, url_for
from flask_cors import CORS
from werkzeug.utils import secure_filename

app = Flask(__name__)
CORS(app)

DATABASE_PATH = Path(__file__).with_name('users.db')
VIDEOS_JSON_PATH = Path(__file__).with_name('videos.json')
UPLOADS_PATH = Path(__file__).with_name('uploads')
ALLOWED_IMAGE_EXTENSIONS = {'jpg', 'jpeg', 'png', 'webp'}


def get_connection():
    connection = sqlite3.connect(DATABASE_PATH)
    connection.row_factory = sqlite3.Row
    return connection


def load_videos_seed():
    try:
        with open(VIDEOS_JSON_PATH, 'r', encoding='utf-8') as fh:
            return json.load(fh)
    except Exception as e:
        print('LOAD VIDEO SEED ERROR:', e)
        return []


def seed_videos():
    raw = load_videos_seed()
    if not raw:
        return

    with get_connection() as connection:
        connection.execute('DELETE FROM videos')
        connection.executemany(
            'INSERT INTO videos (id, title, description, file, thumbnail) VALUES (?, ?, ?, ?, ?)',
            [
                (
                    video.get('id'),
                    video.get('title'),
                    video.get('description'),
                    video.get('file'),
                    video.get('thumbnail'),
                )
                for video in raw
            ]
        )
        connection.commit()


def init_database():
    with get_connection() as connection:
        connection.execute(
            '''
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                email TEXT NOT NULL UNIQUE,
                password TEXT NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
            '''
        )
        connection.execute(
            '''
            CREATE TABLE IF NOT EXISTS videos (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                description TEXT,
                file TEXT NOT NULL,
                thumbnail TEXT
            )
            '''
        )
        connection.execute(
            '''
            CREATE TABLE IF NOT EXISTS profiles (
                email TEXT PRIMARY KEY,
                name TEXT NOT NULL,
                age TEXT,
                gender TEXT,
                height TEXT,
                weight TEXT,
                food_preference TEXT,
                dental_issues TEXT,
                water_goal TEXT,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY(email) REFERENCES users(email)
            )
            '''
        )
        connection.commit()


init_database()
seed_videos()
UPLOADS_PATH.mkdir(exist_ok=True)


def allowed_image(filename):
    return (
        '.' in filename
        and filename.rsplit('.', 1)[1].lower() in ALLOWED_IMAGE_EXTENSIONS
    )


def save_uploaded_image(image_file):
    original_name = secure_filename(image_file.filename or 'food_image.jpg')

    if not allowed_image(original_name):
        raise ValueError('Only JPG, PNG, and WEBP images are allowed')

    extension = original_name.rsplit('.', 1)[1].lower()
    saved_name = f'{uuid4().hex}.{extension}'
    saved_path = UPLOADS_PATH / saved_name
    image_file.save(saved_path)

    return saved_path, saved_name


@app.route('/', methods=['GET'])
def index():
    return jsonify({
        'success': True,
        'message': 'Backend connected',
        'endpoints': [
            '/health',
            '/signup',
            '/login',
            '/reset-password',
            '/profile',
            '/predict',
            '/videos',
        ],
    })


@app.route('/health', methods=['GET'])
def health():
    return jsonify({
        'success': True,
        'status': 'ok',
    })


def get_videos_with_urls():
    videos = []
    with get_connection() as connection:
        rows = connection.execute(
            'SELECT id, title, description, file, thumbnail FROM videos ORDER BY id'
        ).fetchall()

        for row in rows:
            thumb = row['thumbnail']
            thumb_path = Path(__file__).with_name('static').joinpath(thumb) if thumb else None
            if not thumb_path or not thumb_path.exists():
                thumb_url = url_for('static', filename='thumbs/default.svg', _external=True)
            else:
                thumb_url = url_for('static', filename=thumb, _external=True)

            videos.append({
                'id': row['id'],
                'title': row['title'],
                'description': row['description'],
                'file': row['file'],
                'thumbnail': thumb_url
            })

    return videos


# SIGNUP API
@app.route('/signup', methods=['POST'])
def signup():
    try:
        data = request.json or {}

        name = data.get('name', '').strip()
        email = data.get('email', '').strip()
        password = data.get('password', '')

        if not name or not email or not password:
            return jsonify({
                'success': False,
                'message': 'Name, email, and password are required'
            }), 400

        with get_connection() as connection:
            existing_user = connection.execute(
                'SELECT id FROM users WHERE email = ?',
                (email,),
            ).fetchone()

            if existing_user:
                return jsonify({
                    'success': False,
                    'message': 'Account already exists'
                }), 409

            connection.execute(
                'INSERT INTO users (name, email, password) VALUES (?, ?, ?)',
                (name, email, password),
            )
            connection.commit()

        print('SIGNUP SUCCESS:', email)

        return jsonify({
            'success': True,
            'message': 'Account created successfully'
        })

    except Exception as e:
        print('SIGNUP ERROR:', e)

        return jsonify({
            'success': False,
            'message': str(e)
        }), 500


# LOGIN API
@app.route('/login', methods=['POST'])
def login():
    try:
        data = request.json or {}

        email = data.get('email', '').strip()
        password = data.get('password', '')

        with get_connection() as connection:
            user = connection.execute(
                '''
                SELECT users.password, profiles.email AS profile_email
                FROM users
                LEFT JOIN profiles ON profiles.email = users.email
                WHERE users.email = ?
                ''',
                (email,),
            ).fetchone()

        if user and user['password'] == password:
            print('LOGIN SUCCESS:', email)

            return jsonify({
                'success': True,
                'message': 'Login Successful',
                'profile_created': user['profile_email'] is not None
            })

        return jsonify({
            'success': False,
            'message': 'Invalid Credentials'
        }), 401

    except Exception as e:
        print('LOGIN ERROR:', e)

        return jsonify({
            'success': False,
            'message': str(e)
        }), 500


@app.route('/profile', methods=['GET'])
def get_profile():
    try:
        email = request.args.get('email', '').strip()

        if not email:
            return jsonify({
                'success': False,
                'message': 'Email is required'
            }), 400

        with get_connection() as connection:
            profile = connection.execute(
                '''
                SELECT email, name, age, gender, height, weight,
                       food_preference, dental_issues, water_goal
                FROM profiles
                WHERE email = ?
                ''',
                (email,),
            ).fetchone()

        if not profile:
            return jsonify({
                'success': True,
                'profile_created': False,
                'profile': None
            })

        return jsonify({
            'success': True,
            'profile_created': True,
            'profile': dict(profile)
        })

    except Exception as e:
        print('GET PROFILE ERROR:', e)

        return jsonify({
            'success': False,
            'message': str(e)
        }), 500


@app.route('/profile', methods=['POST'])
def save_profile():
    try:
        data = request.json or {}

        email = data.get('email', '').strip()
        name = data.get('name', '').strip()

        if not email or not name:
            return jsonify({
                'success': False,
                'message': 'Email and name are required'
            }), 400

        with get_connection() as connection:
            user = connection.execute(
                'SELECT id FROM users WHERE email = ?',
                (email,),
            ).fetchone()

            if not user:
                return jsonify({
                    'success': False,
                    'message': 'Account not found'
                }), 404

            connection.execute(
                '''
                INSERT INTO profiles (
                    email, name, age, gender, height, weight,
                    food_preference, dental_issues, water_goal, updated_at
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
                ON CONFLICT(email) DO UPDATE SET
                    name = excluded.name,
                    age = excluded.age,
                    gender = excluded.gender,
                    height = excluded.height,
                    weight = excluded.weight,
                    food_preference = excluded.food_preference,
                    dental_issues = excluded.dental_issues,
                    water_goal = excluded.water_goal,
                    updated_at = CURRENT_TIMESTAMP
                ''',
                (
                    email,
                    name,
                    data.get('age', '').strip(),
                    data.get('gender', '').strip(),
                    data.get('height', '').strip(),
                    data.get('weight', '').strip(),
                    data.get('food_preference', '').strip(),
                    data.get('dental_issues', '').strip(),
                    data.get('water_goal', '').strip(),
                ),
            )
            connection.commit()

        return jsonify({
            'success': True,
            'message': 'Profile saved successfully',
            'profile_created': True
        })

    except Exception as e:
        print('SAVE PROFILE ERROR:', e)

        return jsonify({
            'success': False,
            'message': str(e)
        }), 500


# RESET PASSWORD API
@app.route('/reset-password', methods=['POST'])
def reset_password():
    try:
        data = request.json or {}

        email = data.get('email', '').strip()
        password = data.get('password', '')

        if not email or not password:
            return jsonify({
                'success': False,
                'message': 'Email and password are required'
            }), 400

        with get_connection() as connection:
            user = connection.execute(
                'SELECT id FROM users WHERE email = ?',
                (email,),
            ).fetchone()

            if not user:
                return jsonify({
                    'success': False,
                    'message': 'Account not found'
                }), 404

            connection.execute(
                'UPDATE users SET password = ? WHERE email = ?',
                (password, email),
            )
            connection.commit()

        print('PASSWORD RESET:', email)

        return jsonify({
            'success': True,
            'message': 'Password reset successfully'
        })

    except Exception as e:
        print('RESET PASSWORD ERROR:', e)

        return jsonify({
            'success': False,
            'message': str(e)
        }), 500


# FOOD PREDICTION API
@app.route('/predict', methods=['POST'])
def predict():
    try:
        if 'image' in request.files:
            from food_model import predict_food_image

            saved_path, saved_name = save_uploaded_image(request.files['image'])
            prediction = predict_food_image(saved_path)
            food = prediction['food'].replace('_', ' ').title()

            return jsonify({
                'food': food,
                'confidence': prediction['confidence'],
                'top_predictions': prediction['top_predictions'],
                'image': url_for('uploaded_file', filename=saved_name, _external=True),
                'risk': 'Medium',
                'sugar': 'High',
                'acidity': 'Medium',
                'score': 42
            })

        data = request.json or {}
        food = data.get('food')

        response = {
            'food': food,
            'risk': 'Medium',
            'sugar': 'High',
            'acidity': 'Medium',
            'score': 42
        }

        return jsonify(response)

    except Exception as e:
        print('PREDICT ERROR:', e)

        return jsonify({
            'success': False,
            'message': str(e)
        }), 500


@app.route('/videos', methods=['GET'])
def videos_list():
    try:
        # return an array of videos and logo url
        logo_url = url_for('static', filename='logo.svg', _external=True)
        videos = get_videos_with_urls()

        return jsonify({
            'videos': videos,
            'logo': logo_url
        })
    except Exception as e:
        print('VIDEOS ERROR:', e)
        return jsonify({'success': False, 'message': str(e)}), 500


@app.route('/uploads/<path:filename>', methods=['GET'])
def uploaded_file(filename):
    return send_from_directory(UPLOADS_PATH, filename)


if __name__ == '__main__':
    app.run(
        host='0.0.0.0',
        port=5000,
        debug=True
    )
