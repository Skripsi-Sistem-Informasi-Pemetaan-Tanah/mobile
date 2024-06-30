require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const { Client } = require('pg');

const app = express();
const port = 3000;

app.use(bodyParser.json());

const client = new Client({
    host: process.env.DATABASE_HOST,
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE_NAME,
    port: process.env.PORT,
    // ssl: {
    //   rejectUnauthorized: false,
    // },
});

// client.connect();

// client.connect()
//     .then(() => {
//         console.log('Database connected successfully');
//         return client.end();
//     })
//     .catch((err) => {
//         console.error('Database connection error:', err.stack);
//     });

// Connect to the database before starting the server
async function connectDatabase() {
  try {
    await client.connect();
    console.log('Database connected successfully');
  } catch (err) {
    console.error('Database connection error:', err.stack);
    process.exit(1); // Exit the application on connection failure
  }
}

// Define a route to check the database connection
app.get('/checkDatabaseConnection', async (req, res) => {
  try {
    const result = await client.query('SELECT NOW()');
    console.log('Successfully connected to the database');
    res.status(200).json({ connected: true, message: 'Database connection successful', timestamp: result.rows[0].now });
  } catch (error) {
    console.error('Error connecting to the database:', error);
    res.status(500).json({ connected: false, error: 'Failed to connect to the database' });
  }
});

// Call the connectDatabase function before starting the server
connectDatabase()
  .then(() => {
    app.listen(port, () => {
      console.log(`Server is running on port ${port}`);
    });
  });

// Close the connection when the server shuts down (optional)
// process.on('SIGINT', () => {
//   client.end()
//     .then(() => console.log('Database connection closed'))
//     .catch((err) => console.error('Error closing database connection:', err));
// });

// app.post('/saveUser', async (req, res) => {
//   const user = req.body;

//   try {
//     const query = `
//       INSERT INTO users (id, NamaLengkap, Username, Email, NoTelepon, FotoProfil)
//       VALUES ($1, $2, $3, $4, $5, $6)
//       ON CONFLICT (id) DO UPDATE SET
//         NamaLengkap = EXCLUDED.NamaLengkap,
//         Username = EXCLUDED.Username,
//         Email = EXCLUDED.Email,
//         NoTelepon = EXCLUDED.NoTelepon,
//         FotoProfil = EXCLUDED.FotoProfil;
//     `;
//     const values = [user.id, user.NamaLengkap, user.Username, user.Email, user.NoTelepon, user.FotoProfil];

//     await client.query(query, values);
//     res.status(200).send('User saved successfully');
//   } catch (e) {
//     console.error(e);
//     res.status(500).send('Error saving user');
//   }
// });

// app.put('/updateField', async (req, res) => {
//   const { id, NamaLengkap, Username, Email, NoTelepon, FotoProfil } = req.body;

//   try {
//     const fieldsToUpdate = {};
//     if (NamaLengkap) fieldsToUpdate.NamaLengkap = NamaLengkap;
//     if (Username) fieldsToUpdate.Username = Username;
//     if (Email) fieldsToUpdate.Email = Email;
//     if (NoTelepon) fieldsToUpdate.NoTelepon = NoTelepon;
//     if (FotoProfil) fieldsToUpdate.FotoProfil = FotoProfil;

//     const setString = Object.keys(fieldsToUpdate).map((key, index) => `${key} = $${index + 2}`).join(', ');
//     const values = [id, ...Object.values(fieldsToUpdate)];

//     const query = `UPDATE users SET ${setString} WHERE id = $1`;

//     await client.query(query, values);
//     res.status(200).send('User updated successfully');
//   } catch (e) {
//     console.error(e);
//     res.status(500).send('Error updating user');
//   }
// });

