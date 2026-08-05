const lifecycle = [
 {
   customer:"Lagos Industrial Power Services",
   service:"Energy-as-a-Service",
   stage:"Production",
   health:"Healthy"
 },
 {
   customer:"African Smart Infrastructure Group",
   service:"Infrastructure Monitoring",
   stage:"Scaling",
   health:"Healthy"
 }
];


module.exports = {
 getLifecycle(){
    return lifecycle;
 }
};
