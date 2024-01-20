const fs = require('fs');
const path = require('path');
const cheerio = require('cheerio');

// Function to convert decimal values to a hex string
function decimalToHex(values) {
  const buffer = Buffer.from(values);
  const hexString = buffer.toString('hex');
  return `hex'${hexString}'`;
}

// Function to process an SVG file
function processSvgFile(svgFilePath) {
  const svgContent = fs.readFileSync(svgFilePath, 'utf8');
  const $ = cheerio.load(svgContent, { xmlMode: true });

  let rectData = [];

  $('rect').each((index, element) => {
    const x = parseInt($(element).attr('x'));
    const y = parseInt($(element).attr('y'));
    const fill = $(element).attr('fill').replace(/rgb|\(|\)/g, '').split(',');

    // Parse each RGB value to integer and add them to the rectData array
    const rgbValues = fill.map(value => parseInt(value));
    rectData.push(x, y, ...rgbValues);
  });

  // Convert the collected decimal values to a hex string
  const hexRepresentation = decimalToHex(rectData);
  return hexRepresentation;
}

// Function to process all SVG files in the directory and write results to a Solidity array file
function processAllSvgFiles(directory) {
  const results = [];
  const folderName = path.basename(directory);

  fs.readdirSync(directory).forEach(file => {
    if (path.extname(file).toLowerCase() === '.svg') {
      const filePath = path.join(directory, file);
      const hexResult = processSvgFile(filePath);
      results.push(`\t\tbytes(${hexResult})`);
    }
  });

  const solidityArray = `// ${folderName} of Dinos\nbytes[] internal ${folderName.toLowerCase()} = [\n${results.join(',\n')}\n];`;

  const outputFilename = `${folderName.toLowerCase()}.sol`;
  const outputPath = path.join(__dirname, outputFilename);
  fs.writeFileSync(outputPath, solidityArray, 'utf8');
  console.log(`Solidity array written to ${outputPath}`);
}

// Directory path to the SVG files
const directoryPath = path.join(__dirname, '..', 'traits/svg/body');
processAllSvgFiles(directoryPath);
