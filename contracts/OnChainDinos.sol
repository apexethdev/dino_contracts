//SPDX-License-Identifier: MIT  
pragma solidity ^0.8.20;
  
import "erc721a/contracts/ERC721A.sol";  
import "@openzeppelin/contracts/access/Ownable.sol";
import "contracts/helpers/DinoData.sol";
import "base64-sol/base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

///// Based OnChain Dinos
///// Developed by Apex777.eth - @Apex_Ether
contract OnChainDinos is ERC721A, Ownable, DinoData, ReentrancyGuard  {  

    address public deployer;
    bytes32 private lastBlockHash;
    uint256 private lastBlockNumber;

    /// Mint Settings
    uint     public maxSupply    = 2000;
    uint     public mintPrice    = 0.0025 ether;
    uint     public maxFree      = 500;
    uint     public freeCount    = 0;
    bool     public mintEnabled  = false;

    /// Mint Rules
    uint     public maxMintPerTrans = 20;
    uint     public maxMintPerWallet = 100;

    /// Whitelist Settings
    mapping(address => uint) public mintAmount;
    mapping(address => bool) public whiteListed;

    /// Whitelist setup
    address public listController;

    modifier onlylistController() {
        require(msg.sender == listController, "Controller Only");
        _;
    }


    constructor() ERC721A("Based OnChain Dinos", "DINO") Ownable(msg.sender){
        deployer = msg.sender;
        listController = 0x85FD82fec33A00953227Ea82649a6Cb5572BE6A0;
        lastBlockHash = blockhash(block.number - 1);
        lastBlockNumber = block.number;
        _reserveDino(); /// Apex gets to pick their Dino!! 
    }

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function mint(uint256 quantity) external payable {
        uint256 cost = mintPrice;
        require(mintEnabled, "Mint not ready yet");
        require(msg.value == quantity * cost, "Please send the exact ETH amount");
        require(quantity <= maxMintPerTrans, "Exceeds max mint per transaction");

        // Check if the mint quantity exceeds the per wallet limit
        uint256 totalMintedByWallet = mintAmount[msg.sender] + quantity;
        require(totalMintedByWallet <= maxMintPerWallet, "Exceeds max mint per wallet");
        mintAmount[msg.sender] = mintAmount[msg.sender] + totalMintedByWallet;

        // Start minting
        _internalMint(quantity);
    }

    function free_mint() external {
        require(whiteListed[msg.sender] == true, "Not on whitelist");
        require(mintEnabled, "Mint not ready yet");
        require(freeCount + 1 <= maxFree, "No more free Dinos!");

        whiteListed[msg.sender] = false;
        freeCount = freeCount + 1;

        // Start minting
        _internalMint(1);

    }

    function _internalMint(uint256 quantity) internal  {

        require(_totalMinted() + quantity <= maxSupply, "Sold Out!");
        require(msg.sender == tx.origin, "The minter is another contract");

        // What token do we start minting with?
        uint startTokenID = _startTokenId() + _totalMinted();
        uint mintUntilTokenID =  quantity + startTokenID;

        for(uint256 tokenId = startTokenID; tokenId < mintUntilTokenID; tokenId++) {

            /// got get our random traits
            uint[7] memory randomSeeds = _randomSeed(lastBlockHash,tokenId);

            /// set this new dinos traits!
            _setDinoTraits(tokenId, randomSeeds);

            _setDinoEggs(tokenId);

        }
        lastBlockHash = blockhash(block.number - 1);
        lastBlockNumber = block.number;
        _safeMint(msg.sender, quantity);

    }

    function _randomSeed(bytes32 _lastBlockHash, uint256 _tokenId) internal pure returns (uint[7] memory _randomSeeds) {
        // Initial seed
        _randomSeeds[0] = uint256(keccak256(abi.encodePacked(_lastBlockHash, _tokenId))) % 101;

        // Generate subsequent seeds
        for (uint i = 1; i < 7; i++) {
            _randomSeeds[i] = uint256(keccak256(abi.encodePacked(_randomSeeds[i - 1], _tokenId))) % 101;
        }

        return _randomSeeds;
    }

    function _setDinoTraits(uint _tokenID, uint[7] memory _randomSeeds) internal {
        // Randomly select traits
        uint randBody   = _pickTraitByProbability(_randomSeeds[0], body_data, body_probability);
        uint randChest  = _pickTraitByProbability(_randomSeeds[1], chest_data, chest_probability);
        uint randEyes   = _pickTraitByProbability(_randomSeeds[2], eye_data, eye_probability);
        uint randHead   = _pickTraitByProbability(_randomSeeds[3], head_data, head_probability);
        uint randFeet   = _pickTraitByProbability(_randomSeeds[4], feet_data, feet_probability);
        uint randSpikes = _pickTraitByProbability(_randomSeeds[5], spike_data, spike_probability);
        uint randFace   = _pickTraitByProbability(_randomSeeds[6], face_data, face_probability);


        TraitStruct memory newTraits = TraitStruct({
            body: randBody,
            chest: randChest,
            eye: randEyes,
            face: randFace,
            feet: randFeet,
            head: randHead,
            spike: randSpikes
        });

        // Assign the generated traits to the token
        tokenTraits[_tokenID] = newTraits;

    }

    function _pickTraitByProbability(uint seed, bytes[] memory traitArray, uint[] memory traitProbability) internal pure returns (uint) {
        require(traitArray.length > 0, "Elements array is empty");
        require(traitArray.length == traitProbability.length, "Elements and weights length mismatch");
        
        for (uint i = 0; i < traitProbability.length; i++) {
            if(seed < traitProbability[i]) {
                return i;
            }
        }
        // Fallback, return first element as a safe default
        return 0;
    }

    function _setDinoEggs(uint _tokenID) internal {
        uint eggsCount = uint256(keccak256(abi.encodePacked(lastBlockNumber, _tokenID))) % 999 + 1;
        DinoEggs[_tokenID] = eggsCount;
    }

    function _reserveDino() internal {
        uint startTokenID = _startTokenId() + _totalMinted();
        TraitStruct memory newTraits = TraitStruct({
            body: 11,
            chest: 4,
            eye: 10,
            face: 2,
            feet: 0,
            head: 0,
            spike: 6
        });
        tokenTraits[startTokenID] = newTraits;
        _setDinoEggs(startTokenID);
        freeCount = freeCount +1;
        _safeMint(0x777c47498b42dbe449fB4cB810871A46cD777777, 1);
    }


    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        // Get image
        string memory image = buildSVG(tokenId);

        // Encode SVG data to base64
        string memory base64Image = Base64.encode(bytes(image));

        // Build JSON metadata
        string memory json = string(
            abi.encodePacked(
                '{"name": "OnChain Dinos #', Strings.toString(tokenId), '",',
                '"description": "OnChain Dinos have hatched on Base - 100% stored on the Blockchain",',
                '"attributes": [', _getDinoTraits(tokenId), '],',
                '"image": "data:image/svg+xml;base64,', base64Image, '"}'
            )
        );

        // Encode JSON data to base64
        string memory base64Json = Base64.encode(bytes(json));

        // Construct final URI
        return string(abi.encodePacked('data:application/json;base64,', base64Json));
    }

    function buildSVG(uint tokenid) public view returns (string memory) {

        require(_exists(tokenid), "Token does not exist");

        TraitStruct memory localTraits = tokenTraits[tokenid];

        string memory svg = string(abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" shape-rendering="crispEdges" width="512" height="512">',
        '<rect width="16" height="16" fill="#99ccff"/>',
            _getSVGTraitData(body_data[localTraits.body]),
            _getSVGTraitData(chest_data[localTraits.chest]),
            _getSVGTraitData(eye_data[localTraits.eye]),
            _getSVGTraitData(spike_data[localTraits.spike]),
            _getSVGTraitData(feet_data[localTraits.feet]),
            _getSVGTraitData(face_data[localTraits.face]),
            _getSVGTraitData(head_data[localTraits.head]),
        '</svg>'
        ));
        return svg;

    }

    function _getSVGTraitData(bytes memory data) internal pure returns (string memory) {

        require(data.length % 5 == 0, "Invalid number of reacts");

        /// if empty this is a transparent react
        if (data.length == 0) {
             return "<rect x=\"0\" y=\"0\" width=\"0\" height=\"0\" fill=\"rgb(0,0,0)\"/>"; 
        }

        // Initialize arrays to store values
        uint reactCount = data.length / 5;


        /// react string to return
        string memory rects;

        uint[] memory x = new uint[](reactCount);
        uint[] memory y = new uint[](reactCount);
        uint[] memory r = new uint[](reactCount);
        uint[] memory g = new uint[](reactCount);
        uint[] memory b = new uint[](reactCount);

        // Iterate through each react and get the values we need
        for (uint i = 0; i < reactCount; i++) {

            // Convert and assign values to respective arrays
            x[i] = uint8(data[i * 5]);
            y[i] = uint8(data[i * 5 + 1]);
            r[i] = uint8(data[i * 5 + 2]);
            g[i] = uint8(data[i * 5 + 3]);
            b[i] = uint8(data[i * 5 + 4]);

            // Convert uint values to strings
            string memory xStr = Strings.toString(x[i]);
            string memory yStr = Strings.toString(y[i]);
            string memory rStr = Strings.toString(r[i]);
            string memory gStr = Strings.toString(g[i]);
            string memory bStr = Strings.toString(b[i]);

            rects = string(abi.encodePacked(rects, '<rect x="', xStr, '" y="', yStr, '" width="1" height="1" fill="rgb(', rStr, ',', gStr, ',', bStr, ')" />'));
        }

        return rects;
    }

    function _getDinoTraits(uint tokenid) internal view returns (string memory) {

        TraitStruct memory traits = tokenTraits[tokenid];

        string memory DinoEggs = Strings.toString(DinoEggs[tokenid]);

        string memory metadata = string(abi.encodePacked(
        '{"trait_type":"Dino Eggs","display_type": "number", "value":"', DinoEggs, '"},',
        '{"trait_type":"Body", "value":"', body_traits[traits.body], '"},',
        '{"trait_type":"Chest", "value":"', chest_traits[traits.chest], '"},',
        '{"trait_type":"Eyes", "value":"', eye_traits[traits.eye], '"},',
        '{"trait_type":"Face", "value":"', face_traits[traits.face], '"},',
        '{"trait_type":"Feet", "value":"', feet_traits[traits.feet], '"},',
        '{"trait_type":"Head", "value":"', head_traits[traits.head], '"},',
        '{"trait_type":"Spikes", "value":"', spike_traits[traits.spike], '"}'
        ));

        return metadata;

    }


//// Admin methods
    function toggleMinting() external onlyOwner {
        mintEnabled = !mintEnabled;
    }

    function setMaxFree(uint _newMaxFree) external onlyOwner {
        maxFree = _newMaxFree;
    }

    function devMint(uint _quantity) external onlyOwner {
        _internalMint(_quantity);
    }

    function addToWhiteList(address[] calldata addresses) external onlylistController nonReentrant {
        for (uint i = 0; i < addresses.length; i++) {
            whiteListed[addresses[i]] = true;
        }
    }

    function changelistController(address _address) external onlyOwner {
        listController = _address;
    }

    function withdraw() external onlyOwner nonReentrant {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

}