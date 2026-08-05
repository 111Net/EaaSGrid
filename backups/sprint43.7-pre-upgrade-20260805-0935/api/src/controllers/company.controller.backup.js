exports.getCompanyProfile = (req, res) => {

  res.json({
    company: "EAASGrid Platform Ltd",

    parent_company: "IIMCICS Ltd",

    country: "Nigeria",

    platform: "Energy-as-a-Service (EaaS)",

    vision:
      "To become Africa's leading intelligent energy and enterprise infrastructure platform.",

    mission:
      "Deliver reliable distributed energy infrastructure through technology, automation and digital services.",

    current_stage:
      "Investor Showcase and Technology Validation",

    deployment:
      "Docker + FastAPI + Supabase",

    year_started: 2024
  });

};
