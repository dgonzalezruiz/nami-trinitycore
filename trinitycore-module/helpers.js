'use strict';
//const _ = require('lodash');
//const hostFunctions = require('./lib/host');
//const componentFunctions = require('./lib/component')($app);
//const mysqlFunctions = require('./lib/databases/mysql')({binDir: $app.binDir});

$app.helpers.populatePrintProperties = function() {
  const properties = {};
    properties['Admin User'] = $app.username;
    properties['Root Password'] = $app.password;
  return properties;
};

$app.helpers.configureRealmlist = function(databaseHandler) {
}
$app.helpers.configureServer = function(confFiles) {
    $file.substitute([confFiles.worldserver, confFiles.authserver], [
    {
      pattern: /LogsDir\s*=\s*".*"/m,
      value: `LogsDir = "${$app.logsDir}"`
    }, {
      pattern: /DataDir\s*=\s*".*"/m,
      value: `DataDir = "${$app.dataDir}"`
    }, {
      pattern: /SourceDirectory\s*=\s*".*"/m,
      value: `SourceDirectory = "${$app.installdir}"`
    }, {
      pattern: /BuildDirectory\s*=\s*".*"/m,
      value: `BuildDirectory = "${$app.installdir}"`
    }]
  );
}

$app.helpers.configureRealmlist = function(databasePassword, realmlist) {
  mysqlFunctions('auth', 'realmlist', 'address', realmlist, {host: $app.databaseServerHost, 
                                                              port: $app.databaseServerPort,  
                                                              user: $app.databaseAdminUser,
                                                              password: databasePassword});
}

// This fills the config files with the right credentials
$app.helpers.configureDatabase = function( databaseHandler, confFiles) {
  $file.substitute([confFiles.worldserver, confFiles.authserver],
    [{
      pattern: /LoginDatabaseInfo\s*=\s*".*"/m,
      value: `LoginDatabaseInfo =` +
        ` "${databaseHandler.connection.host};${databaseHandler.connection.port};${databaseHandler.connection.user};${databaseHandler.connection.password};auth"`
    }, {
      pattern: /WorldDatabaseInfo\s*=\s*".*"/m,
      value: `WorldDatabaseInfo =`+
        ` "${databaseHandler.connection.host};${databaseHandler.connection.port};${databaseHandler.connection.user};${databaseHandler.connection.password};world"`
    }, {
      pattern: /CharacterDatabaseInfo\s*=\s*".*"/m,
      value: `CharacterDatabaseInfo =`+
        ` "${databaseHandler.connection.host};${databaseHandler.connection.port};${databaseHandler.connection.user};${databaseHandler.connection.password};characters"`
    }]
  );
}
