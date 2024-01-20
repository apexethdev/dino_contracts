function decimalToHex(values) {
    const buffer = Buffer.from(values);
    const hexString = buffer.toString('hex');
    return `0x${hexString}`;
}

const inputValues = [7,8,52,185,210,8,8,52,185,210,8,9,52,185,210,7,10,52,185,210,8,10,52,185,210];
const hexRepresentation = decimalToHex(inputValues);

console.log(hexRepresentation);
