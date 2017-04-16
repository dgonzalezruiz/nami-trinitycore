'use strict';

const _ = require('lodash');
const handlerSelector = require('./lib/handlers/selector');
const volumeFunctions = require('./lib/volume')($app);
const componentFunctions = require('./lib/component')($app);
const mysqlFunctions = require('./lib/databases/mysql')({binDir: $app.binDir});

$app.postInstallation = function() {
  $os.addGroup($app.systemGroup);
  $os.addUser($app.systemUser, {gid: $app.systemGroup});
  _.forEach([$app.logsDir], function(folder) {
    $file.mkdir(folder);
  });
  const confFiles = {
    worldserver: $file.join($app.confDir, 'worldserver.conf'),
    authserver: $file.join($app.confDir, 'authserver.conf')
  };
  _.forEach(confFiles, function(confFile) {
    try {
      $file.move(`${confFile}.dist`, confFile);
    } catch (e) {
      $app.debug(`Skipping renaming of ${confFile}.dist file... `);
    }
  });
  if (!volumeFunctions.isInitialized($app.persistDir)) {
    // No data detected in persistence volumes
     const databaseHandler = handlerSelector.getHandler('database', {
      variation: 'mariadb',
      user: $app.databaseUser,
      password: $app.databasePassword,
      host: $app.databaseServerHost,
      port: $app.databaseServerPort
    }, {cwd: $app.installdir});
    databaseHandler.checkConnection(); 
 

    $app.info('==> Initializing database...');
    // Fill the configuration file with right DB credentials
    $app.helpers.configureDatabase(databaseHandler, confFiles);
    // Fill the database with data
    // By now, we will be leaving binaries take care of populating the database with the sql sets in srcDir
    //  $app.helpers.populateDatabase($app.databaseHandler, confFiles);
    $app.helpers.configureServer(confFiles);
    volumeFunctions.prepareDataToPersist($app.dataToPersist);
  } else {
    volumeFunctions.restorePersistedData($app.dataToPersist);
  }
  componentFunctions.configurePermissions($app.confDir, {
    user: $app.systemUser,
    group: $app.systemGroup
  });
/*
  TO-DO add logging management to module 
  componentFunctions.createExtraConfigurationFiles([
    {type: 'monit', path: $app.monitFile, params: {service: $app.name, pidFile: $app.pidFile}},
    {type: 'logrotate', path: $app.logrotateFile, params: {logPath: $file.join($app.logsDir, '*log')}}
  ]);*/


  componentFunctions.printProperties($app.helpers.populatePrintProperties());
};

$app.exports.configureRealmlist = $app.helpers.configureRealmlist;
