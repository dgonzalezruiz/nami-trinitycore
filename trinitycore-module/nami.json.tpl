{
  "id": "com.trinitycore",
  "name": "trinitycore",
  "extends": ["Component"],
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
    "systemUser": {"value": "trinity"},
    "systemGroup": {"value": "trinity"},
    "confDir": {"value": "etc", "description": "Folder with configuration files"},
    "databaseServerHost": {"description": "Database Server Host", "default": "127.0.0.1"},
    "databaseServerPort": {"description": "Database Server Port", "default": 3306},
    "databaseUser": {"description": "Name of the database user that the application will connect with", "default": "trinityUser"},
    "databasePassword": {"description": "Password for the database user", "default": ""},
    "dataDir": {"description": "Folder in which maps will be mounted", "value": "/var/trinitycore/data"},
    "dataToPersist": {
      "description": "Directories to preserve in volumes",
      "value": [
        "etc"
      ]
    },
    "persistDir": {
      "description": "Directory in which persistence volume will be mounted",
      "value": "/var/trinitycore"
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
