const pool =
require("../config/postgres");


async function record(
action,
user,
details={}
){

await pool.query(

`
INSERT INTO audit_logs
(
action,
user_id,
details
)

VALUES
($1,$2,$3)
`,

[
action,
user,
JSON.stringify(details)
]

);

}


module.exports={
record
};
