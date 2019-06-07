
CREATE TABLE IF NOT EXISTS Person
(
   id         INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
   fname      VARCHAR(20),
   lname      VARCHAR(20),
   skater     BOOLEAN,
   guardian   BOOLEAN,
   coach      BOOLEAN,
   new_member BOOLEAN,
   home_club  VARCHAR(20),
   USFSA      VARCHAR(10),
   email      VARCHAR(128)
);

CREATE TABLE IF NOT EXISTS Phone
(
   id         INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
   pnumber    VARCHAR(20),
   type       ENUM('mobile', 'home', 'work', 'other')
);

CREATE TABLE IF NOT EXISTS Person2Phone
(
   id_person INT UNSIGNED NOT NULL,
   id_phone  INT UNSIGNED NOT NULL,
   INDEX(id_person),
   INDEX(id_phone)
);

CREATE TABLE IF NOT EXISTS Skater2Coach
(
   id_skater  INT UNSIGNED NOT NULL,
   id_coach   INT UNSIGNED NOT NULL,
   INDEX(id_skater),
   INDEX(id_coach)
);

CREATE TABLE IF NOT EXISTS Skater2Guardian
(
   id_skater   INT UNSIGNED NOT NULL,
   id_guardian INT UNSIGNED NOT NULL,
   INDEX(id_skater),
   INDEX(id_guardian)
);

