const cors = require("cors");

const corsOptions = {

    origin: [
        "http://localhost:3000",
        "http://localhost:3001"
    ],

    methods: [
        "GET",
        "POST",
        "PUT",
        "DELETE"
    ],

    allowedHeaders: [
        "Content-Type",
        "Authorization"
    ]

};


module.exports = cors(corsOptions);