app.post('/saveUser', async (req, res) => {
  const user = req.body;

  try {
    const query = `
      INSERT INTO users (user_id, username, nama_lengkap, email, password, role, refresh_token, updated_at, created_at)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
      ON CONFLICT (user_id) DO UPDATE SET
        username = EXCLUDED.username,
        nama_lengkap = EXCLUDED.nama_lengkap,
        email = EXCLUDED.email,
        password = EXCLUDED.password,
        role = EXCLUDED.role,
        refresh_token = EXCLUDED.refresh_token,
        updated_at = EXCLUDED.updated_at
    `;
    const currentTime = new Date();
    const values = [
      user.user_id, 
      user.username, 
      user.nama_lengkap, 
      user.email, 
      null,
      2, 
      null,
      currentTime,
      currentTime
    ];

    await client.query(query, values);
    res.status(200).send('User saved successfully');
  } catch (e) {
    console.error(e);
    res.status(500).send('Error saving user');
  }
});


app.put('/updateField', async (req, res) => {
  const { user_id, username, nama_lengkap, email } = req.body;

  try {
    const fieldsToUpdate = {};
    if (username) fieldsToUpdate.username = username;
    if (nama_lengkap) fieldsToUpdate.nama_lengkap = nama_lengkap;
    if (email) fieldsToUpdate.email = email;

    fieldsToUpdate.updated_at = new Date();

    const setString = Object.keys(fieldsToUpdate).map((key, index) => `${key} = $${index + 2}`).join(', ');
    const values = [user_id, ...Object.values(fieldsToUpdate)];

    const query = `UPDATE users SET ${setString} WHERE user_id = $1`;

    await client.query(query, values);
    res.status(200).send('User updated successfully');
  } catch (e) {
    console.error(e);
    res.status(500).send('Error updating user');
  }
});


app.delete('/deleteUser/:id', async (req, res) => {
  const userId = req.params.id;

  try {
    const query = 'DELETE FROM users WHERE id = $1';
    await client.query(query, [userId]);
    res.status(200).send('User deleted successfully');
  } catch (e) {
    console.error(e);
    res.status(500).send('Error deleting user');
  }
});



// app.post('/saveLahan', async (req, res) => {
//   const { user_id, patokan, verifikasi, ...lahan } = req.body; // Extract patokan and verifikasi from req.body

//   try {
//     // Insert data into Lahan table
//     const lahanQuery = `
//       INSERT INTO Lahan (lahan_id, user_id, created_at, updated_at, deskripsi_lahan, jenis_lahan, nama_lahan, patokan, verifikasi)
//       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
//       RETURNING lahan_id;
//     `;
//     const lahanValues = [lahan.id, user_id, lahan.created_at, lahan.updated_at, lahan.deskripsi_lahan, lahan.jenis_lahan, lahan.nama_lahan, JSON.stringify(patokan),
//     JSON.stringify(verifikasi)];

//     const lahanResult = await client.query(lahanQuery, lahanValues);
//     const mapId = lahanResult.rows[0].id;

//     // Insert data into Patokan table
//     for (const patokanItem of patokan) {
//       const patokanQuery = `
//         INSERT INTO Patokan (lahan_id, coordinates, foto_patokan, local_path)
//         VALUES ($1, $2, $3, $4);
//       `;
//       const patokanValues = [mapId, patokanItem.coordinates, patokanItem.foto_patokan, patokanItem.local_path];
//       await client.query(patokanQuery, patokanValues);
//     }

//     // Insert data into Verifikasi table
//     for (const verifikasiItem of verifikasi) {
//       const verifikasiQuery = `
//         INSERT INTO Verifikasi (lahan_id, komentar, progress, status_verifikasi, verified_at)
//         VALUES ($1, $2, $3, $4, $5);
//       `;
//       const verifikasiValues = [mapId, verifikasiItem.komentar, verifikasiItem.progress, verifikasiItem.status_verifikasi, verifikasiItem.verified_at];
//       await client.query(verifikasiQuery, verifikasiValues);
//     }

//     res.status(200).send('Lahan record saved successfully');
//   } catch (e) {
//     console.error(e);
//     res.status(500).send('Error saving lahan record to PostgreSQL');
//   }
// });

