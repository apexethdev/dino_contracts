// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DinoData {

/// Dino Trait Struct
    struct TraitStruct {
        uint body;
        uint chest;
        uint eye;
        uint face;
        uint feet;
        uint head;
        uint spike;
    }

//// Store a dinos traits here - this is filled when minted!
    mapping(uint => TraitStruct) public tokenTraits;

//// Dino Eggs
    mapping(uint => uint) public DinoEggs;

//// Bodys of Dinos
        bytes[] internal body_data = [
                bytes(hex'06054893c507054893c508054893c509054892c406064893c507064893c508064893c509064893c50a064892c406074893c507074893c508074893c509074893c50a074892c406084893c507084893c508084893c504094893c506094893c507094893c508094893c509094892c4050a4893c5060a4893c5070a4893c5080a4893c5060b4892c4080b4892c4'),
                bytes(hex'0605c4cadf0705c4cadf0805c4cadf0905c4cadf0606aab8e30706aab8e30806aab8e30906aab8e30a06abb8e3060795a8e4070795a8e4080795a8e4090795a8e40a0795a8e406088199e407088199e408088199e40409728de60609728de60709718ee60809718ee60909728de6050a5e7ee2060a5e7ee2070a5e7ee2080a5f7ee2060b5275e2080b5275e2'),
                bytes(hex'06058ba4d507058ba4d508058ba4d509058ca2d206068ba4d507068ba4d508068ba4d509068ba4d50a068ca2d206078ba4d507078ba4d508078ba4d509078ba4d50a078ca2d206088ba4d507088ba4d508088ba4d504098ba4d506098ba4d507098ba4d508098ba4d509098ca2d2050a8ba4d5060a8ba4d5070a8ba4d5080a8ba4d5060b8ca2d2080b8ca2d2'),
                bytes(hex'0605acacac0705acacac0805acacac0905acaaa90606acacac0706acacac0806acacac0906acacac0a06acaaa90607acacac0707acacac0807acacac0907acacac0a07acaaa90608acacac0708acacac0808acacac0409ababab0609acacac0709acacac0809acacac0909acaaa9050aababab060aacacac070aacacac080aacacac060bacaaa9080bacaaa9'),
                bytes(hex'0605f0f0f00705f0f0f00805f0f0f00905f0f0f00606dadada0706dadada0806dadada0906dadada0a06dadada0607c3c3c30707c3c3c30807c3c3c30907c3c3c30a07c2c2c20608b1b1b10708b1b1b10808b1b1b104099b9b9b06099b9b9b07099b9b9b08099b9b9b09099a9b9b050a828282060a828282070a828282080a828283060b6d6d6d080b6d6d6d'),
                bytes(hex'0605c1d9cb0705c1d9cb0805c1d9cb0905c1d9cb0606acd4bd0706acd4bd0806acd4bd0906acd4bd0a06acd4bd06078ed0a907078ed0a908078ed0a909078ed0a90a078ed0a906086ace9407086ace9408086ace94040947d481060958d18a070958d18a080958d18a090958d18a050a47d481060a47d481070a47d481080a47d481060b30d273080b30d273'),
                bytes(hex'06056ab38707056ab38708056ab38709056bb18506066ab38707066ab38708066ab38709066ab3870a066bb18506076ab38707076ab38708076ab38709076ab3870a076bb18506086ab38707086ab38708086ab38704096ab28706096ab38707096ab38708096ab38709096bb185050a6ab287060a6ab387070a6ab387080a6ab387060b6bb185080b6bb185'),
                bytes(hex'0605c7dca40705c7dca40805c7dca40905c7dba20606c7dca40706c7dca40806c7dca40906c7dca40a06c7dba20607c7dca40707c7dca40807c7dca40907c7dca40a07c7dba20608c7dca40708c7dca40808c7dca40409c7daa20609c7dca40709c7dca40809c7dca40909c7dba2050ac7daa2060ac7dca4070ac7dca4080ac7dca4060bc7dba2080bc7dba2'),
                bytes(hex'0605e1d8d10705e1d8d10805e1d8d10905e1d8d10606dfc2ae0706dfc2ae0806dfc2ae0906dfc2ae0a06dfc2ae0607e1b08e0707e1b08e0807e1b08e0907e1b08e0a07e1b08e0608e5a57a0708e5a57a0808e4a57a0409e4955f0609e5955e0709e5955e0809e5955e0909e4955f050ae48442060ae48442070ae48442080ae48442060be37931080be37931'),
                bytes(hex'0605dbbdca0705dbbdc90805dbbdc90905dbbdca0606deadc20706deadc20806deadc20906deadc20a06deadc10607de9db80707de9db80807de9db80907de9db80a07de9db80608dd90b00708dd90b00808dd90b00409dc78a10609dc78a10709dc78a20809dc78a20909dc78a1050adc6c9b060adc6c9b070adc6c9b080adc6c9a060bdd6094080bdd6094'),
                bytes(hex'0605f2adbe0705f2adbe0805f2adbe0905f1acbc0606f2adbe0706f2adbe0806f2adbe0906f2adbe0a06f1acbc0607f2adbe0707f2adbe0807f2adbe0907f2adbe0a07f1acbc0608f2adbe0708f2adbe0808f2adbe0409f0abbb0609f2adbe0709f2adbe0809f2adbe0909f1acbc050af0abbb060af2adbe070af2adbe080af2adbe060bf1acbc080bf1acbc'),
                bytes(hex'0605bf61570705bf61570805bf61570905bf62570606cb88440706cb88440806cb88440906cb88440a06cb88440607ccb1440707ccb1440807ccb1440907ccb1440a07cbb14406086bc15607086bc15608086bc15704096391c506096391c507096391c508096391c509096391c4050a7956c6060a7956c6070a7956c6080a7957c5060bbe67c4080bbe67c4'),
                bytes(hex'0605ba4e460705ba4e460805ba4e460905b84e460606ba4e460706ba4e460806ba4e460906ba4e460a06b84e460607ba4e460707ba4e460807ba4e460907ba4e460a07b84e460608ba4e460708ba4e460808ba4e460409b84e460609ba4e460709ba4e460809ba4e460909b84e46050ab84e46060aba4e46070aba4e46080aba4e46060bb84e46080bb84e46'),
                bytes(hex'06056ec9d407056ec9d408056ec9d409056ecad406066ecad407066ec9d408066ec9d409066ec9d40a066ecad406076ecad407076ec9d408076ec9d409076ec9d40a076ecad406086ecad407086ec9d408086ec9d404096ecad406096ec9d407096ec9d408096ec9d409096ecad4050a6ec9d4060a6ec9d4070a6ec9d4080a6ecad4060b6ecad4080b6ecad4'),
                bytes(hex'0605d7d2aa0705d7d2aa0805d7d2aa0905d7d2aa0606dad1910706dad1910806dad1910906dad1910a06dad1910607dacf7e0707dacf7e0807dacf7e0907dacf7e0a07d9cf7e0608ded16f0708ded16f0808ddd1700409dfd15a0609e0d05a0709e0d05a0809e0d15a0909dfd15a050adecc47060adecc47070adecc47080addcc48060be1cd2c080be1cd2c'),
                bytes(hex'0605dac6780705dac6780805dac6780905dac6780606dac6780706dac6780806dac6780906dac6780a06dac6780607dac6780707dac6780807dac6780907dac6780a07dac6780608dac6780708dac6780808dac6780409d8c6790609dac6780709dac6780809dac6780909dac678050ad8c679060adac678070adac678080adac678060bdac678080bdac678')
        ];

	string[] internal body_traits = [
        'aqua',
        'blue gradient',
        'blue',
        'gray',
        'grayspace gradient',
        'green gradient',
        'green',
        'light green',
        'orange gradient',
        'pink gradient',
        'pink',
        'rainbow',
        'red',
        'teal',
        'yellow gradient',
        'yellow'
    ];

        uint[] internal  body_probability = [8, 11, 18, 27, 30, 33, 43, 53, 56, 59, 65, 67, 77, 87, 90, 100];

