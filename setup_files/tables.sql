
CREATE TABLE IF NOT EXISTS User
(
   id         INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
   email      VARCHAR(128),
   pword_hash BINARY(16),
   handle     VARCHAR(32),

   fname      VARCHAR(32),
   lname      VARCHAR(32),

   fav_color  VARCHAR(32),

   INDEX(email)
);

CREATE TABLE IF NOT EXISTS Salt
(
   id_user   INT UNSIGNED NOT NULL PRIMARY KEY,
   salt      CHAR(32)
);

CREATE TABLE IF NOT EXISTS Session_Info
(
   id_session  INT UNSIGNED UNIQUE KEY,
   user_id     INT UNSIGNED NULL,
   user_handle VARCHAR(32),
   user_email  VARCHAR(128)
);

CREATE TABLE IF NOT EXISTS Password_Reset
(
   code    CHAR(6),
   email   VARCHAR(128),
   expires DATETIME,
   INDEX(code),
   INDEX(email)
);
