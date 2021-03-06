DELIMITER $$

-- ---------------------------------------
DROP PROCEDURE IF EXISTS App_User_Login $$
CREATE PROCEDURE App_User_Login(email VARCHAR(128), password VARCHAR(20))
BEGIN
   -- declare user variables
   DECLARE user_id     INT UNSIGNED;
   DECLARE user_handle VARCHAR(32);
   -- any other user variables

   IF NOT (ssys_current_session_is_valid()) THEN
      SELECT 2 AS error, 'Expired session' AS msg;
   ELSE
      SELECT u.id,
             u.handle
             -- any other user values
        INTO user_id,
             user_handle
             -- any other user variables
        FROM User u
             INNER JOIN Salt s ON s.id_user = u.id
       WHERE u.email = email
         AND u.pword_hash = ssys_hash_password_with_salt(password, s.salt);

      IF user_id IS NULL THEN
         SELECT 1 AS error, 'Invalid credentials' AS msg;
      ELSE
         -- This generated procedure resides in session_procs.sql:
         CALL App_Session_Initialize(user_id, user_handle, email);

         SELECT 0 AS error, 'Successful login' AS msg;
      END IF;

   END IF;
END $$

-- ----------------------------------------
DROP PROCEDURE IF EXISTS App_User_Logout $$
CREATE PROCEDURE App_User_Logout()
BEGIN
   CALL App_Session_Abandon(@session_confirmed_id);
END $$

-- ------------------------------------------
DROP PROCEDURE IF EXISTS App_User_Register $$
CREATE PROCEDURE App_User_Register(email    VARCHAR(128),
                                   password VARCHAR(20),
                                   handle   VARCHAR(32))
proc_block: BEGIN
   DECLARE name_count INT UNSIGNED;
   DECLARE user_id    INT UNSIGNED;
   DECLARE new_salt   CHAR(32);

   SELECT make_randstr(32) INTO new_salt;

   -- Confirm each of the input parameters
   IF email IS NULL OR LENGTH(email) = 0 THEN
      SELECT 3 AS error, 'Missing email' AS msg;
      LEAVE proc_block;
   END IF;

   IF password IS NULL OR LENGTH(password) = 0 THEN
      SELECT 4 AS error, 'Missing password' AS msg;
      LEAVE proc_block;
   END IF;

   IF handle IS NULL OR LENGTH(handle) = 0 THEN
      SELECT 5 AS error, 'Missing handle' AS msg;
      LEAVE proc_block;
   END IF;

   SELECT COUNT(*) INTO user_count
     FROM User
    WHERE User.email = email;

   IF user_count > 0 THEN
      SELECT 6 AS error, 'That email is already in use.' AS msg;
      LEAVE proc_block;
   END IF;

   SELECT COUNT(*) INTO user_count
     FROM User
    WHERE User.handle = handle;

   IF user_count > 0 THEN
      SELECT 7 AS error, 'That handle is already in use.' AS msg;
      LEAVE proc_block;
   END IF;

   -- Create the User and Salt table records:

   START TRANSACTION;

   INSERT INTO User(email, pword_hash, handle)
          VALUES(email,
                 ssys_hash_password_with_salt(password, new_salt),
                 handle);

   IF ROW_COUNT() = 1 THEN
      SELECT LAST_INSERT_ID() INTO user_id;

      INSERT INTO Salt(id_user, salt)
           VALUES (user_id, new_salt);

      IF ROW_COUNT() = 1 THEN
         COMMIT;

         -- This generated procedure resides in session_procs.sql:
         CALL App_Session_Initialize(user_id, handle, email);

         SELECT 0 as error, 'User created' AS msg;

         LEAVE proc_block;
      END IF;
   END IF;

   ROLLBACK;
   SELECT 1 AS error, CONCAT('Failed to create user. Please try again later.') AS msg;

END $$

-- ---------------------------------------------------------
DROP PROCEDURE IF EXISTS App_User_Password_Request_Rescue $$
CREATE PROCEDURE App_User_Password_Request_Rescue(email VARCHAR(128))
BEGIN
   DECLARE new_code CHAR(6) DEFAULT make_randstr(6);
   DECLARE user_id INT UNSIGNED;
   DECLARE count_resets INT UNSIGNED DEFAULT 0;

   SELECT u.id INTO user_id
     FROM User u
    WHERE u.email = email;

   IF user_id IS NOT NULL THEN
      UPDATE Password_Reset pw
         SET pw.code = new_code,
             pw.expires = ADDTIME(NOW(), '0:20:0')
       WHERE pw.user_id = user_id;

      IF ROW_COUNT() = 0 THEN
         INSERT
           INTO Password_Reset (user_id, code, email, expires)
         VALUES (user_id,
                 new_code,
                 email,
                 ADDTIME(NOW(), '0:20:0'));
      END IF;

      SELECT *
        FROM Password_Reset pw
       WHERE pw.user_id = user_id;
   END IF;
END $$

-- ------------------------------------------------------
DROP PROCEDURE IF EXISTS App_User_Password_Rescue $$
CREATE PROCEDURE App_User_Password_Rescue(email VARCHAR(128),
                                          code CHAR(6),
                                          password VARCHAR(20))
BEGIN
   DECLARE user_id INT UNSIGNED;
   DECLARE expires DATETIME;

   SELECT pr.user_id, pr.expires INTO user_id, expires
     FROM Password_Reset pr
    WHERE pr.email = email
      AND pr.code = code;

   IF expires IS NOT NULL AND expires > NOW() THEN
      CALL App_User_Set_Password(user_id, password);
      SELECT 0 AS error, 'Password set.' AS msg;
   ELSE
      SELECT 1 AS error, 'No rescue is available.' AS msg;
   END IF;

END $$

DELIMITER ;
