#!/usr/local/bin/node
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const os = require('os');

const homedir = os.homedir();
const storedFilePath = path.resolve(homedir, '.blu_fzf_cache.json');
let stored = {}
try {
  stored = JSON.parse(fs.readFileSync(storedFilePath, 'utf-8'))
} catch (err) {
}

const args = process.argv.slice(2);
if (args.length !== 1) {
  console.error('was expecting an argument!');
  return;
}

const cacheDefs = [{
  cmd: 'brew install',
  getListOptions: "brew search",
  getCmdFiles: () => ['/usr/local/Homebrew/bin/brew'],
}, {
  cmd: 'brew cask install',
  getListOptions: "brew search --casks",
  getCmdFiles: () => ['/usr/local/Homebrew/bin/brew'],
}, {
  cmd: 'npx gulp',
  getListOptions: "npx gulp --tasks --depth 1 | tail -n +3 | awk '{print $3}' | sort",
  getCmdFiles: () => ['gulpfile.ts'],
}, {
  cmd: 'git co',
  getListOptions: "git status -s | sed s/^...//",
  getCmdFiles: () => execSync('rg --files --hidden --glob "!.git" 2> /dev/null', {encoding: 'utf-8'}).trim().split('\n'),
  shouldNotCache: () => !/source/.test(process.cwd())
}]

function runCmd(cacheDef, arg) {
  const cmd = cacheDef.cmd;
  if (new RegExp(`^${cmd}`,'g').test(arg)) {
    if (!stored[cmd]) stored[cmd] = {timestamps: {}, result: ''}

    const files = cacheDef.getCmdFiles().map(file => path.resolve(file));
    const newFiles = files.filter(file => {
      const fileDate =  fs.statSync(file).mtime
      if (!stored[cmd].timestamps[file] || (new Date(stored[cmd].timestamps[file]) < fileDate)) {
        stored[cmd].timestamps[file] = fileDate;
        return true;
      }
      return false;
    });

    if (newFiles.length || !files.length || (cacheDef.shouldNotCache && cacheDef.shouldNotCache())) {
      console.log('no cache!');
      const result = execSync(cacheDef.getListOptions, {encoding: 'utf-8'});
      stored[cmd].result = result.trim();
      if ((cacheDef.shouldNotCache && cacheDef.shouldNotCache()) || files.length < 10000) {
        // Lets be sensible, over 10k entries this is probably not effective anyways
        // Update cache
        fs.writeFileSync(storedFilePath, JSON.stringify(stored, null, 2));
      }
    }
    console.log(stored[cmd].result);
  }
}
cacheDefs.forEach(cacheDef => {
  runCmd(cacheDef, args[0]);
});

