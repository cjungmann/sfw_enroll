# SFW_Enroll Project

This project is an exploration and example of a site that registers
users with an email address and password and, eventually, a method
for recovering a lost password with a special temporary link that
can be sent to a user in an email.

## Setup

Clone the project into an appropriate directory, then execute the
following steps:

- Run script **setup** to:
  1 Create database **SFW_Enroll**.
  1 Load SchemaServer system procedures to new database.
  1 Load tables.sql.
  1 Generate and load session procedures from tables.
  1 Load login_procs.sql for login and register procedures.
  1 Create **site** subdirectory, with Schema Framework files
    and directory.
  1 Use **gensfw_srm_from_proc** to create *login.srm*.
  1 Use **gensfw_srm** to modify *login.srm*

- Run script **setup_apache** to:
  1 Create and install an Apache conf file.
  1 Activate site
  1 Reload Apache
  1 Add host entry to /etc/hosts to run on local host.