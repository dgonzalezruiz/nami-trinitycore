{
  "id": "com.trinitycore",
  "name": "Component",
  "extends": ["Service"],
  "author": {"name": "dgonzalezruiz", "url": "https://github.com/dgonzalezruiz"},
  "expects": [
    "com.bitnami.mysql-client"
  ],
  "version": "<<version>>",
  "revision": "<<revision>>",
  "properties": {
    "username": {"default": "trinity", "description": "Admin user that will be created at startup by default"},
    "password": {"default": "trinity", "description": "Password of the admin user created by default"},
    "realmlist": {"default": "127.0.0.1", "description": "Realmist the auth server answers to"},
    "mode": {"type": "choice", "validValues": ["worldserver", "authserver"], "description": "Mode that will be deployed"},
    "systemUser": {"value": "trinity"},
    "systemGroup": {"value": "trinity"},
    "confDir": {"value": "etc", "description": "Folder with configuration files"},
    "srcDir": {"value": "source", "description": "Folder where the source SQL files live"},
    "databaseServerHost": {"description": "Database Server Host", "default": "127.0.0.1"},
    "databaseServerPort": {"description": "Database Server Port", "default": 3306},
    "databaseUser": {"description": "Name of the database user that the application will connect with", "default": "trinityUser"},
    "databasePassword": {"description": "Password for the database user", "default": ""},
    "dataToPersist": {
      "description": "Directories to preserve in volumes",
      "value": [
        "etc",
        "data"
      ]
    } 
  },
  "exports": {
     "configureRealmlist": {
       "arguments": [
         "databasePassword",
         "realmlist"
       ]
     }
  },
  "installation": {
    "packaging": {
      "components": [{
        "name": "trinitycore",
        "owner": "root",
        "folders": [{
          "name": "trinitycore",
          "files": [{"origin": ["files/trinitycore/*"]}]
        }]
      }]
    }
  }
}
