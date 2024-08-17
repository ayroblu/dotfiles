#!/usr/bin/env node
const {execSync} = require('child_process');
const fs = require('fs');

const currentDirFiles = fs.readdirSync('.');
const output = execSync('tmux capture-pane -pJ -S -100').toString();

// file paths are possibly: /Users/... or file/path/here, where file must match
// a file in fs.readdirSync('.')
// spaces may be present, e.g. "directory/my dir/file" vs dir/path and
// dir/other-path
//
// We mostly want to find paths that exist, but what about /existdir/deletedfile
// We could show /existsdir, or not at all (carries on from whitespace issue)
const result = output
  .split('\n')
  .flatMap(findFiles)
  .reverse()

const uniqueResults = [...new Set(result)];
console.log(uniqueResults.join('\n'))

// async function fileExists(path) {
//   return !!(await fs.promises.stat(path).catch(e => false));
// }
// spaces not supported
function findFiles(line) {
  const parts = line.split(/[\s:]+/g);
  return parts
    .map(part => part.startsWith('~/')
      // ? (console.log(part, process.env.HOME, part.replace('~', process.env.HOME)), part.replace('~', process.env.HOME))
      ? part.replace('~', process.env.HOME)
      : part
    ).filter(part => {
    return (currentDirFiles.some(f => part.startsWith(f)) || part.startsWith('/')) && fs.existsSync(part) && !fs.lstatSync(part).isDirectory()
  });
}

