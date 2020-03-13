const fs = require('fs');
const path = require('path');

const getFileUpdatedDate = (path) => {
  const stats = fs.statSync(path)
  return stats.mtime
}

// path.resolve for full path
// Keep things simple two funcs:
// 1. Update cache: check cache, if cache miss run the shell func, save the shell function in data struct, echo struct to variable
// 2. Read cache: read cache print result to stdout