//// Chest of Dinos
        bytes[] internal chest_data = [
                bytes(hex'070834b9d2080834b9d2080934b9d2070a34b9d2080a34b9d2'),
                bytes(hex'07087a7acf08087a7acf08097a7acf070a7a7acf080a7a7acf'),
                bytes(hex'070878787808087878780809787878070a787878080a787878'),
                bytes(hex'07087abd7608087abd7608097abd76070a7abd76080a7abd76'),
                bytes(hex'0708dcdcdc0808dcdcdc0809dcdcdc070adcdcdc080adcdcdc'),
                bytes(hex'0708c98f590808c98f590809c98f59070ac98f59080ac98f59'),
                bytes(hex'0708d677550808d677550809d67755070ad67755080ad67755'),
                bytes(hex'0708c05e6a0808c05e6a0809c05e6a070ac05e6a080ac05e6a'),
                bytes(hex'0708d9d5740808d9d5740809d9d574070ad9d574080ad9d574')
        ];

	string[] internal chest_traits = [
        'aqua',       
        'blue',
        'gray',       
        'green',
        'light gray',
        'orange',     
        'orangered',
        'pink',       
        'yellow'
	];

        uint[] internal  chest_probability = [10, 18, 29, 42, 57, 68, 77, 89, 100];

//// Eyes of Dinos
        bytes[] internal eye_data = [
                bytes(hex'0706474dc40906c6a42c'),
                bytes(hex'07065e89c409065e89c4'),
                bytes(hex'07062828280906282828'),
                bytes(hex'07067a140109067a1401'),
                bytes(hex'070648c4470906d84236'),
                bytes(hex'07065fc57009065fc570'),
                bytes(hex'0706e024010806e024010906e024010a06e024010b06e024010c06e024010d06e024010e06e024010f06e02401'),
                bytes(hex'07069292910906929291'),
                bytes(hex'0706d480490906d48049'),
                bytes(hex'0706bd54410906bd5441'),
                bytes(hex'0706f4f4f40906f4f4f4'),
                bytes(hex'0706dec1300906dec130')
        ];

	string[] internal eye_traits = [
        'blue yellow', 
        'blue',
        'dark gray',   
        'dark red',
        'green red',   
        'green',
        'lazer',       
        'light gray',
        'orange',      
        'red',
        'white',       
        'yellow'
	];

        uint[] internal  eye_probability = [4, 19, 30, 36, 40, 48, 50, 58, 64, 70, 90, 100];


