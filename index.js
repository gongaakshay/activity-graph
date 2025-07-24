const fs = require('fs');
const moment = require('moment');
const simpleGit = require('simple-git');

const FILE_PATH = './data.json';
const git = simpleGit();

// Change the date here
const DATE = moment().subtract(1, 'y').add(1, 'd').format('YYYY-MM-DDTHH:mm:ss');

// Write something to file
fs.writeFileSync(FILE_PATH, JSON.stringify({ date: DATE }));

// Set env variables for fake commit date
git.env({
    GIT_AUTHOR_DATE: DATE,
    GIT_COMMITTER_DATE: DATE,
}).add([FILE_PATH])
  .commit(`Backdated commit on ${DATE}`)
  .push('origin', 'main')
  .then(() => console.log('✅ Commit pushed with custom date!'))
  .catch((err) => console.error('❌ Push failed:', err));
