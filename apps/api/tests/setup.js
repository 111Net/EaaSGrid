require("dotenv").config({
    path: "../../.env"
});

console.log(
    "Jest loaded SUPABASE:",
    process.env.SUPABASE_URL ? "YES" : "NO"
);
