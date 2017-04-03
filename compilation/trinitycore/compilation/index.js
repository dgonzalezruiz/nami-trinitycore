'use strict';

const _ = require('lodash')

class TrinityCore extends MakeComponent {
  configureOptions() {
    const list = [`-DCMAKE_INSTALL_PREFIX=${this.prefix}`];
    return list;
  }
  configure() {
    const sourceDir = $file.join(this.be.sandboxDir, 'compilables');
    const prefixDir = this.prefix
    const licensesFile = this.metadata.licenses[0].licenseRelativePath;
    const authSQL = $file.join('sql', 'base', 'auth_database.sql');
    const charsSQL = $file.join('sql', 'base', 'characters_database.sql');
    const updatesSQL = $file.join('sql', 'updates');
    $file.rename(this.srcDir, sourceDir);
    $file.mkdir(this.srcDir);
    $file.copy($file.join(sourceDir, licensesFile), $file.join(this.srcDir, licensesFile));
    _.forEach([authSQL, charsSQL, updatesSQL], function(file) {
      $file.copy($file.join(sourceDir, file), $file.join(prefixDir, file));
    });
    return this.sandbox.runProgram('cmake', `${sourceDir} ${this.configureOptions()}`);
  }
}


module.exports = TrinityCore;
