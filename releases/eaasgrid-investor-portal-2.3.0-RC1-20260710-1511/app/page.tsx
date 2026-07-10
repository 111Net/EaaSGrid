import Hero from "./sections/Hero";
import Problem from "./sections/Problem";
import Solution from "./sections/Solution";
import BusinessModel from "./sections/BusinessModel";
import Market from "./sections/Market";
import Financials from "./sections/Financials";
import Roadmap from "./sections/Roadmap";
import Contact from "./sections/Contact";

export default function Home() {
  return (
    <main>
      <Hero />
      <Problem />
      <Solution />
      <BusinessModel />
      <Market />
      <Financials />
      <Roadmap />
      <Contact />
    </main>
  );
}
