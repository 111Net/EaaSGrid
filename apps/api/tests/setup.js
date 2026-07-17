require("dotenv").config({
    path: "../../.env"
});

console.log(
    "Jest loaded :",
    process.env. ? "YES" : "NO"
);
