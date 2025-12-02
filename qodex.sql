/* =======================================================
QODEX PROJECT - BASE TEMPLATE
======================================================= */

-- 1) CREATE DATABASE 
CREATE DATABASE qodex;

-- 2) USE DATABASE
USE qodex;

/* 3) TABLES CREATION
======================================================= */

-- TABLE 1: UTILISATEURS (teachers + students)
CREATE TABLE Utilisateurs (
    id_utilisateur INT PRIMARY KEY AUTO_INCREMENT,
    nom            VARCHAR(100) NOT NULL,
    email          VARCHAR(100) NOT NULL UNIQUE,
    motdepasse     VARCHAR(255) NOT NULL,
    user_role      VARCHAR(20) NOT NULL,
    CHECK (user_role IN ('enseignant', 'etudiant'))
);

-- TABLE 2: CATEGORIES
CREATE TABLE Categories (
    id_categorie  INT PRIMARY KEY AUTO_INCREMENT,
    nom_categorie VARCHAR(100) NOT NULL
);

-- TABLE 3: QUIZ
CREATE TABLE Quiz (
    id_quiz       INT PRIMARY KEY AUTO_INCREMENT,
    titre_quiz    VARCHAR(150) NOT NULL,
    descriptions  TEXT,
    id_categorie  INT,
    id_enseignant INT,
    duree_minutes INT NOT NULL,
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT quiz_categorie
        FOREIGN KEY (id_categorie)
        REFERENCES Categories(id_categorie),

    CONSTRAINT quiz_enseignant
        FOREIGN KEY (id_enseignant)
        REFERENCES Utilisateurs(id_utilisateur)
);

-- TABLE 4: QUESTIONS
CREATE TABLE Questions (
    id_question      INT PRIMARY KEY AUTO_INCREMENT,
    texte_question   TEXT NOT NULL,
    reponse_correcte TEXT NOT NULL,
    points           INT NOT NULL,
    id_quiz          INT NOT NULL,

    CONSTRAINT question_quiz
        FOREIGN KEY (id_quiz)
        REFERENCES Quiz(id_quiz)
);

-- TABLE 5: RESULTS
CREATE TABLE Results (
    id_resultat  INT PRIMARY KEY AUTO_INCREMENT,
    score        INT NOT NULL,
    date_passage DATETIME NOT NULL,
    id_etudiant  INT NOT NULL,
    id_quiz      INT NOT NULL,

    CONSTRAINT result_etudiant
        FOREIGN KEY (id_etudiant)
        REFERENCES Utilisateurs(id_utilisateur),

    CONSTRAINT result_quiz
        FOREIGN KEY (id_quiz)
        REFERENCES Quiz(id_quiz)
);

-- INDEXES
CREATE INDEX idx_quiz_categorie     ON Quiz(id_categorie);
CREATE INDEX idx_quiz_enseignant    ON Quiz(id_enseignant);
CREATE INDEX idx_questions_quiz     ON Questions(id_quiz);
CREATE INDEX idx_results_etudiant   ON Results(id_etudiant);
CREATE INDEX idx_results_quiz       ON Results(id_quiz);
CREATE INDEX idx_results_date       ON Results(date_passage);
CREATE INDEX idx_results_score      ON Results(score);
CREATE INDEX idx_quiz_titre         ON Quiz(titre_quiz);

-- CHECK CONSTRAINTS
ALTER TABLE Quiz
  ADD CONSTRAINT chk_duree_positive CHECK (duree_minutes > 0);

ALTER TABLE Questions
  ADD CONSTRAINT chk_points_positive CHECK (points > 0);

ALTER TABLE Results
  ADD CONSTRAINT chk_score_range CHECK (score BETWEEN 0 AND 100);

-- INSERT INTO CATEGORIES
INSERT INTO Categories (nom_categorie)
VALUES ('Informatique'),
       ('Mathématiques'),
       ('Histoire');

-- INSERT INTO UTILISATEURS (1 teacher + 2 students)
INSERT INTO Utilisateurs (nom, email, motdepasse, user_role)
VALUES ('Prof Ali', 'ali@example.com', SHA2('1234', 256), 'enseignant'),
       ('Sara', 'sara@example.com', SHA2('1234', 256), 'etudiant'),
       ('Yassine', 'yassine@example.com', SHA2('1234', 256), 'etudiant');

