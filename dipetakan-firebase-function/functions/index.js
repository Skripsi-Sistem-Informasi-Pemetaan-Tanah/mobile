const { Client } = require('pg');
const admin = require('firebase-admin');
const functions = require('firebase-functions');
const axios = require('axios');
// const { Timestamp } = require('firebase-admin/firestore');

// Initialize Firestore
admin.initializeApp();
const db = admin.firestore();

// Replace with your PostgreSQL and base URL
const baseUrl = 'http://localhost:5000';
const client = new Client({
  user: 'dba',
  host: '13.213.13.138',
  database: 'dipetakan',
  password: '12345678peta',
  port: 5432,
});



// HTTP Cloud Function to handle requests
// HTTP Cloud Function to handle requests
// exports.fetchDataFromPostgresql = functions.https.onRequest(async (req, res) => {
//   console.log('Function fetchDataFromPostgresql started');

//   try {
//     // Connect to PostgreSQL
//     await client.connect();
//     console.log('Connected to PostgreSQL');
    
//     // Listen for PostgreSQL notifications from 'map_changes'
//     await client.query('LISTEN map_changes');
//     console.log('Listening for PostgreSQL notifications');

//     // PostgreSQL notification listener
//     client.on('notification', async (msg) => {
//       console.log(`Received notification from PostgreSQL: ${msg.channel}, payload: ${msg.payload}`);
  
//       // Check if the notification is from 'map_changes'
//       if (msg.channel === 'map_changes') {
//         console.log('Triggering fetchDataFromPostgresql...');
//         await fetchData();
//       }
//     });

//     // Fetch data from getAllLahan endpoint and update Firestore
//     async function fetchData() {
//       const url = `${baseUrl}/getAllLahan`;

//       try {
//         const response = await axios.get(url);
//         console.log('Received response from PostgreSQL:', JSON.stringify(response.data, null, 2));

//         if (response.status === 200) {
//           const { data: responseData } = response; // Destructuring assignment

//           if (responseData.hasOwnProperty('data') && responseData.data.hasOwnProperty('lahan')) {
//             const lahanData = responseData.data.lahan;

//             if (Array.isArray(lahanData)) {
//               const batch = db.batch(); // Create a new batch

//               for (const lahan of lahanData) {
//                 const userId = lahan.user_id;
//                 const mapId = lahan.map_id;
//                 const lahanRef = db.collection('Users').doc(userId).collection('Lahan').doc(mapId);

//                 // Convert updated_at in lahan to formatted string (optional)
//                 if (lahan.hasOwnProperty('updated_at')) {
//                   const updatedAtString = lahan.updated_at;
//                   const updatedAt = new Date(updatedAtString);
//                   const formattedUpdatedAt = updatedAt.toLocaleString("en-US", {
//                     timeZone: "Asia/Bangkok", // Adjust for UTC+7 (Bangkok)
//                     weekday: "long",
//                     month: "long",
//                     day: "numeric",
//                     year: "numeric",
//                     hour: "numeric",
//                     minute: "numeric",
//                     hour12: true, // Use 12-hour format
//                   });
//                   lahan.formatted_updated_at = formattedUpdatedAt; // Add a new field for formatted string
//                 }

//                 const lahanDataToUpdate = {
//                   koordinat: lahan.koordinat ? lahan.koordinat : [],
//                   verifikasi: lahan.verifikasi ? lahan.verifikasi : [],
//                   updated_at: lahan.formatted_updated_at || lahan.updated_at // Use formatted or original updated_at
//                 };

//                 // Convert updated_at in verifikasi to formatted string (optional)
//                 if (lahan.hasOwnProperty('verifikasi')) {
//                   const verifikasiList = lahan.verifikasi;

//                   for (const verifikasi of verifikasiList) {
//                     if (verifikasi.hasOwnProperty('updated_at')) {
//                       const verifikasiUpdatedAtString = verifikasi.updated_at;
//                       const verifikasiUpdatedAt = new Date(verifikasiUpdatedAtString);
//                       const formattedVerifikasiUpdatedAt = verifikasiUpdatedAt.toLocaleString("en-US", {
//                         timeZone: "Asia/Bangkok", // Adjust for UTC+7 (Bangkok)
//                         weekday: "long",
//                         month: "long",
//                         day: "numeric",
//                         year: "numeric",
//                         hour: "numeric",
//                         minute: "numeric",
//                         hour12: true, // Use 12-hour format
//                       });
//                       verifikasi.updated_at = formattedVerifikasiUpdatedAt; // Add a new field for formatted string
//                     }
//                   }

