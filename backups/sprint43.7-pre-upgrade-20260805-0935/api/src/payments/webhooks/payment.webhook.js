

module.exports = async function paymentWebhook(event){


console.log(
"Payment event received",
event
);


return {

processed:true

};


};


