Drush Menu
==========

OS-X toolbar menu for Drush operations:

![Screenshot](https://monosnap.com/image/JGptuKEcudSXqshPZaYLq2bGWkAPQj.png)


Requirements
------------

- OS-X >= 10.9
- Drush (available from ```/usr/bin```)
- database client (available from ```/usr/bin```, such as ```/usr/bin/mysql```)


Usage
-----

Create configuration file and set when the application starts. Use the toolbar menu items or the shortcuts. Selecting the main site menu items will execute cache clear, all other submenu items will execute the named command. Execution termination will present a system notification.


Configuration file
------------------

```JSON
{
  "sites": [
    {
      "name": "Project Rabbit",
      "folder": "/home/sites/web/project_rabbit/root"
    },
    {
      "name": "Foobar Site",
      "folder": "/var/www/foobar",
      "extra_commands": [
        {
          "name": "Sanitize database",
          "arguments": ["sql-sanitize", "-y"]
        },
        {
          "name": "Migrate users",
          "arguments": ["mi", "UserMigration", "--force", "--update"]
        }
      ]
    }
  ]
}
```
