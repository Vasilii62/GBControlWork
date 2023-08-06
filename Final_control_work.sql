CREATE DATABASE IF NOT EXISTS Human_friends;

USE Human_friends;

CREATE TABLE IF NOT EXISTS animal_classes
(
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Class_name VARCHAR(20)
);

INSERT INTO animal_classes (Class_name)
VALUES ('Вьючные'),
       ('Домашние');  

CREATE TABLE IF NOT EXISTS packed_animals
(
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Genus_name VARCHAR (20),
    Class_id INT,
    FOREIGN KEY (Class_id) REFERENCES animal_classes (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO packed_animals (Genus_name, Class_id)
VALUES ('Лошади', 1),
       ('Ослы', 1),  
       ('Верблюды', 1); 
    
CREATE TABLE IF NOT EXISTS home_animals
(
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Genus_name VARCHAR (20),
    Class_id INT,
    FOREIGN KEY (Class_id) REFERENCES animal_classes (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO home_animals (Genus_name, Class_id)
VALUES ('Кошки', 2),
       ('Собаки', 2),  
       ('Хомяки', 2); 

CREATE TABLE IF NOT EXISTS cats 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Birthday DATE,
    Commands VARCHAR(50),
    Genus_id INT,
    FOREIGN KEY (Genus_id) REFERENCES home_animals (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO cats (Name, Birthday, Commands, Genus_id)
VALUES ('Мурка', '2021-11-11', 'кс-кс-кс', 1),
       ('Рыжик', '2019-06-21', 'брысь', 1),  
       ('Санта', '2022-03-03', '', 1); 

CREATE TABLE IF NOT EXISTS dogs 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Birthday DATE,
    Commands VARCHAR(50),
    Genus_id INT,
    FOREIGN KEY (Genus_id) REFERENCES home_animals (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO dogs (Name, Birthday, Commands, Genus_id)
VALUES ('Арчи', '2021-02-21', 'к ноге, лежать, голос', 2),
       ('Ольда', '2022-08-12', 'сидеть, лежать, лапу', 2),  
       ('Босс', '2019-05-23', 'сидеть, лежать, лапу, фас', 2), 
       ('Виски', '2018-09-17', 'сидеть, лежать, место, фу', 2);

CREATE TABLE IF NOT EXISTS hamsters 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Birthday DATE,
    Commands VARCHAR(50),
    Genus_id INT,
    FOREIGN KEY (Genus_id) REFERENCES home_animals (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO hamsters (Name, Birthday, Commands, Genus_id)
VALUES ('Пушок', '2019-06-21', '', 3),
       ('Кристи', '2022-05-24', 'на-на', 3),  
       ('Йода', '2022-02-13', NULL, 3), 
       ('Тарти', '2018-05-22', NULL, 3);

CREATE TABLE IF NOT EXISTS horses 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Birthday DATE,
    Commands VARCHAR(50),
    Genus_id INT,
    FOREIGN KEY (Genus_id) REFERENCES packed_animals (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO horses (Name, Birthday, Commands, Genus_id)
VALUES ('Гнедко', '2021-06-04', 'тпру, аллюр, стоять', 1),
       ('Граф', '2019-11-24', 'бегом, шагом, хоп', 1),  
       ('Искра', '2020-12-03', 'бегом, шагом, хоп, брр', 1), 
       ('Гром', '2022-04-26', 'бегом, шагом, хоп', 1);

CREATE TABLE IF NOT EXISTS donkeys 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Birthday DATE,
    Commands VARCHAR(50),
    Genus_id INT,
    FOREIGN KEY (Genus_id) REFERENCES packed_animals (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO donkeys (Name, Birthday, Commands, Genus_id)
VALUES ('Тормоз', '2020-05-07', 'Шагом', 2),
       ('Резвый', '2021-06-24', '', 2),  
       ('Тихоня', '2022-11-13', 'Тихо', 2), 
       ('Смурный', '2021-11-30', NULL, 2);

CREATE TABLE IF NOT EXISTS camels 
(       
    Id INT AUTO_INCREMENT PRIMARY KEY, 
    Name VARCHAR(20), 
    Birthday DATE,
    Commands VARCHAR(50),
    Genus_id INT,
    FOREIGN KEY (Genus_id) REFERENCES packed_animals (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO camels (Name, Birthday, Commands, Genus_id)
VALUES ('Проглот', '2022-07-09', 'шагом', 3),
       ('Меткий', '2018-03-03', 'стой, лечь', 3),  
       ('Черномор', '2019-12-11', 'пошли, стой', 3), 
       ('Князь', '2021-10-22', 'пошли', 3);

-- Объединение таблиц лошади и ослов в одну
CREATE TABLE IF NOT EXISTS packed_animals_combined AS
SELECT h.Id, h.Name, h.Birthday, h.Commands, pa.Genus_name, pa.Class_id
FROM horses h
LEFT JOIN packed_animals pa ON h.Genus_id = pa.Id
UNION
SELECT d.Id, d.Name, d.Birthday, d.Commands, pa.Genus_name, pa.Class_id
FROM donkeys d 
LEFT JOIN packed_animals pa ON d.Genus_id = pa.Id;

-- Создание таблицы "молодые животные" с подсчетом возраста
CREATE TABLE IF NOT EXISTS young_animals AS
SELECT Id, Name, Birthday, Commands, Genus_name,
       TIMESTAMPDIFF(MONTH, Birthday, CURDATE()) AS Age_in_months
FROM (
    SELECT Id, Name, Birthday, Commands, Genus_name, NULL AS Age_in_months FROM packed_animals_combined
    UNION ALL
    SELECT Id, Name, Birthday, Commands, NULL AS Genus_name, NULL AS Age_in_months FROM cats
    UNION ALL
    SELECT Id, Name, Birthday, Commands, NULL AS Genus_name, NULL AS Age_in_months FROM dogs
    UNION ALL
    SELECT Id, Name, Birthday, Commands, NULL AS Genus_name, NULL AS Age_in_months FROM hamsters
) AS all_animals
WHERE Birthday BETWEEN DATE_SUB(CURDATE(), INTERVAL 3 YEAR) AND DATE_SUB(CURDATE(), INTERVAL 1 YEAR);



-- Объединение всех таблиц в одну, сохраняя прошлую принадлежность к старым таблицам
CREATE TABLE IF NOT EXISTS all_animals AS
SELECT h.Id, h.Name, h.Birthday, h.Commands, pa.Genus_name AS Class_name,
       pa.Class_id AS Genus_id, TIMESTAMPDIFF(MONTH, h.Birthday, CURDATE()) AS Age_in_month, 'horses' AS Previous_table
FROM horses h
LEFT JOIN packed_animals pa ON h.Genus_id = pa.Id
UNION
SELECT d.Id, d.Name, d.Birthday, d.Commands, pa.Genus_name AS Class_name,
       pa.Class_id AS Genus_id, TIMESTAMPDIFF(MONTH, d.Birthday, CURDATE()) AS Age_in_month, 'donkeys' AS Previous_table
FROM donkeys d 
LEFT JOIN packed_animals pa ON d.Genus_id = pa.Id
UNION
SELECT c.Id, c.Name, c.Birthday, c.Commands, ha.Genus_name AS Class_name,
       ha.Class_id AS Genus_id, TIMESTAMPDIFF(MONTH, c.Birthday, CURDATE()) AS Age_in_month, 'cats' AS Previous_table
FROM cats c
LEFT JOIN home_animals ha ON ha.Id = c.Genus_id
UNION
SELECT d.Id, d.Name, d.Birthday, d.Commands, ha.Genus_name AS Class_name,
       ha.Class_id AS Genus_id, TIMESTAMPDIFF(MONTH, d.Birthday, CURDATE()) AS Age_in_month, 'dogs' AS Previous_table
FROM dogs d
LEFT JOIN home_animals ha ON ha.Id = d.Genus_id
UNION
SELECT hm.Id, hm.Name, hm.Birthday, hm.Commands, ha.Genus_name AS Class_name,
       ha.Class_id AS Genus_id, TIMESTAMPDIFF(MONTH, hm.Birthday, CURDATE()) AS Age_in_month, 'hamsters' AS Previous_table
FROM hamsters hm
LEFT JOIN home_animals ha ON ha.Id = hm.Genus_id;





-- Удаление временных таблиц
DROP TEMPORARY TABLE IF EXISTS animals;
DROP TEMPORARY TABLE IF EXISTS young_animals;