//                   lahanDataToUpdate.verifikasi = verifikasiList;
//                 }

//                 // Add update to the batch
//                 batch.set(lahanRef, lahanDataToUpdate, { merge: true });
//               }

//               // Commit the batch write
//               await batch.commit();

//               console.log('Data updated successfully in Firestore');
//               res.status(200).send('Data updated successfully in Firestore');
//             } else {
//               console.error('lahanData is not an array:', lahanData);
//               res.status(400).send('Invalid data format: lahanData is not an array');
//             }
//           } else {
//             console.error('Response from PostgreSQL is missing "lahan" property');
//             res.status(400).send('Invalid data format from PostgreSQL');
//           }
//         } else {
//           console.error('Failed to fetch data, status code:', response.status);
//           res.status(500).send('Failed to fetch data from PostgreSQL');
//         }
//       } catch (error) {
//         console.error('Error fetching data from PostgreSQL:', error);
//         res.status(500).send('Error fetching data from PostgreSQL');
//       }
//     }
//   } catch (error) {
//     console.error('Error connecting to PostgreSQL:', error);
//     res.status(500).send('Error connecting to PostgreSQL');
//   } finally {
//     // Ensure client is closed properly
//     await client.end();
//   }
// });

// exports.fetchDataFromPostgresql = functions.https.onRequest(async (req, res) => {
//   console.log('Function fetchDataFromPostgresql started');
//   const url = `${baseUrl}/getAllLahan`;

//   try {
//     const response = await axios.get(url);
//     console.log('Received response from PostgreSQL:', response.data);

//     if (response.status == 200) {
//       const responseData = response.data;

//       if (responseData.hasOwnProperty('lahan')) {
//         const lahanData = responseData.lahan;

//         for (const lahan of lahanData) {
//           const userId = lahan.user_id;
//           const mapId = lahan.map_id;
//           const lahanRef = db.collection('Lahan').doc(mapId);

//           // Convert updated_at in lahan to Firestore Timestamp
//           if (lahan.hasOwnProperty('updated_at')) {
//             const updatedAtString = lahan.updated_at;
//             const updatedAt = new Date(updatedAtString);
//             const updatedAtTimestamp = admin.firestore.Timestamp.fromDate(updatedAt);
//             lahan.updated_at = updatedAtTimestamp;
//           }

//           const lahanDataToUpdate = {
//             koordinat: lahan.koordinat ? lahan.koordinat : [],
//             verifikasi: lahan.verifikasi ? lahan.verifikasi : [],
//             updated_at: lahan.updated_at
//           };

//           // Convert updated_at in verifikasi to Firestore Timestamp
//           if (lahan.hasOwnProperty('verifikasi')) {
//             const verifikasiList = lahan.verifikasi;

//             for (const verifikasi of verifikasiList) {
//               if (verifikasi.hasOwnProperty('updated_at')) {
//                 const verifikasiUpdatedAtString = verifikasi.updated_at;
//                 const verifikasiUpdatedAt = new Date(verifikasiUpdatedAtString);
//                 const verifikasiUpdatedAtTimestamp = admin.firestore.Timestamp.fromDate(verifikasiUpdatedAt);
//                 verifikasi.updated_at = verifikasiUpdatedAtTimestamp;
//               }
//             }

//             lahanDataToUpdate.verifikasi = verifikasiList;
//           }

//           try {
//             // console.log(`Updating Firestore for mapId: ${mapId}`);
//             // await lahanRef.set(lahanDataToUpdate, { merge: true });

//             // const userLahanRef = db.collection('Users').doc(userId).collection('Lahan').doc(mapId);
//             // await userLahanRef.set(lahanDataToUpdate, { merge: true });

//             // Update the document
//       await db
//       .collection('Users')
//       .doc(userId)
//       .collection('Lahan')
//       .doc(mapId)
//       .set(lahanDataToUpdate, { merge: true });

//             console.log(`Successfully updated Firestore for mapId: ${mapId}`);
//           } catch (updateError) {
//             console.error(`Error updating Firestore for mapId: ${mapId}`, updateError);
//           }
//         }
//       }

//       console.log('Data updated successfully in Firestore');
//       res.status(200).send('Data updated successfully in Firestore');
//     } else {
//       console.error('Failed to fetch data, status code:', response.status);
//       res.status(response.status).send('Failed to fetch data');
//     }
//   } catch (error) {
//     console.error('Error fetching data from PostgreSQL:', error);
//     res.status(500).send('Error fetching data from PostgreSQL');
//   }
// });

