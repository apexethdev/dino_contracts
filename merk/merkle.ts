import { MerkleTree } from 'merkletreejs';
import { utils } from 'ethers';

const addresses: string[] = [
  '0x7ed32863ed1451241a77898d5dafab7773a94465',
  '0x777c47498b42dbe449fb4cb810871a46cd777777',
];

const tree = new MerkleTree(
  addresses.map(utils.keccak256),
  utils.keccak256,
  { sortPairs: true },
);

console.log('the Merkle root is:', tree.getRoot().toString('hex'));

export function getMerkleRoot() {
  return tree.getRoot().toString('hex');
}

export function getMerkleProof(address: string) {
  const hashedAddress = utils.keccak256(address);
  return tree.getHexProof(hashedAddress);
}