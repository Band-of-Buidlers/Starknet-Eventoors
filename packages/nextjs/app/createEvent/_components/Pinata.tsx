// require("dotenv").config();
const { PINATA_API_KEY, PINATA_SECRET_KEY, PINATA_JWT } = process.env;

const pinataSDK = require("@pinata/sdk");
const pinata = new pinataSDK(PINATA_API_KEY, PINATA_SECRET_KEY);

const options = {
  // pinataMetadata: {
  //     name: MyCustomName,
  //     keyvalues: {
  //         customKey: 'customValue',
  //         customKey2: 'customValue2'
  //     }
  // },
  // pinataOptions: {
  //     cidVersion: 0
  // }
};

export async function pinataJSON(body) {
  const res = await pinata.pinJSONToIPFS(body, options);
  console.log("====================");
  console.log(res);
  console.log("====================");
}

// pinata
//   .testAuthentication()
//   .then((result) => {
//     console.log(result);
//   })
//   .catch((err) => {
//     console.log(err);
//   });

// async function pinJSONToIPFS() {
//   try {
//     const data = JSON.stringify({
//       pinataContent: {
//         name: "Pinnie",
//         description: "A really sweet NFT of Pinnie the Pinata",
//         image: "ipfs://bafkreih5aznjvttude6c3wbvqeebb6rlx5wkbzyppv7garjiubll2ceym4",
//         external_url: "https://pinata.cloud/"
//       },
//       pinataMetadata: {
//         name: "metadata.json"
//       }
//     })
//     const res = await fetch("https://api.pinata.cloud/pinning/pinJSONToIPFS", {
//       method: "POST",
//       headers: {
//         'Content-Type': 'application/json',
//         Authorization: Bearer ${PINATA_JWT},
//       },
//       body: data,
//     });
//     const resData = await res.json();
//     console.log(resData);
//   } catch (error) {
//     console.log(error);
//   }
// };

// await pinJSONToIPFS();
