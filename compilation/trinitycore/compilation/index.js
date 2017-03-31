'use strict';

const _ = require('lodash')

class TrinityCore extends MakeComponent {
  configureOptions() {
    const list = [`-DCMAKE_INSTALL_PREFIX=${this.prefix}`];
    return list;
  }
  configure() {
    const sourceDir = $file.join(this.be.sandboxDir, 'compilables');
    $file.rename(this.srcDir, sourceDir);
    $file.mkdir(this.srcDir);
    return this.sandbox.runProgram('cmake', `${sourceDir} ${this.configureOptions()}`);
  }
}


module.exports = TrinityCore;
