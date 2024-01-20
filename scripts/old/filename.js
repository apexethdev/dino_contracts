const fs = require('fs');
const path = require('path');

function getAllFileNamesWithoutExtension(dir, subfolder, fileNames = []) {
  const folderPath = path.join(dir, subfolder);
  const files = fs.readdirSync(folderPath);

  files.forEach(file => {
    const filePath = path.join(folderPath, file);
    if (fs.statSync(filePath).isDirectory()) {
      getAllFileNamesWithoutExtension(folderPath, file, fileNames);
    } else {
      const fileNameWithoutExtension = path.parse(file).name;
      fileNames.push(fileNameWithoutExtension);
    }
  });

  return fileNames;
}

// Example: Process the subfolder "exampleSubfolder" within the "traits" folder
const parentDir = path.join(__dirname, '..');
const traitsFolderPath = path.join(parentDir, 'traits');
const subfolderName = 'spikes';

const allFileNames = getAllFileNamesWithoutExtension(traitsFolderPath, subfolderName);

console.log(`File Names without Extension in "${subfolderName}":`, allFileNames);
