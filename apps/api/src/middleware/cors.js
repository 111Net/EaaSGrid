const cors = require("cors");

const corsOptions = {

    origin: [
    "http://localhost:3000",
    "http://localhost:3001",
    "http://192.168.100.21:3000",
    "http://192.168.100.21"
],

    methods: [
        "GET",
        "POST",
        "PUT",
        "DELETE",
        "OPTIONS"
    ],

    allowedHeaders: [
        "Content-Type",
        "Authorization"
    ],

    credentials: true

};


module.exports = cors(corsOptions);
