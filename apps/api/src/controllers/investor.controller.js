exports.getInvestorProfile = (req, res) => {
  res.json({
    company: "EAASGrid Platform Ltd",

    project: "Energy-as-a-Service (EaaS) Platform",

    stage: "Investor Showcase",

    funding_required: {
      currency: "NGN",
      amount: 298000000
    },

    business_model: [
      "Energy-as-a-Service",
      "Subscription Revenue",
      "Infrastructure Leasing",
      "Carbon Credits",
      "Energy Management Software"
    ],

    target_markets: [
      "Commercial",
      "Industrial",
      "Government",
      "Healthcare",
      "Education"
    ],

    projected_rollout: {
      pilot_sites: 6,
      annual_expansion_sites: 60
    },

    headquarters: "Ibadan, Nigeria"
  });
};