exports.fetchDataFromPostgresql = functions.https.onRequest(async (req, res) => {
  console.log('Function fetchDataFromPostgresql started');
  const url = `${baseUrl}/getAllLahan`;

  try {
    const response = await axios.get(url);
    console.log('Received response from PostgreSQL:', response.data);

    if (response.status === 200) {
      const { data: responseData } = response; // Destructuring assignment

      if (responseData.hasOwnProperty('data') && responseData.data.hasOwnProperty('lahan')) {
        const lahanData = responseData.lahan;
        const batch = db.batch(); // Create a new batch

        for (const lahan of lahanData) {
          const userId = lahan.user_id;
          const mapId = lahan.map_id;
          const lahanRef = db.collection('Users').doc(userId).collection('Lahan').doc(mapId);

          // Convert updated_at in lahan to Firestore Timestamp
          if (lahan.hasOwnProperty('updated_at')) {
            const updatedAtString = lahan.updated_at;
            const updatedAt = new Date(updatedAtString);
            const updatedAtTimestamp = admin.firestore.Timestamp.fromDate(updatedAt);
            lahan.updated_at = updatedAtTimestamp;
          }

          const lahanDataToUpdate = {
            koordinat: lahan.koordinat ? lahan.koordinat : [],
            verifikasi: lahan.verifikasi ? lahan.verifikasi : [],
            updated_at: lahan.updated_at
          };

          // Convert updated_at in verifikasi to Firestore Timestamp
          if (lahan.hasOwnProperty('verifikasi')) {
            const verifikasiList = lahan.verifikasi;

            for (const verifikasi of verifikasiList) {
              if (verifikasi.hasOwnProperty('updated_at')) {
                const verifikasiUpdatedAtString = verifikasi.updated_at;
                const verifikasiUpdatedAt = new Date(verifikasiUpdatedAtString);
                const verifikasiUpdatedAtTimestamp = admin.firestore.Timestamp.fromDate(verifikasiUpdatedAt);
                verifikasi.updated_at = verifikasiUpdatedAtTimestamp;
              }
            }

            lahanDataToUpdate.verifikasi = verifikasiList;
          }

          // Add update to the batch
          batch.set(lahanRef, lahanDataToUpdate, { merge: true });
        }

        // Commit the batch write
        await batch.commit();

        console.log('Data updated successfully in Firestore');
        res.status(200).send('Data updated successfully in Firestore');
      } else {
        console.error('Response from PostgreSQL is missing "lahan" property');
        res.status(400).send('Invalid data format from PostgreSQL');
        return;
      }
    } else {
      console.error('Failed to fetch data, status code:', response.status);
      res.status(response.status).send('Failed to fetch data');
    }
  } catch (error) {
    console.error('Error fetching data from PostgreSQL:', error);
    res.status(500).send('Error fetching data from PostgreSQL');
  }
});

