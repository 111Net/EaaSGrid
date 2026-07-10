import Overview from "./sections/Overview";
import Sites from "./sections/Sites";
import Energy from "./sections/Energy";
import Finance from "./sections/Finance";
import Performance from "./sections/Performance";


export default function Home() {
  return (
    <div className="bg-gray-50">

      <Overview />

      <Sites />

      <Energy />

      <Finance />

      <Performance />

    </div>
  );
}
