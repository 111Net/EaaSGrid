

const providers={


paystack:
require("./providers/paystack.provider"),


flutterwave:
require("./providers/flutterwave.provider"),


stripe:
require("./providers/stripe.provider"),


bank:
require("./providers/bank-transfer.provider"),


mobile:
require("./providers/mobile-money.provider")


};



module.exports={


provider(name){

return providers[name];

}


};