exports.fetchDataFromPostgresql = functions.https.onRequest(async (req, res) => {
  console.log('Function fetchDataFromPostgresql started');
  const url = `${baseUrl}/getAllLahan`;

  try {
    const response = await axios.get(url);
    console.log('Received response from PostgreSQL:', JSON.stringify(response.data, null, 2));

    if (response.status === 200) {
      const { data: responseData } = response; // Destructuring assignment

      if (responseData.hasOwnProperty('data') && responseData.data.hasOwnProperty('lahan')) {
        const lahanData = responseData.data.lahan;

        if (Array.isArray(lahanData)) {
          const batch = db.batch(); // Create a new batch

          for (const lahan of lahanData) {
            const userId = lahan.user_id;
            const mapId = lahan.map_id;
            const lahanRef = db.collection('Users').doc(userId).collection('Lahan').doc(mapId);

            // Convert updated_at in lahan to Firestore Timestamp
            // if (lahan.hasOwnProperty('updated_at')) {
            //   const updatedAtString = lahan.updated_at;
            //   const updatedAt = new Date(updatedAtString);
            //   const updatedAtTimestamp = admin.firestore.Timestamp.fromDate(updatedAt);
            //   lahan.updated_at = updatedAtTimestamp;
            // }

            if (lahan.hasOwnProperty('updated_at')) {
              const updatedAtString = lahan.updated_at;
              const updatedAt = new Date(updatedAtString);
              // const updatedAttoDate = updatedAt.toDate(); // Convert Firestore timestamp to JS Date object
              const formattedUpdatedAt = updatedAt.toLocaleString("en-US", {
                timeZone: "Asia/Bangkok", // Adjust for UTC+7 (Bangkok)
                weekday: "long",
                month: "long",
                day: "numeric",
                year: "numeric",
                hour: "numeric",
                minute: "numeric",
                hour12: true, // Use 12-hour format
              });
              lahan.formatted_updated_at = formattedUpdatedAt; // Add a new field for formatted string
            }
            

            const lahanDataToUpdate = {
              koordinat: lahan.koordinat ? lahan.koordinat : [],
              verifikasi: lahan.verifikasi ? lahan.verifikasi : [],
              updated_at: lahan.formatted_updated_at
            };

            // Convert updated_at in verifikasi to Firestore Timestamp
            if (lahan.hasOwnProperty('verifikasi')) {
              const verifikasiList = lahan.verifikasi;

              for (const verifikasi of verifikasiList) {
                if (verifikasi.hasOwnProperty('updated_at')) {
                  const verifikasiUpdatedAtString = verifikasi.updated_at;
                  const verifikasiUpdatedAt = new Date(verifikasiUpdatedAtString);
                  // const verifikasiUpdatedAt = verifikasi.updated_at.toDate(); // Convert Firestore timestamp to JS Date object
                  const formattedVerifikasiUpdatedAt = verifikasiUpdatedAt.toLocaleString("en-US", {
                    timeZone: "Asia/Bangkok", // Adjust for UTC+7 (Bangkok)
                    weekday: "long",
                    month: "long",
                    day: "numeric",
                    year: "numeric",
                    hour: "numeric",
                    minute: "numeric",
                    hour12: true, // Use 12-hour format
                  });
                  verifikasi.updated_at = formattedVerifikasiUpdatedAt; // Add a new field for formatted string
                }
                
                // if (verifikasi.hasOwnProperty('updated_at')) {
                //   const verifikasiUpdatedAtString = verifikasi.updated_at;
                //   const verifikasiUpdatedAt = new Date(verifikasiUpdatedAtString);
                //   const verifikasiUpdatedAtTimestamp = admin.firestore.Timestamp.fromDate(verifikasiUpdatedAt);
                //   verifikasi.updated_at = verifikasiUpdatedAtTimestamp;
                // }
              }

              

              lahanDataToUpdate.verifikasi = verifikasiList;
            }

            // Add update to the batch
            batch.set(lahanRef, lahanDataToUpdate, { merge: true });
          }

          // Commit the batch write
          await batch.commit();

          console.log('Data updated successfully in Firestore');
          res.status(200).send('Data updated successfully in Firestore');
        } else {
          console.error('lahanData is not an array:', lahanData);
          res.status(400).send('Invalid data format: lahanData is not an array');
        }
      } else {
        console.error('Response from PostgreSQL is missing "lahan" property');
        res.status(400).send('Invalid data format from PostgreSQL');
      }
    } else {
      console.error('Failed to fetch data, status code:', response.status);
      res.status(response.status).send('Failed to fetch data');
    }
  } catch (error) {
    console.error('Error fetching data from PostgreSQL:', error);
    res.status(500).send('Error fetching data from PostgreSQL');
  }
});



// // HTTP Cloud Function to handle requests
// exports.fetchDataFromPostgresql = functions.https.onRequest(async (req, res) => {
//   console.log('Function fetchDataFromPostgresql started');

//   // Connect to PostgreSQL
//   try {
//     await client.connect();
//     console.log('Connected to PostgreSQL');
    
//     // Listen for PostgreSQL notifications from 'map_changes'
//     await client.query('LISTEN map_changes');
//     console.log('Listening for PostgreSQL notifications');

//     // PostgreSQL notification listener
//     client.on('notification', async (msg) => {
//       console.log(`Received notification from PostgreSQL: ${msg.channel}, payload: ${msg.payload}`);
  
//       // Check if the notification is from 'map_changes'
//       if (msg.channel === 'map_changes') {
//         console.log('Triggering fetchDataFromPostgresql...');
//         await fetchData();
//       }
//     });

//     // Fetch data from getAllLahan endpoint and update Firestore
//     async function fetchData() {
//       const url = `${baseUrl}/getAllLahan`;

//       // const url = `${baseUrl}/getAllLahan`;

//   try {
//     const response = await axios.get(url);
//     console.log('Received response from PostgreSQL:', JSON.stringify(response.data, null, 2));

//     if (response.status === 200) {
//       const { data: responseData } = response; // Destructuring assignment

//       if (responseData.hasOwnProperty('data') && responseData.data.hasOwnProperty('lahan')) {
//         const lahanData = responseData.data.lahan;

//         if (Array.isArray(lahanData)) {
//           const batch = db.batch(); // Create a new batch

//           for (const lahan of lahanData) {
//             const userId = lahan.user_id;
//             const mapId = lahan.map_id;
//             const lahanRef = db.collection('Users').doc(userId).collection('Lahan').doc(mapId);