-- INSERT INTO QUIZ 
INSERT INTO Quiz (titre_quiz, descriptions, id_categorie, id_enseignant, duree_minutes)
VALUES ('Quiz SQL', 'Introduction aux bases de SQL', 1, 1, 30),
       ('Quiz Math', 'Révision des équations simples', 2, 1, 45);

-- INSERT INTO QUESTIONS (id_quiz must exist in Quiz)
INSERT INTO Questions (texte_question, reponse_correcte, points, id_quiz)
VALUES ('Que signifie SQL ?', 'Structured Query Language', 10, 1),
       ('2 + 2 = ?', '4', 5, 2),
       ('3 + 5 = ?', '8', 5, 2);

-- INSERT INTO RESULTS
INSERT INTO Results (score, date_passage, id_etudiant, id_quiz)
VALUES (80, NOW(), 2, 1),
       (60, NOW(), 3, 1),
       (90, NOW(), 2, 2),
       (40, NOW(), 3, 2);

/* =======================================================
5) 23 QUERIES
======================================================= */

-- QUERY 1 : Add a new quiz created by a teacher
INSERT INTO quiz (titre_quiz, descriptions, id_categorie, id_enseignant, duree_minutes)
VALUES ('Quiz SQL', 'Introduction aux bases de SQL', 1, 1, 30);

-- QUERY 2 : Modify the duration of an existing quiz
UPDATE quiz
SET duree_minutes = 10
WHERE id_quiz = 1;

-- QUERY 3 : Show all users
SELECT * FROM utilisateurs;

-- QUERY 4 : Show only names and emails of users
SELECT nom, email
FROM utilisateurs;

-- QUERY 5 : Show all quizzes
SELECT * FROM quiz;

-- QUERY 6 : Show only titles of all quizzes
SELECT titre_quiz
FROM quiz;

-- QUERY 7 : Show all categories
SELECT * FROM categories;

-- QUERY 8 : Show users who are teachers
SELECT *
FROM utilisateurs
WHERE user_role = 'enseignant';

-- QUERY 9 : Show users who are students
SELECT *
FROM utilisateurs
WHERE user_role = 'etudiant';

-- QUERY 10 : Show quizzes with duration > 30 minutes
SELECT *
FROM quiz
WHERE duree_minutes > 30;

-- QUERY 11 : Show quizzes with duration <= 45 minutes
SELECT *
FROM quiz
WHERE duree_minutes <= 45;

-- QUERY 12 : Show questions worth more than 5 points
SELECT *
FROM questions
WHERE points > 5;

-- QUERY 13 : Show quizzes with duration between 20 and 40 minutes
SELECT *
FROM quiz
WHERE duree_minutes BETWEEN 20 AND 40;

-- QUERY 14 : Show results with score >= 60
SELECT *
FROM Results
WHERE score >= 60;

-- QUERY 15 : Show results with score < 50
SELECT *
FROM Results
WHERE score < 50;

-- QUERY 16 : Show questions worth between 5 and 15 points
SELECT *
FROM questions
WHERE points BETWEEN 5 AND 15;

-- QUERY 17 : Show quizzes created by teacher with id = 1
SELECT *
FROM quiz
WHERE id_enseignant = 1;

-- QUERY 18 : Show all quizzes sorted by duration (ASC)
SELECT *
FROM quiz
ORDER BY duree_minutes ASC;

-- QUERY 19 : Show all results sorted by score (DESC)
SELECT *
FROM Results
ORDER BY score DESC;

-- QUERY 20 : Show the 5 best scores
SELECT *
FROM Results
ORDER BY score DESC
LIMIT 5;

-- QUERY 21 : Show questions sorted by points (ASC)
SELECT *
FROM questions
ORDER BY points ASC;

-- QUERY 22 : Show the 3 latest results (DESC by date)
SELECT *
FROM Results
ORDER BY date_passage DESC
LIMIT 3;

-- QUERY 23 : Show the name of each quiz with its category
SELECT quiz.titre_quiz, categories.nom_categorie
FROM quiz
JOIN categories
ON quiz.id_categorie = categories.id_categorie;
