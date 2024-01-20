const fs = require('fs');
const path = require('path');
const cheerio = require('cheerio');

// Function to convert decimal values to a hex string
function decimalToHex(values) {
  const buffer = Buffer.from(values);
  const hexString = buffer.toString('hex');
  return `0x${hexString}`;
}

// Load the SVG content
const svgFilePath = path.join(__dirname, '..', 'traits/svg/chest', 'aqua.svg');
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

console.log(hexRepresentation);
