#!/usr/local/bin/node
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const os = require('os');

const getFileUpdatedDate = (path) => {
  const stats = fs.statSync(path)
  return stats.mtime
}

// path.resolve for full path
// Keep things simple two funcs:
// 1. Update cache: check cache, if cache miss run the shell func, save the shell function in data struct, echo struct to variable
// 2. Read cache: read cache print result to stdout
//
// If I want to write to a file:
// 1. run "checkCmd" for list of file names - do nodejs though
// 2. Check files if they are more recent than saved timestamp
// 3. if more recent, run $statedCmd
//   a. save output to a struct
//   b. save struct to a file
// 4. read from datastruct and output

// Storage type: {
//   [cmd: string]: {
//     timestamps: {
//       [absoluteFile: string]: string
//     }
//     result: string,
//   }
// }

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
  cmd: 'npx gulp',
  getListOptions: "npx gulp --tasks --depth 1 | tail -n +3 | awk '{print $3}' | sort",
  getCmdFiles: () => ['gulpfile.ts'],
}, {
  cmd: 'git co',
  getListOptions: "git status -s | sed s/^...//",
  getCmdFiles: () => execSync('rg --files --hidden --glob "!.git" 2> /dev/null', {encoding: 'utf-8'}).trim().split('\n'),
  shouldCache: () => /source/.test(process.cwd())
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

    if (newFiles.length || !files.length || (cacheDef.shouldCache && !cacheDef.shouldCache())) {
      console.log('no cache!');
      const result = execSync(cacheDef.getListOptions, {encoding: 'utf-8'});
      stored[cmd].result = result.trim();
      if (files.length < 10000) {
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


function getFiles(startPath, regex) {
  const files = fs.readdirSync(startPath);
  return files.filter(file => {
    var filename = path.resolve(file)
    var stat = fs.lstatSync(filename);
    if (stat.isDirectory()){
      return false;
      // fromDir(filename,filter,callback); //recurse
    }
    else if (regex.test(filename)) {
      return true;
    }
  });
}