//             // Convert updated_at in lahan to Firestore Timestamp
//             // if (lahan.hasOwnProperty('updated_at')) {
//             //   const updatedAtString = lahan.updated_at;
//             //   const updatedAt = new Date(updatedAtString);
//             //   const updatedAtTimestamp = admin.firestore.Timestamp.fromDate(updatedAt);
//             //   lahan.updated_at = updatedAtTimestamp;
//             // }

//             if (lahan.hasOwnProperty('updated_at')) {
//               const updatedAtString = lahan.updated_at;
//               const updatedAt = new Date(updatedAtString);
//               // const updatedAttoDate = updatedAt.toDate(); // Convert Firestore timestamp to JS Date object
//               const formattedUpdatedAt = updatedAt.toLocaleString("en-US", {
//                 timeZone: "Asia/Bangkok", // Adjust for UTC+7 (Bangkok)
//                 weekday: "long",
//                 month: "long",
//                 day: "numeric",
//                 year: "numeric",
//                 hour: "numeric",
//                 minute: "numeric",
//                 hour12: true, // Use 12-hour format
//               });
//               lahan.formatted_updated_at = formattedUpdatedAt; // Add a new field for formatted string
//             }
            

//             const lahanDataToUpdate = {
//               koordinat: lahan.koordinat ? lahan.koordinat : [],
//               verifikasi: lahan.verifikasi ? lahan.verifikasi : [],
//               updated_at: lahan.formatted_updated_at
//             };

//             // Convert updated_at in verifikasi to Firestore Timestamp
//             if (lahan.hasOwnProperty('verifikasi')) {
//               const verifikasiList = lahan.verifikasi;

//               for (const verifikasi of verifikasiList) {
//                 if (verifikasi.hasOwnProperty('updated_at')) {
//                   const verifikasiUpdatedAtString = verifikasi.updated_at;
//                   const verifikasiUpdatedAt = new Date(verifikasiUpdatedAtString);
//                   // const verifikasiUpdatedAt = verifikasi.updated_at.toDate(); // Convert Firestore timestamp to JS Date object
//                   const formattedVerifikasiUpdatedAt = verifikasiUpdatedAt.toLocaleString("en-US", {
//                     timeZone: "Asia/Bangkok", // Adjust for UTC+7 (Bangkok)
//                     weekday: "long",
//                     month: "long",
//                     day: "numeric",
//                     year: "numeric",
//                     hour: "numeric",
//                     minute: "numeric",
//                     hour12: true, // Use 12-hour format
//                   });
//                   verifikasi.updated_at = formattedVerifikasiUpdatedAt; // Add a new field for formatted string
//                 }
                
//                 // if (verifikasi.hasOwnProperty('updated_at')) {
//                 //   const verifikasiUpdatedAtString = verifikasi.updated_at;
//                 //   const verifikasiUpdatedAt = new Date(verifikasiUpdatedAtString);
//                 //   const verifikasiUpdatedAtTimestamp = admin.firestore.Timestamp.fromDate(verifikasiUpdatedAt);
//                 //   verifikasi.updated_at = verifikasiUpdatedAtTimestamp;
//                 // }
//               }

              

//               lahanDataToUpdate.verifikasi = verifikasiList;
//             }

//             // Add update to the batch
//             batch.set(lahanRef, lahanDataToUpdate, { merge: true });
//           }

//           // Commit the batch write
//           await batch.commit();

//           console.log('Data updated successfully in Firestore');
//           res.status(200).send('Data updated successfully in Firestore');
//         } else {
//           console.error('lahanData is not an array:', lahanData);
//           res.status(400).send('Invalid data format: lahanData is not an array');
//         }
//       } else {
//         console.error('Response from PostgreSQL is missing "lahan" property');
//         res.status(400).send('Invalid data format from PostgreSQL');
//       }
//     } else {
//       console.error('Failed to fetch data, status code:', response.status);
//       res.status(response.status).send('Failed to fetch data');
//     }
//   } catch (error) {
//     console.error('Error fetching data from PostgreSQL:', error);
//     res.status(500).send('Error fetching data from PostgreSQL');
//   }
//       // try {
//       //   const response = await axios.get(url);
//       //   console.log('Received response from getAllLahan:', response.data);
    
//       //   if (response.status === 200) {
//       //     const responseData = response.data;
    
//       //     const batch = db.batch();
    
//       //     if (responseData.hasOwnProperty('lahan')) {
//       //       const lahanData = responseData.lahan;
    