//// Face of Dinos
        bytes[] internal face_data = [
                bytes(hex''),
                bytes(hex'06053a3a3a07053a3a3a08053a3a3a09053a3a3a06063a3a3a08063a3a3a0a063a3a3a'),
                bytes(hex'06064a4a4a08064a4a4a0a064a4a4a'),
                bytes(hex'06051049e107051049e108051049e109051049e10a051049e104061049e105061049e106061049e108061049e10a061049e104071049e106071049e107071049e108071049e109071049e10a071049e1'),
                bytes(hex'0704b7b7b70804b7b7b70605b7b7b70705b7b7b70805b7b7b70905b7b7b70606b7b7b70806b7b7b70a06b7b7b70707b6b7b70907b6b7b70b07b6b7b7'),
                bytes(hex'0706ffffff0806ffffff0906ffffff')
        ];

	string[] internal face_traits = [
        'normal',
        'mask',
        'ninja',
        'based noun glasses',
        'skull',
        'vizor'
	];

        uint[] internal  face_probability = [65, 75, 85, 90, 95, 100];

//// Feet of Dinos
        bytes[] internal feet_data = [
                bytes(hex''),
                bytes(hex'0009dddddd000adddddd010adddddd000bdddddd020bdddddd000cdddddd010cdddddd020cdddddd030cdddddd010ddddddd030ddddddd050dc566bf060dc566bf070dc566bf080dc566c0'),
                bytes(hex'0108dededd0109dededd0209dedede020adededd030adedede010bdededd030bdededd040bdedede020cdededd040cdededd050cdedede060c181817070cdedede080c181817'),
                bytes(hex'040b7b4c390a0b7b4c39050c7a4b38060c7a4a38070c7a4a38080c7a4b38090c7a4b38060db9b0ac080db9b0ac')
        ];

	string[] internal feet_traits = [
        'normal', 
        'hoverboard', 
        'rocket boots', 
        'skateboard'
	];

        uint[] internal  feet_probability = [76, 84, 92, 100];

