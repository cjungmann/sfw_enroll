DELIMITER $$

-- ----------------------------------------------
DROP PROCEDURE IF EXISTS App_User_Profile_Read $$
CREATE PROCEDURE App_User_Profile_Read(id INT UNSIGNED,
                                       email VARCHAR(128))
BEGIN
   SELECT id, email, handle, fname, lname, fav_color
     FROM User
    WHERE User.id = id AND User.email = email;
END $$

-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS App_User_Profile_Update $$
CREATE PROCEDURE App_User_Profile_Update(id        INT UNSIGNED,
                                         email     VARCHAR(128),
                                         pword     VARCHAR(20),
                                         handle    VARCHAR(32),
                                         fname     VARCHAR(32),
                                         lname     VARCHAR(32),
                                         fav_color VARCHAR(32))
proc_block: BEGIN
   DECLARE has_password INT UNSIGNED;

   -- Separate step for password to send specific feedback:
   SELECT COUNT(*) INTO has_password
     FROM User u
          INNER JOIN Salt s ON u.id = s.id_user
    WHERE u.id = id
      AND u.pword_hash = ssys_hash_password_with_salt(pword, s.salt);

   IF has_password = 0 THEN
      SELECT 1 AS error, 'Unauthorized access.' AS msg;
      LEAVE proc_block;
   END IF;

   UPDATE User u
      SET u.fname = fname,
          u.lname = lname,
          u.fav_color = fav_color
    WHERE u.id = id
      AND u.email = email;

   IF ROW_COUNT() > 0 THEN
      CALL App_User_Profile_Read(id, email);
   END IF;

END $$


DELIMITER ;
