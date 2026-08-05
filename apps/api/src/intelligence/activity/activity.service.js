const events = [
    {
        company:"GreenGrid Energy Nigeria Ltd",
        event:"Solar service activated",
        status:"SUCCESS",
        time:new Date()
    },
    {
        company:"NovaBank Digital Services",
        event:"API integration completed",
        status:"SUCCESS",
        time:new Date()
    },
    {
        company:"Continental Logistics Cloud",
        event:"Lifecycle upgrade deployed",
        status:"RUNNING",
        time:new Date()
    }
];


module.exports = {
    getActivity(){
        return events;
    }
};
