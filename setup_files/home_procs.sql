DELIMITER $$

DROP PROCEDURE IF EXISTS App_Home_Page $$
CREATE PROCEDURE App_Home_Page()
BEGIN
   SELECT id, email, handle, fname, lname, fav_color
     FROM User
    WHERE id = @session_user_id
      AND email = @session_user_email;
END $$

DELIMITER ;