app.post('/saveLahan', async (req, res) => {
  const lahan = req.body;

    try {
    if (!lahan.map_id) {
      throw new Error('map_id is required');
    }

    const lahanQuery = `
    INSERT INTO maps (map_id, user_id, nama_lahan, koordinat, status, progress, updated_at, created_at)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
    ON CONFLICT (map_id) DO UPDATE SET
      user_id = EXCLUDED.user_id,
      nama_lahan = EXCLUDED.nama_lahan,
      koordinat = EXCLUDED.koordinat,
      status = EXCLUDED.status,
      progress = EXCLUDED.progress,
      updated_at = EXCLUDED.updated_at
  `;
    const currentTime = new Date();
    const lahanValues = [
      lahan.map_id, 
      lahan.user_id, 
      lahan.nama_lahan,
      JSON.stringify(lahan.koordinat),  // Store the koordinat as JSON
      'belum tervalidasi',
      0,
      currentTime,
      currentTime
    ];
    await client.query(lahanQuery, lahanValues);
    // Insert or update the koordinat table
    for (const coord of lahan.koordinat) {
      const coordQuery = `
        INSERT INTO koordinat (koordinat, image, map_id, created_at, updated_at)
        VALUES ($1, $2, $3, $4, $5)
        ON CONFLICT (map_id, koordinat) DO UPDATE SET
          image = EXCLUDED.image,
          updated_at = EXCLUDED.updated_at
      `;
      const coordValues = [
        coord.coordinates.split(',').map(parseFloat), // Convert coordinates to double precision array
        coord.foto_patokan,
        lahan.map_id,
        currentTime,
        currentTime
      ];
      await client.query(coordQuery, coordValues);
    }

    res.status(200).send('Lahan saved successfully');
  } catch (e) {
    console.error(e);
    res.status(500).send('Error saving lahan: ' + e.message);
  }
});

app.post('/updateFotoPatokan', async (req, res) => {
  const lahan = req.body;

    try {
    if (!lahan.map_id) {
      throw new Error('map_id is required');
    }

    const lahanQuery = `
    UPDATE maps
      SET koordinat = $1, updated_at = $2
      WHERE map_id = $3
  `;
    const currentTime = new Date();
    const lahanValues = [
      JSON.stringify(lahan.koordinat),
      currentTime,
      lahan.map_id
    ];
    await client.query(lahanQuery, lahanValues);
    // Insert or update the koordinat table
    for (const coord of lahan.koordinat) {
      const coordQuery = `
        UPDATE koordinat
        SET image = $1, updated_at = $2
        WHERE map_id = $3 AND koordinat = $4
      `;
      const coordValues = [
        coord.foto_patokan,
        currentTime,
        lahan.map_id,
        coord.coordinates.split(',').map(parseFloat)
      ];
      await client.query(coordQuery, coordValues);
    }

    res.status(200).send('Lahan saved successfully');
  } catch (e) {
    console.error(e);
    res.status(500).send('Error saving lahan: ' + e.message);
  }
});

// app.post('/updateFotoPatokan', async (req, res) => {
//   const { map_id, koordinat } = req.body;

//   try {
//     if (!map_id) {
//       throw new Error('map_id is required');
//     }

//     const currentTime = new Date();

//     // Update the maps table with new koordinat JSON and updated_at values
//     const updateMapsQuery = `
//       UPDATE maps
//       SET koordinat = $1, updated_at = $2
//       WHERE map_id = $3
//     `;
//     const mapsValues = [JSON.stringify(koordinat), currentTime, map_id];
//     await client.query(updateMapsQuery, mapsValues);

//     // Update the koordinat table with new foto_patokan values
//     for (const coord of koordinat) {
//       const coordQuery = `
//         INSERT INTO koordinat (koordinat, image, map_id, created_at, updated_at)
//         VALUES ($1, $2, $3, $4, $5)
//         ON CONFLICT (map_id, koordinat) DO UPDATE SET
//           image = EXCLUDED.image,
//           updated_at = EXCLUDED.updated_at
//       `;
//       const coordValues = [
//         coord.coordinates.split(',').map(parseFloat), // Convert coordinates to double precision array
//         coord.foto_patokan,
//         map_id,
//         currentTime,
//         currentTime
//       ];
//       await client.query(coordQuery, coordValues);
//     }

