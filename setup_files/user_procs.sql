DELIMITER $$

-- ----------------------------------------------
DROP PROCEDURE IF EXISTS App_User_Profile_Read $$
CREATE PROCEDURE App_User_Profile_Read()
BEGIN
   SELECT id, email, handle, fname, lname, fav_color
     FROM User
    WHERE User.id = @session_user_id
      AND User.email = @session_user_email;
END $$

-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS App_User_Profile_Update $$
CREATE PROCEDURE App_User_Profile_Update(id        INT UNSIGNED,
                                         password  VARCHAR(20),
                                         fname     VARCHAR(32),
                                         lname     VARCHAR(32),
                                         fav_color VARCHAR(32))
proc_block: BEGIN

   -- Early terminate for bad password
   IF NOT(App_User_Password_Check(id, password)) THEN
      SELECT 1 AS error, 'Unauthorized access.' AS msg;
      LEAVE proc_block;
   END IF;

   UPDATE User u
      SET u.fname = fname,
          u.lname = lname,
          u.fav_color = fav_color
    WHERE u.id = id
      AND u.email = @session_user_email;

   IF ROW_COUNT() > 0 THEN
      SELECT 0 AS error, 'Changes made.' AS msg;
   END IF;

END $$

-- -------------------------------------------------
DROP PROCEDURE IF EXISTS App_User_Change_Password $$
CREATE PROCEDURE App_User_Change_Password(id INT UNSIGNED,
                                          old_password VARCHAR(20),
                                          new_password VARCHAR(20))
BEGIN
   IF App_User_Password_Check(id, old_password) THEN
      CALL App_User_Set_Password(id, new_password);
      SELECT 0 AS error, 'Password changed.' AS msg;
   ELSE
      SELECT 1 AS error, 'Password not changed.' AS msg;
   END IF;
END $$
                                          


DELIMITER ;
