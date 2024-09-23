#!/usr/bin/env bun
import fs from 'node:fs';

const arg = process.argv[2]
console.log(arg);
const list = fs.readFileSync(arg, 'utf-8').split('\n');
const filteredList = list.filter((item: string) => {
  return item.includes('fs_metadata');
}).map(item => {
  const o = JSON.parse(item);
  const ts = new Date(o.ts).toISOString();
  const uid = o.message.response.body.plugindata.data.media[0].uid;
  const result = `${ts}: video: ${uid}`;
  return result
});
fs.writeFileSync(arg, filteredList.join('\n'))