//       //       for (const lahan of lahanData) {
//       //         const userId = lahan.user_id;
//       //         const mapId = lahan.map_id;
//       //         const lahanRef = db.collection('Lahan').doc(mapId);
    
//       //         // Convert updated_at in lahan to Firestore Timestamp
//       //         if (lahan.hasOwnProperty('updated_at')) {
//       //           const updatedAtString = lahan.updated_at;
//       //           const updatedAt = new Date(updatedAtString);
//       //           const updatedAtTimestamp = admin.firestore.Timestamp.fromDate(updatedAt);
//       //           lahan.updated_at = updatedAtTimestamp;
//       //         }
    
//       //         const lahanDataToUpdate = {
//       //           koordinat: lahan.koordinat ? lahan.koordinat : [],
//       //           verifikasi: lahan.verifikasi ? lahan.verifikasi : [],
//       //           updated_at: lahan.updated_at
//       //         };
    
//       //         // Convert updated_at in verifikasi to Firestore Timestamp
//       //         if (lahan.hasOwnProperty('verifikasi')) {
//       //           const verifikasiList = lahan.verifikasi;
    
//       //           for (const verifikasi of verifikasiList) {
//       //             if (verifikasi.hasOwnProperty('updated_at')) {
//       //               const verifikasiUpdatedAtString = verifikasi.updated_at;
//       //               const verifikasiUpdatedAt = new Date(verifikasiUpdatedAtString);
//       //               const verifikasiUpdatedAtTimestamp = admin.firestore.Timestamp.fromDate(verifikasiUpdatedAt);
//       //               verifikasi.updated_at = verifikasiUpdatedAtTimestamp;
//       //             }
//       //           }
    
//       //           lahanDataToUpdate.verifikasi = verifikasiList;
//       //         }
    
//       //         console.log(`Updating Firestore for mapId: ${mapId}`);
//       //         batch.set(lahanRef, lahanDataToUpdate, { merge: true });
    
//       //         const userLahanRef = db.collection('Users').doc(userId).collection('Lahan').doc(mapId);
//       //         batch.set(userLahanRef, lahanDataToUpdate, { merge: true });
//       //       }
//       //     }
          
//       //     await batch.commit();
//       //     console.log('Data updated successfully in Firestore');
//       //   } else {
//       //     console.error('Failed to fetch data, status code:', response.status);
//       //   }
//       // } catch (error) {
//       //   console.error('Error fetching data from PostgreSQL:', error);
//       // }
//     }

//     // Handle unhandled rejections
//     process.on('unhandledRejection', (err) => {
//       console.error('Unhandled Rejection:', err);
//       process.exit(1);
//     });

//     res.status(200).send('Function is listening for PostgreSQL notifications');
//   } catch (error) {
//     console.error('Error connecting to PostgreSQL:', error);
//     res.status(500).send('Error connecting to PostgreSQL');
//   } finally {
//     // Ensure client is closed properly
//     await client.end();
//   }
// });


// const { Client } = require('pg');
// const admin = require('firebase-admin');
// const functions = require('firebase-functions');
// const axios = require('axios');

// // Initialize Firestore
// admin.initializeApp();
// const db = admin.firestore();

// // Replace with your PostgreSQL and base URL
// const baseUrl = 'http://localhost:5000';
// const client = new Client({
//   user: 'dba',
//   host: '13.213.13.138',
//   database: 'dipetakan',
//   password: '12345678peta',
//   port: 5432,
// });


// // // Connect to PostgreSQL
// // client.connect();

// // // Listen for PostgreSQL notifications from 'maps' table
// // client.query('LISTEN maps_changes');

// // // PostgreSQL notification listener
// // client.on('notification', async (msg) => {
// //   console.log('Received notification from PostgreSQL:', msg.payload);
  
// //   // Fetch data from getAllLahan endpoint
// //   const url = `${baseUrl}/getAllLahan`;
// //   try {
// //     const response = await axios.get(url);
// //     console.log('Received response from getAllLahan:', response.data);

// //     if (response.status === 200) {
// //       const responseData = response.data;

// //       const batch = db.batch();

// //       if (responseData.lahan) {
// //         for (const lahan of responseData.lahan) {
// //           const userId = lahan.user_id;
// //           const mapId = lahan.map_id;
// //           const lahanRef = db.collection('Lahan').doc(mapId);

// //           if (lahan.updated_at) {
// //             lahan.updated_at = admin.firestore.Timestamp.fromDate(new Date(lahan.updated_at));
// //           }

// //           const lahanDataToUpdate = {
// //             koordinat: lahan.koordinat ? lahan.koordinat : [],
// //             verifikasi: lahan.verifikasi ? lahan.verifikasi : [],
// //             updated_at: lahan.updated_at
// //           };

