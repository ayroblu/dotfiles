#!/usr/bin/env node
const fs = require('fs')
const path = require('path')

const dir = process.argv[2]
console.log('Watching', dir)
fs.watch(dir, {}, (eventType, filename) => {
  if (filename) {
    const absolutePath = path.join(dir, filename)
    if (fs.existsSync(absolutePath)) {
      fs.rmSync(absolutePath)
      console.log("deleted", absolutePath)
    }
  }
})
