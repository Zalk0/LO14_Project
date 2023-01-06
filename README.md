# LO14_Project

Project of a virtual machines network (with the virtual machines being files) and creation of commands usable when connected to a machine.

## List of Commands

Here is a list of commands, which you can also display in a detailled version with the following command in the script.

> rsvh -help

### Mode connect

This mode will allow the user to connect to the machine with his username.

Use this command:

> rvsh -connect machine_name user_name

### Mode admin

This mode will allow the administrator to manage the list of connected machines and the list of users.

Use this command:

> rvsh -admin

## Error codes

These will be the numbers returned by functions to indicate if it's ok or not.

**0** No error  
**1** Invalid number of arguments or invalid arguments  
**2** The machine doesn't exist  
**3** The user doesn't exist  
**4** The user doesn't have access to the machine  
**5** The password isn't correct  
**6** The username and/or the machine name isn't only composed of miniscules and digits