// //           if (lahan.verifikasi) {
// //             lahanDataToUpdate.verifikasi = lahan.verifikasi.map(ver => {
// //               if (ver.updated_at) {
// //                 ver.updated_at = admin.firestore.Timestamp.fromDate(new Date(ver.updated_at));
// //               }
// //               return ver;
// //             });
// //           }

// //           console.log(`Updating Firestore for mapId: ${mapId}`);
// //           batch.set(lahanRef, lahanDataToUpdate, { merge: true });

// //           const userLahanRef = db.collection('Users').doc(userId).collection('Lahan').doc(mapId);
// //           batch.set(userLahanRef, lahanDataToUpdate, { merge: true });
// //         }
// //       }

// //       await batch.commit();
// //       console.log('Data updated successfully in Firestore');
// //     } else {
// //       console.error('Failed to fetch data, status code:', response.status);
// //     }
// //   } catch (error) {
// //     console.error('Error fetching data from getAllLahan:', error);
// //   }
// // });

// // // HTTP Cloud Function to handle requests (optional)
// // exports.fetchDataFromPostgresql = functions.https.onRequest(async (req, res) => {
// //   res.status(200).send('Function is listening for PostgreSQL notifications');
// // });

// // // Handle unhandled rejections
// // process.on('unhandledRejection', (err) => {
// //   console.error('Unhandled Rejection:', err);
// //   process.exit(1);
// // });


// // exports.fetchDataFromPostgresql = functions.pubsub.schedule('every 5 minutes').onRun(async (context) => {
// //   const url = `${baseUrl}/getAllLahan`;
// //   try {
// //     const response = await axios.get(url);

// //     if (response.status === 200) {
// //       const responseData = response.data;

// //       const batch = db.batch();

// //       if (responseData.lahan) {
// //         for (const lahan of responseData.lahan) {
// //           const userId = lahan.user_id;
// //           const mapId = lahan.map_id;
// //           const lahanRef = db.collection('Lahan').doc(mapId);

// //           if (lahan.updated_at) {
// //             lahan.updated_at = admin.firestore.Timestamp.fromDate(new Date(lahan.updated_at));
// //           }

// //           const lahanDataToUpdate = {
// //             koordinat: lahan.koordinat ? lahan.koordinat : [],
// //             verifikasi: lahan.verifikasi ? lahan.verifikasi : [],
// //             updated_at: lahan.updated_at
// //           };

// //           if (lahan.verifikasi) {
// //             lahanDataToUpdate.verifikasi = lahan.verifikasi.map(ver => {
// //               if (ver.updated_at) {
// //                 ver.updated_at = admin.firestore.Timestamp.fromDate(new Date(ver.updated_at));
// //               }
// //               return ver;
// //             });
// //           }

// //           batch.set(lahanRef, lahanDataToUpdate, { merge: true });

// //           const userLahanRef = db.collection('Users').doc(userId).collection('Lahan').doc(mapId);
// //           batch.set(userLahanRef, lahanDataToUpdate, { merge: true });
// //         }
// //       }

// //       await batch.commit();
// //       console.log('Data updated successfully in Firestore');
// //     } else {
// //       console.error('Failed to fetch data');
// //     }
// //   } catch (error) {
// //     console.error('Error fetching data from PostgreSQL:', error);
// //   } finally {
// //     await client.end();
// //   }
// //   return null;
// // });


// exports.fetchDataFromPostgresql = functions.https.onRequest(async (req, res) => {
//     console.log('Function fetchDataFromPostgresql started');
//     const url = `${baseUrl}/getAllLahan`;
//     try {
//       const response = await axios.get(url);
//       console.log('Received response from PostgreSQL:', response.data);
  
//       if (response.status === 200) {
//         const responseData = response.data;
  
//         const batch = db.batch();

//           //         if (responseData.hasOwnProperty('lahan')) {
//           //   const lahanData = responseData.lahan;
    
//           //   for (const lahan of lahanData) {
//           //     const userId = lahan.user_id;
//           //     const mapId = lahan.map_id;
//           //     const lahanRef = db.collection('Lahan').doc(mapId);
    
//           //     // Convert updated_at in lahan to Firestore Timestamp
//           //     if (lahan.hasOwnProperty('updated_at')) {
//           //       const updatedAtString = lahan.updated_at;
//           //       const updatedAt = new Date(updatedAtString);
//           //       const updatedAtTimestamp = admin.firestore.Timestamp.fromDate(updatedAt);
//           //       lahan.updated_at = updatedAtTimestamp;
//           //     }
    