//// Heads of Dinos
        bytes[] internal head_data = [
                bytes(hex''),
                bytes(hex'06059957c907059957c908059957c909059957ca05069957ca04079957ca'),
                bytes(hex'0703318ec60803328ec50903318ec60504318ec60604318ec60704328ec50804328ec50904328ec5'),
                bytes(hex'06039356cb07039356cb08039356cb06049356cb07049557ca08049557ca09049557ca0a049457ca'),
                bytes(hex'0602eaeaea0702eaeaea0802e9e9e90603eaeaea0703eaeaea0803e9e9e90604eaeaea0704eaeaea0804e9e9e9'),
                bytes(hex'0503f0a92a0703f1a9290903f0a92a0504f1a9290604f0a82b0704f0a82a0804f1a92a0904f0a92a'),
                bytes(hex'05043d3d3d06043d3d3d07043d3d3d08043d3d3d05053d3d3d05063d3d3d06063d3d3d05073d3d3d06073d3d3d'),
                bytes(hex'0603bf5dca0703bf5dca0803be5dca0504bf5dca0604bf5dca0704bf5dca0804bf5dca0904bf5dca0a04be5dca'),
                bytes(hex'05049f9f9f06049f9f9f08049f9f9f09049f9f9f05059f9f9f'),
                bytes(hex'0703e6b32e0803e6b22d0604e6b32e0704e6b32e0804e6b32e0904e6b22d'),
                bytes(hex'0703dbdbdb0803dbdbdb0903dadadb0504c245360604c245360704c245360804c245360904c24536')
        ];

	string[] internal head_traits = [
        'none',
        'bandana',
        'cap backwards',
        'cap forwards',
        'chef',
        'crown',
        'headphones',
        'long peak cap forwards',
        'mouse ears',
        'silly yellow bucket hat',
        'two tone cap backwards'
	];

        uint[] internal  head_probability = [45, 48, 57, 67, 71, 74, 78, 86, 88, 92, 100];

/////////////////// Spikes of Dinos
        bytes[] internal spike_data = [
                bytes(hex''),
                bytes(hex'06044169a908044169a905054169a905074169a905094169a9'),
                bytes(hex'0604c16e480804c16e480505c16e480507c16e480509c16e48'),
                bytes(hex'06044140400804414040050541404005074140400509414040'),
                bytes(hex'06046bb37308046bb37305056bb37305076bb37305096bb373'),
                bytes(hex'0604b3b3b30804b3b3b30505b3b3b30507b3b3b30509b3b3b3'),
                bytes(hex'0604a3d8760804a67ad20505d4995e050776a7d80509dc5964'),
                bytes(hex'0604d68f380804d68f380505d68f380507d68f380509d68f38'),
                bytes(hex'0604c466c40804c466c40505c466c40507c466c40509c466c4'),
                bytes(hex'0604c568660804c568660505c568660507c568660509c56866'),
                bytes(hex'06045eaeb108045eaeb105055eaeb105075eaeb105095eaeb1'),
                bytes(hex'0604eeeeee0804eeeeee0505eeeeee0507eeeeee0509eeeeee'),
                bytes(hex'0604ccae520804ccae520505ccae520507ccae520509ccae52')
        ];

	string[] internal spike_traits = [
        'none',     
        'blue',       
        'burnt orange',
        'dark gray',  
        'green',
        'light gray', 
        'multicolor',
        'orange',
        'pink',       
        'red',
        'teal',       
        'white',
        'yellow'
	];

        uint[] internal  spike_probability = [4, 12, 20, 30, 38, 49, 52, 60, 68, 76, 84, 92, 100];

}