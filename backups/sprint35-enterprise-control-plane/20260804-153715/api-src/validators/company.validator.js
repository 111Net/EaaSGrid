const Joi = require("joi");


const companySchema = Joi.object({

    company_name:
        Joi.string()
        .min(3)
        .required(),

    parent_company:
        Joi.string()
        .required(),

    country:
        Joi.string()
        .required(),

    platform:
        Joi.string()
        .required(),

    year_started:
        Joi.number()
        .integer()
        .min(1900)
        .required()

});


module.exports = companySchema;
