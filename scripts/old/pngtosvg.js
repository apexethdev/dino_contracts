const sharp = require('sharp');
const fs = require('fs');
const path = require('path');

// Function to create an SVG rectangle element
const createSvgRect = (x, y, color) => {
  return `<rect x="${x}" y="${y}" width="1" height="1" fill="rgb(${color.r},${color.g},${color.b})" />`;
};

// Main function to convert PNG to SVG
const convertPngToSvg = async (inputPath, outputPath) => {
  try {
    // Read the image and ensure it has an alpha channel
    const image = sharp(inputPath).ensureAlpha();

    // Get image metadata to extract size and to iterate over pixels
    const metadata = await image.metadata();

    // Use raw output to get an uncompressed pixel buffer
    const buffer = await image.raw().toBuffer();

    // Initialize SVG parts
    let svgElements = [];

    // Process the image buffer pixel by pixel
    for (let y = 0; y < metadata.height; y++) {
      for (let x = 0; x < metadata.width; x++) {
        const offset = (metadata.width * y + x) * 4; // 4 channels (RGBA)
        const r = buffer[offset];
        const g = buffer[offset + 1];
        const b = buffer[offset + 2];
        const a = buffer[offset + 3];

        // Skip fully transparent pixels
        if (a !== 0) {
          svgElements.push(createSvgRect(x, y, { r, g, b }));
        }
      }
    }

    // Combine SVG parts into a single document
    const svgContent = `<svg width="${metadata.width}" height="${metadata.height}" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${metadata.width} ${metadata.height}">\n${svgElements.join('\n')}</svg>`;

    // Write the SVG content to a file
    fs.writeFileSync(outputPath, svgContent);
    console.log(`SVG file written to ${outputPath}`);
  } catch (err) {
    console.error('Error converting PNG to SVG:', err);
  }
};

// Replace 'input.png' and 'output.svg' with your file names/paths
const inputPngPath = 'green.png';
const outputSvgPath = 'green.svg';

convertPngToSvg(inputPngPath, outputSvgPath);