//     res.status(200).send('Foto patokan updated successfully');
//   } catch (e) {
//     console.error(e);
//     res.status(500).send('Error updating foto patokan: ' + e.message);
//   }
// });



// app.post('/saveLahan', async (req, res) => {
//   const lahan = req.body;

//   try {
//     if (!lahan.map_id) {
//       throw new Error('map_id is required');
//     }

//     const lahanQuery = `
//     INSERT INTO maps (map_id, user_id, nama_lahan, koordinat, status, progress, updated_at, created_at)
//     VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
//     ON CONFLICT (map_id) DO UPDATE SET
//       user_id = EXCLUDED.user_id,
//       nama_lahan = EXCLUDED.nama_lahan,
//       koordinat = EXCLUDED.koordinat,
//       status = EXCLUDED.status,
//       progress = EXCLUDED.progress,
//       updated_at = EXCLUDED.updated_at
//   `;
//     const currentTime = new Date();
//     const lahanValues = [
//       lahan.map_id, 
//       lahan.user_id, 
//       lahan.nama_lahan,
//       JSON.stringify(lahan.koordinat),  // Store the koordinat as JSON
//       'belum tervalidasi',
//       0,
//       currentTime,
//       currentTime
//     ];
//     await client.query(lahanQuery, lahanValues);
//     res.status(200).send('Lahan saved successfully');
//   } catch (e) {
//     console.error(e);
//     res.status(500).send('Error saving lahan: ' + e.message);
//   }
// });



// app.get('/getLahan', async (req, res) => {
//   try {
//     const result = await client.query('SELECT * FROM lahan');
//     res.status(200).json(result.rows);
//   } catch (e) {
//     console.error(e);
//     res.status(500).send('Error reading data');
//   }
// });


app.get('/getAllLahan', async (req, res) => {
  // const userId = req.query.user_id;

  // if (!userId) {
  //   return res.status(400).send('user_id is required');
  // }

  try {
    // Query to fetch data from the maps table
    const mapsQuery = 'SELECT user_id, map_id, updated_at, koordinat FROM maps';
    const mapsResult = await client.query(mapsQuery);

    // Query to fetch data from the verifikasi table
    const verifikasiQuery = 'SELECT map_id, komentar, status, progress, updated_at FROM verifikasi';
    const verifikasiResult = await client.query(verifikasiQuery);

    // Combine the results from both queries based on map_id
    const lahanData = mapsResult.rows.map(map => {
      const verifikasiData = verifikasiResult.rows.filter(v => v.map_id === map.map_id);
      return {
        user_id: map.user_id,
        map_id: map.map_id,
        updated_at: map.updated_at,
        koordinat: map.koordinat, // Use parsed koordinat array
        verifikasi: verifikasiData
      };
    });

    res.status(200).json({ lahan: lahanData });
  } catch (e) {
    console.error(e);
    res.status(500).send('Error reading data');
  }
});



// app.get('/getLahanbyUserId', async (req, res) => {
//   const userId = req.query.user_id; // Assuming user_id is passed as a query parameter

//   if (!userId) {
//     return res.status(400).send('user_id is required');
//   }

//   try {
//     const result = await client.query('SELECT * FROM lahan WHERE user_id = $1', [userId]);
//     res.status(200).json(result.rows);
//   } catch (e) {
//     console.error(e);
//     res.status(500).send('Error reading data');
//   }
// });



// app.post('/saveLahan', async (req, res) => {
//   const {
//     id,
//     user_id,
//     created_at,
//     updated_at,
//     deskripsi_lahan,
//     jenis_lahan,
//     nama_lahan,
//     patokan,
//     verifikasi,
//   } = req.body;

//   try {
//     await pool.query('BEGIN');

