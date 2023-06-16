#!/usr/bin/env node
const {execSync} = require('child_process');

const output = execSync('tmux capture-pane -pJ').toString();
// https://stackoverflow.com/questions/3809401/what-is-a-good-regular-expression-to-match-a-url
const urlRegex = /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)/
const result = output
  .split('\n')
  .map(line => urlRegex.exec(line))
  .filter(Boolean)
  .map(match => match[0])
const uniqueUrls = [...new Set(result)];
console.log(uniqueUrls.join('\n'))
