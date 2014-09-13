Drush Menu
==========

OS-X toolbar menu for Drush operations:

![Screenshot](https://monosnap.com/image/JGptuKEcudSXqshPZaYLq2bGWkAPQj.png)

*Get the compiled OS-X 10.9 application*: [Download from DropBox](https://dl.dropboxusercontent.com/u/2629592/DrushMenu.app.zip).


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

Format:

```JSON
{
  "drush": "/PATH/TO/DRUSH/EXECUTABLE",
  "sites": [
    {
      "name": "SITE NAME",
      "folder": "SITE FOLDER",
      "commands": [
        {
          "name": "COMMAND NAME",
          "arguments": ["COMMAND ARGUMENTS"],
          "hotkey": "HOTKEY CODE"
        }
      ]
    }
  ]
}
```

Example:

```JSON
{
  "drush": "/home/johndoe/apps/drush",
  "sites": [
    {
      "name": "Rabbit Site",
      "folder": "/var/www/foobar",
      "commands": [
        {
          "name": "Clear caches",
          "arguments": ["cc", "all"],
          "hotkey": "82"
        },
        {
          "name": "Sanitize database",
          "arguments": ["sql-sanitize", "-y"]
        },
        {
          "name": "Migrate users",
          "arguments": ["mi", "UserMigration", "--force", "--update"],
          "hotkey": "87"
        }
      ]
    },
    {
      "name": "Cat Site - Production",
      "folder": "/var/www/foobar",
      "commands": [
        {
          "name": "Clear caches",
          "arguments": ["@foobar_prod", "cc", "all"],
          "hotkey": "82"
        },
        {
          "name": "Generate emails",
          "arguments": ["@foobar_prod", "generate-email", "--term=blog"]
        }
      ]
    }
  ]
}
```