//     const insertLahanText = `
//       INSERT INTO Lahan (lahan_id, user_id, created_at, updated_at, deskripsi_lahan, jenis_lahan, nama_lahan, patokan, verifikasi)
//       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
//     `;
//     const insertLahanValues = [
//       id,
//       user_id,
//       created_at,
//       updated_at,
//       deskripsi_lahan,
//       jenis_lahan,
//       nama_lahan,
//       JSON.stringify(patokan), // Storing JSONB data
//       JSON.stringify(verifikasi), // Storing JSONB data
//     ];

//     await pool.query(insertLahanText, insertLahanValues);

//     for (const patokanItem of patokan) {
//       const insertPatokanText = `
//         INSERT INTO Patokan (lahan_id, coordinates, foto_patokan, local_path)
//         VALUES ($1, $2, $3, $4)
//       `;
//       const insertPatokanValues = [id, patokanItem.coordinates, patokanItem.foto_patokan, patokanItem.local_path];
//       await pool.query(insertPatokanText, insertPatokanValues);
//     }

//     for (const verifikasiItem of verifikasi) {
//       const insertVerifikasiText = `
//         INSERT INTO Verifikasi (lahan_id, komentar, progress, status_verifikasi, verified_at)
//         VALUES ($1, $2, $3, $4, $5)
//       `;
//       const insertVerifikasiValues = [
//         id,
//         verifikasiItem.komentar,
//         verifikasiItem.progress,
//         verifikasiItem.status_verifikasi,
//         verifikasiItem.verified_at,
//       ];
//       await pool.query(insertVerifikasiText, insertVerifikasiValues);
//     }

//     await pool.query('COMMIT');
//     res.status(200).send('Lahan record saved successfully');
//   } catch (error) {
//     await pool.query('ROLLBACK');
//     console.error('Failed to save lahan record:', error.message, error.stack);
//     res.status(500).send('Failed to save lahan record');
//   }
// });


// app.listen(port, () => {
//   console.log(`Server is running on port ${port}`);
// });





// require('dotenv').config();
// const express = require('express');
// const { Pool } = require('pg');
// const bcrypt = require('bcrypt');
// const jwt = require('jsonwebtoken');

// const app = express();

// // Database connection details
// const pool = new Pool({
//     host: process.env.DB_HOST,
//     user: process.env.DB_USER,
//     password: process.env.DB_PASSWORD,
//     database: process.env.DB_DATABASE,
//     port: process.env.DB_PORT,
// });

// app.use(express.json());

// // Register Route
// app.post('/register', async (req, res) => {
//     const { email, password, fullName, username, phoneNo } = req.body;

//     try {
//         const hashedPassword = await bcrypt.hash(password, 10);
//         const result = await pool.query(
//             'INSERT INTO users (email, password, full_name, username, phone_no, profile_picture) VALUES ($1, $2, $3, $4, $5, null) RETURNING *',
//             [email, hashedPassword, fullName, username, phoneNo]
//         );
//         res.status(201).json(result.rows[0]);
//     } catch (error) {
//         console.error(error);
//         res.status(400).json({ error: 'Email already exists or invalid data' });
//     }
// });

// // Login Route
// app.post('/login', async (req, res) => {
//   const { email, password } = req.body;

//   try {
//       const result = await pool.query('SELECT * FROM users WHERE email = $1', [email]);

//       if (result.rows.length === 0) {
//           return res.status(400).json({ error: 'Invalid credentials' });
//       }

//       const user = result.rows[0];
//       const isValidPassword = await bcrypt.compare(password, user.password);

//       if (!isValidPassword) {
//           return res.status(400).json({ error: 'Invalid credentials' });
//       }

//       const accessToken = jwt.sign({ id: user.id, email: user.email }, process.env.JWT_SECRET, {
//           expiresIn: '1h',
//       });

//       const refreshToken = jwt.sign({ id: user.id, email: user.email }, process.env.REFRESH_TOKEN_SECRET, {
//           expiresIn: '7d',
//       });

//       // Save the refresh token in the database (optional but recommended)
//       await pool.query('UPDATE users SET refresh_token = $1 WHERE id = $2', [refreshToken, user.id]);

