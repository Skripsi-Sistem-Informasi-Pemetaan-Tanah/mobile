const express = require('express');
const bodyParser = require('body-parser')

const client = require('./database')

const app = express();

// Define your routes
app.get('/api/v1/', (req, res) => {
    res.send('Hello, this is your API v1 endpoint!');
});

// Start the server
const port = 5000;
app.listen(port, console.log(`Server is running on 5000`));

client.connect(err => {
    if (err) {
        console.log(err.message)
    } else {
        console.log('Connected')
    }
})