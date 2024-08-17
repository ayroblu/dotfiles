#!/usr/bin/env bun
import fs from 'node:fs';

const arg = process.argv[2]
console.log(arg);
const list = JSON.parse(fs.readFileSync(arg, 'utf-8'))
const filteredList = list.filter((item: any) => {
  const requestJanus = item?.request?.data?.janus;
  const janus = item?.response?.body?.janus;
  const videoroom = item?.response?.body?.plugindata?.data?.videoroom;
  return !['trickle'].includes(requestJanus) && !['media'].includes(janus) && !['fs_metadata'].includes(videoroom)
})
filteredList.forEach((l: any) => {
  if (l.response.arrayBuffer) {
    delete l.response.arrayBuffer;
  }
})
const json = JSON.stringify(filteredList, null, 2)
fs.writeFileSync(arg, json)