//       res.json({ accessToken, refreshToken });
//   } catch (error) {
//       console.error(error);
//       res.status(500).json({ error: 'Internal server error' });
//   }
// });

// // Refresh Token Route
// app.post('/refresh-token', async (req, res) => {
//   const { refreshToken } = req.body;

//   if (!refreshToken) return res.sendStatus(401);

//   try {
//       const result = await pool.query('SELECT * FROM users WHERE refresh_token = $1', [refreshToken]);

//       if (result.rows.length === 0) return res.sendStatus(403);

//       jwt.verify(refreshToken, process.env.REFRESH_TOKEN_SECRET, (err, user) => {
//           if (err) return res.sendStatus(403);

//           const accessToken = jwt.sign({ id: user.id, email: user.email }, process.env.JWT_SECRET, {
//               expiresIn: '1h',
//           });

//           res.json({ accessToken });
//       });
//   } catch (error) {
//       console.error(error);
//       res.status(500).json({ error: 'Internal server error' });
//   }
// });

// // Middleware to authenticate token
// const authenticateToken = (req, res, next) => {
//   const authHeader = req.headers['authorization'];
//   const token = authHeader && authHeader.split(' ')[1];

//   if (!token) return res.sendStatus(401); // No token provided

//   jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
//     if (err) return res.sendStatus(403); // Invalid token
//     req.user = user;
//     next();
//   });
// };

// // Fetch User Details Route
// app.get('/user', authenticateToken, async (req, res) => {
//     try {
//       const result = await pool.query('SELECT * FROM users WHERE id = $1', [req.user.id]);
//       if (result.rows.length === 0) return res.status(404).json({ error: 'User not found' });
  
//       res.json(result.rows[0]);
//     } catch (error) {
//       console.error(error);
//       res.status(500).json({ error: 'Internal server error' });
//     }
//   });
  
//   // Update User Details Route
//   app.put('/user', authenticateToken, async (req, res) => {
//     const { fullName, username, phoneNo, profilePicture } = req.body;
  
//     try {
//       const result = await pool.query(
//         'UPDATE users SET full_name = $1, username = $2, phone_no = $3, profile_picture = $4 WHERE id = $5 RETURNING *',
//         [fullName, username, phoneNo, profilePicture, req.user.id]
//       );
//       if (result.rows.length === 0) return res.status(404).json({ error: 'User not found' });
  
//       res.json(result.rows[0]);
//     } catch (error) {
//       console.error(error);
//       res.status(500).json({ error: 'Internal server error' });
//     }
//   });
  
//   // Delete User Route
//   app.delete('/user', authenticateToken, async (req, res) => {
//     try {
//       const result = await pool.query('DELETE FROM users WHERE id = $1 RETURNING *', [req.user.id]);
//       if (result.rows.length === 0) return res.status(404).json({ error: 'User not found' });
  
//       res.sendStatus(204);
//     } catch (error) {
//       console.error(error);
//       res.status(500).json({ error: 'Internal server error' });
//     }
//   });
  
//   // Upload Profile Picture Route
//   app.post('/user/profile-picture', authenticateToken, async (req, res) => {
//     const { profilePicture } = req.body;
  
//     try {
//       const result = await pool.query(
//         'UPDATE users SET profile_picture = $1 WHERE id = $2 RETURNING *',
//         [profilePicture, req.user.id]
//       );
//       if (result.rows.length === 0) return res.status(404).json({ error: 'User not found' });
  
//       res.json(result.rows[0]);
//     } catch (error) {
//       console.error(error);
//       res.status(500).json({ error: 'Internal server error' });
//     }
//   });
  
//   // Upload Image Route
//   app.post('/upload-image', authenticateToken, async (req, res) => {
//     const { imagePath, image } = req.body;
  
//     // Assume that the image upload functionality is implemented here.
//     // For simplicity, we'll just return the imagePath.
//     res.json({ imageUrl: `${imagePath}/${image}` });
//   });
  
//   const PORT = process.env.PORT || 3000;
//   app.listen(PORT, () => {
//     console.log(`Server is running on port ${PORT}`);
//   });
