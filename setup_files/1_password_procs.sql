DELIMITER $$

-- -----------------------------------------------
DROP FUNCTION IF EXISTS App_User_Password_Check $$
CREATE FUNCTION App_User_Password_Check(id INT UNSIGNED,
                                         password VARCHAR(20))
RETURNS BOOLEAN
BEGIN
   DECLARE pcount INT UNSIGNED;
   SELECT COUNT(*) INTO pcount
     FROM User u
          INNER JOIN Salt s ON u.id = s.id_user
    WHERE u.id = id
      AND u.pword_hash = ssys_hash_password_with_salt(password, s.salt);

   RETURN pcount = 1;
END $$

-- ----------------------------------------------
-- This procedure DOES NOT qualify anything before
-- setting the password.  Therefore, it is only
-- suitable to be called from another procedure
-- that DOES qualify the input or user.
-- ----------------------------------------------
DROP PROCEDURE IF EXISTS App_User_Set_Password $$
CREATE PROCEDURE App_User_Set_Password(id INT UNSIGNED,
                                       password VARCHAR(20))
BEGIN
   DECLARE new_salt CHAR(32) DEFAULT make_randstr(32);

   UPDATE User u
          INNER JOIN Salt s ON u.id = s.id_user
      SET s.salt = new_salt,
          u.pword_hash = ssys_hash_password_with_salt(password, new_salt)
    WHERE u.id = id;
END $$

DELIMITER ;