//           //     const lahanDataToUpdate = {
//           //       koordinat: lahan.koordinat ? lahan.koordinat : [],
//           //       verifikasi: lahan.verifikasi ? lahan.verifikasi : [],
//           //       updated_at: lahan.updated_at
//           //     };
    
//           //     // Convert updated_at in verifikasi to Firestore Timestamp
//           //     if (lahan.hasOwnProperty('verifikasi')) {
//           //       const verifikasiList = lahan.verifikasi;
    
//           //       for (const verifikasi of verifikasiList) {
//           //         if (verifikasi.hasOwnProperty('updated_at')) {
//           //           const verifikasiUpdatedAtString = verifikasi.updated_at;
//           //           const verifikasiUpdatedAt = new Date(verifikasiUpdatedAtString);
//           //           const verifikasiUpdatedAtTimestamp = admin.firestore.Timestamp.fromDate(verifikasiUpdatedAt);
//           //           verifikasi.updated_at = verifikasiUpdatedAtTimestamp;
//           //         }
//           //       }
    
//           //       lahanDataToUpdate.verifikasi = verifikasiList;
//           //     }
    
//           //     console.log(`Updating Firestore for mapId: ${mapId}`);
//           //     batch.set(lahanRef, lahanDataToUpdate, { merge: true });
    
//           //     const userLahanRef = db.collection('Users').doc(userId).collection('Lahan').doc(mapId);
//           //     batch.set(userLahanRef, lahanDataToUpdate, { merge: true });
//           //   }
//           // }

  
//         // if (responseData.lahan) {
//         //   for (const lahan of responseData.lahan) {
//         //     const userId = lahan.user_id;
//         //     const mapId = lahan.map_id;
//         //     const lahanRef = db.collection('Lahan').doc(mapId);
  
//         //     if (lahan.updated_at) {
//         //       lahan.updated_at = admin.firestore.Timestamp.fromDate(new Date(lahan.updated_at));
//         //     }
  
//         //     const lahanDataToUpdate = {
//         //       koordinat: lahan.koordinat ? lahan.koordinat : [],
//         //       verifikasi: lahan.verifikasi ? lahan.verifikasi : [],
//         //       updated_at: lahan.updated_at
//         //     };
  
//         //     if (lahan.verifikasi) {
//         //       lahanDataToUpdate.verifikasi = lahan.verifikasi.map(ver => {
//         //         if (ver.updated_at) {
//         //           ver.updated_at = admin.firestore.Timestamp.fromDate(new Date(ver.updated_at));
//         //         }
//         //         return ver;
//         //       });
//         //     }
  
//         //     console.log(`Updating Firestore for mapId: ${mapId}`);
//         //     batch.set(lahanRef, lahanDataToUpdate, { merge: true });
  
//         //     const userLahanRef = db.collection('Users').doc(userId).collection('Lahan').doc(mapId);
//         //     batch.set(userLahanRef, lahanDataToUpdate, { merge: true });
//         //   }
//         // }
  
//         await batch.commit();
//         console.log('Data updated successfully in Firestore');
//         res.status(200).send('Data updated successfully in Firestore');
//       } else {
//         console.error('Failed to fetch data, status code:', response.status);
//         res.status(response.status).send('Failed to fetch data');
//       }
//     } catch (error) {
//       console.error('Error fetching data from PostgreSQL:', error);
//       res.status(500).send('Error fetching data from PostgreSQL');
//     } finally {
//       await client.end();
//     }
//   });

// // exports.saveLahanRecord = functions.https.onCall(async (data, context) => {
// //   const userId = context.auth ? context.auth.uid : null;

// //   if (!userId) {
// //     throw new functions.https.HttpsError('unauthenticated', 'User not authenticated');
// //   }

// //   const lahan = data.lahan;

// //   try {
// //     const lahanRef = db.collection('Users').doc(userId).collection('Lahan').doc(lahan.id);
// //     await lahanRef.set(lahan);

// //     // Optionally send data to the server to save in PostgreSQL
// //     // const dataToSend = {
// //     //   user_id: userId,
// //     //   ...lahan
// //     // };

// //     // const saveUrl = `${baseUrl}/saveLahan`;
// //     // const saveResponse = await axios.post(saveUrl, dataToSend);

// //     // if (saveResponse.status !== 200) {
// //     //   throw new Error('Failed to save lahan record to PostgreSQL');
// //     // }

// //     return { success: true };
// //   } catch (error) {
// //     throw new functions.https.HttpsError('unknown', `Failed to save lahan record: ${error.message}`);
// //   }
// // });
