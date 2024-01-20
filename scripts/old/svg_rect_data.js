const fs = require('fs');
const path = require('path');
const cheerio = require('cheerio');

const svgFilePath = path.join(__dirname, '..', '/old/', 'test.svg');
const svgContent = fs.readFileSync(svgFilePath, 'utf8');
const $ = cheerio.load(svgContent, { xmlMode: true });

let output = '';

$('rect').each((index, element) => {
  const x = $(element).attr('x');
  const y = $(element).attr('y');
  let rgb = $(element).attr('fill');

  // Remove 'rgb' and parentheses from the rgb string
  rgb = rgb.replace(/rgb|\(|\)/g, '');

  output += `${x},${y},${rgb},`;
});

// Remove the trailing comma
output = output.slice(0, -1);

console.log(output);
