-- Table des utilisateurs
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT UNIQUE NOT NULL
);

-- Table des programmes de sport
CREATE TABLE programs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    name TEXT NOT NULL,
    duration_days INTEGER,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Table des jours de chaque programme
CREATE TABLE days (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    program_id INTEGER,
    day_number INTEGER,
    date TEXT NOT NULL,
    FOREIGN KEY (program_id) REFERENCES programs(id)
);

-- Table des séances de sport
CREATE TABLE sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    title TEXT NOT NULL,
    description TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Table pour associer les séances aux jours du programme
CREATE TABLE program_sessions (
    program_id INTEGER,
    day_id INTEGER,
    session_id INTEGER,
    FOREIGN KEY (program_id) REFERENCES programs(id),
    FOREIGN KEY (day_id) REFERENCES days(id),
    FOREIGN KEY (session_id) REFERENCES sessions(id),
    PRIMARY KEY (program_id, day_id)
);

-- Table des exercices
CREATE TABLE exercises (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
);

-- Table pour associer des exercices aux séances
CREATE TABLE session_exercises (
    session_id INTEGER,
    exercise_id INTEGER,
    FOREIGN KEY (session_id) REFERENCES sessions(id),
    FOREIGN KEY (exercise_id) REFERENCES exercises(id),
    PRIMARY KEY (session_id, exercise_id)
);
