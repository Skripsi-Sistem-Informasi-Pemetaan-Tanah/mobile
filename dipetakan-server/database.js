const { Client } = require('pg');

const client = new Client({
    host: "dipetakan-testing.c5y0sqe26fhi.ap-southeast-2.rds.amazonaws.com",
    user: "postgres",
    port: 5432,
    password: "12345678peta",
    database: "pertanahan",
    ssl: {
        rejectUnauthorized: false,
      },
});

// client.connect();

module.exports = client

// client.query('SELECT * FROM users', (err, res) => {
//     if (!err) {
//         console.log(res.rows);
//     } else {
//         console.log(err.message);
//     }
//     client.end();
// });
