/** @type {import('next').NextConfig} */

const nextConfig = {


async rewrites(){


return [

{

source:"/api/:path*",

destination:
"http://xaasgrid-api:4000/api/:path*"

}

];


}



};


module.exports = nextConfig;
