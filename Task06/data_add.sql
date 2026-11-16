PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

INSERT INTO users
    (first_name, last_name, email, gender, occupation_id)
VALUES
    ('Максим', 'Цветков', 'maxim13rrus@gmail.com', 'male',
     (SELECT id FROM occupations WHERE name = 'student')),
    ('Арслан', 'Умяров', '123@gmail.com', 'male',
     (SELECT id FROM occupations WHERE name = 'student')),
    ('Александр', 'Смирнов', '1234@gmail.com', 'male',
     (SELECT id FROM occupations WHERE name = 'student')),
    ('Максим', 'Шапошников', '12345@gmail.com', 'male',
     (SELECT id FROM occupations WHERE name = 'student')),
    ('Дмитрий', 'Яськин', '123567@gmail.com', 'male',
     (SELECT id FROM occupations WHERE name = 'student'));

-- Запоминаем автоматически выданные ID новых фильмов.
CREATE TEMP TABLE added_movies (
    code TEXT PRIMARY KEY,
    movie_id INTEGER NOT NULL UNIQUE
);

INSERT INTO movies(title, year) VALUES ('Лабораторная 6: Путешествие', 2026);
INSERT INTO added_movies VALUES ('adventure', last_insert_rowid());

INSERT INTO movies(title, year) VALUES ('Лабораторная 6: Улыбка', 2026);
INSERT INTO added_movies VALUES ('comedy', last_insert_rowid());

INSERT INTO movies(title, year) VALUES ('Лабораторная 6: Орбита', 2026);
INSERT INTO added_movies VALUES ('scifi', last_insert_rowid());

-- Три разных жанра. Числовые ID существующих жанров не используются.
INSERT INTO movie_genres(movie_id, genre_id)
SELECT a.movie_id, g.id
FROM added_movies AS a
JOIN genres AS g ON g.name = 'Adventure'
WHERE a.code = 'adventure';

INSERT INTO movie_genres(movie_id, genre_id)
SELECT a.movie_id, g.id
FROM added_movies AS a
JOIN genres AS g ON g.name = 'Comedy'
WHERE a.code = 'comedy';

INSERT INTO movie_genres(movie_id, genre_id)
SELECT a.movie_id, g.id
FROM added_movies AS a
JOIN genres AS g ON g.name = 'Sci-Fi'
WHERE a.code = 'scifi';

-- Три оценки новых фильмов от первого добавленного пользователя.

INSERT INTO ratings(user_id, movie_id, rating)
SELECT u.id, a.movie_id,
       CASE a.code
           WHEN 'adventure' THEN 5.0
           WHEN 'comedy' THEN 4.5
           WHEN 'scifi' THEN 4.0
       END
FROM users AS u
CROSS JOIN added_movies AS a
WHERE u.email = 'maxim13rrus@gmail.com';

DROP TABLE added_movies;
COMMIT;