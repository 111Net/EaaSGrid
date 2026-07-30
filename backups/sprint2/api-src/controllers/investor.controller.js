const investorService = require("../services/investor.service");

exports.getInvestorProfile = async (req, res, next) => {
  try {
    const investor = await investorService.getInvestor();

    res.json(investor);
  } catch (error) {
    next(error);
  }
};
