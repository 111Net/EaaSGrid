module.exports = {

getHealth(){

return [
{
service:"XaaSGrid API",
status:"ONLINE",
uptime:"99.98%"
},
{
service:"PostgreSQL",
status:"ONLINE",
uptime:"100%"
},
{
service:"Redis Event Bus",
status:"ONLINE",
uptime:"100%"
}
];

}

};
