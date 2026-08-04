exports.getPlatformStatus = (req, res) => {

    res.json({
        platform: "EaaSGrid",
        status: "operational",
        version: "1.0"
    });

};
