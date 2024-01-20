const fs = require('fs');
const path = require('path');

// Function to update the width and height of an SVG file content
const updateSvgSize = (content) => {
  return content.replace(
    /<svg width="\d+" height="\d+"/,
    '<svg width="512" height="512"'
  );
};

// Function to process all SVG files in the 'pngfiles' directory
const processSvgFiles = (directory) => {
  fs.readdir(directory, (err, files) => {
    if (err) {
      console.error('Error reading directory:', err);
      return;
    }

    files.forEach(file => {
      if (path.extname(file).toLowerCase() === '.svg') {
        const filePath = path.join(directory, file);
        fs.readFile(filePath, 'utf8', (err, data) => {
          if (err) {
            console.error(`Error reading file: ${filePath}`, err);
            return;
          }

          const updatedContent = updateSvgSize(data);
          fs.writeFile(filePath, updatedContent, 'utf8', (err) => {
            if (err) {
              console.error(`Error writing file: ${filePath}`, err);
              return;
            }
            console.log(`Updated size for file: ${filePath}`);
          });
        });
      }
    });
  });
};

// The directory path is 'pngfiles' relative to the script's location
const directoryPath = path.join(__dirname, 'spikes');
processSvgFiles(directoryPath);
