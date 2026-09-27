const states = ["Oyo", "Lagos", "Ogun", "Osun", "FCT", "Kwara", "Rivers", "Kaduna"];

const solutions = [
  ["Solar + Battery", "Reduce generator dependence with a managed solar and storage system."],
  ["Business Power", "Reliable power infrastructure designed around your operating hours and critical loads."],
  ["Energy Monitoring", "See generation, consumption, battery state and system health in one place."],
  ["Managed EaaS", "Move from equipment ownership to a predictable monthly energy service."],
];

export default function Home() {
  return (
    <main>
      <header className="nav">
        <a className="brand" href="#top"><span>✦</span> EaaSGrid</a>
        <nav>
          <a href="#solutions">Solutions</a><a href="#how">How it works</a>
          <a href="#states">Nigeria</a><a href="#resources">Resources</a>
        </nav>
        <a className="navCta" href="#assessment">Energy Assessment</a>
      </header>

      <section id="top" className="hero">
        <div className="heroCopy">
          <p className="eyebrow">ENERGY-AS-A-SERVICE · NIGERIA</p>
          <h1>Reliable energy, <em>designed around you.</em></h1>
          <p className="lead">EaaSGrid helps businesses and organisations move from uncertain power costs to managed, monitored and dependable energy.</p>
          <div className="actions"><a className="button primary" href="#assessment">Request an energy assessment</a><a className="button ghost" href="#how">See how EaaS works →</a></div>
          <div className="trust"><span>☀ Solar</span><span>◉ Battery</span><span>⌁ Monitoring</span><span>✓ Managed service</span></div>
        </div>
        <div className="heroPhoto" role="img" aria-label="African energy technician working on a solar installation" />
      </section>

      <section className="strip"><div><strong>36 states + FCT</strong><span>national architecture from day one</span></div><div><strong>Business-first</strong><span>solutions sized around real operating needs</span></div><div><strong>Human support</strong><span>engineering, installation and ongoing service</span></div></section>

      <section id="solutions" className="section"><div className="sectionHead"><p className="eyebrow">WHAT WE DELIVER</p><h2>Energy infrastructure as a service.</h2><p>From assessment to installation, monitoring and maintenance, EaaSGrid manages the energy lifecycle so you can focus on your organisation.</p></div>
        <div className="cards">{solutions.map(([title, text], i) => <article className="card" key={title}><div className="icon">0{i + 1}</div><h3>{title}</h3><p>{text}</p><a href="#assessment">Explore →</a></article>)}</div>
      </section>

      <section id="how" className="split"><div className="peoplePhoto" role="img" aria-label="African business team discussing an energy solution" /><div className="splitCopy"><p className="eyebrow">THE EaaS MODEL</p><h2>You don't have to become an energy company to get better power.</h2><p>We assess your energy profile, design the right system, coordinate delivery and keep the infrastructure working. You get a managed service with clear commercial terms.</p><ol><li><b>Discover</b><span>Tell us about your facility, power sources and operating needs.</span></li><li><b>Assess</b><span>Our team evaluates load, reliability, infrastructure and economics.</span></li><li><b>Design</b><span>We develop a system and commercial model appropriate to your site.</span></li><li><b>Operate</b><span>Installation, monitoring, maintenance and service continue after commissioning.</span></li></ol></div></section>

      <section id="states" className="section dark"><div className="sectionHead"><p className="eyebrow">NATIONWIDE BY DESIGN</p><h2>Built for Nigeria from the beginning.</h2><p>Every state and the Federal Capital Territory are part of the platform's location model. We start where we can execute well, then expand coverage.</p></div>
        <div className="stateGrid">{states.map((state) => <a href="#assessment" key={state}><span>{state}</span><small>Energy solutions →</small></a>)}</div>
        <p className="coverage">Abia · Adamawa · Akwa Ibom · Anambra · Bauchi · Bayelsa · Benue · Borno · Cross River · Delta · Ebonyi · Edo · Ekiti · Enugu · Gombe · Imo · Jigawa · Kaduna · Kano · Katsina · Kebbi · Kogi · Kwara · Lagos · Nasarawa · Niger · Ogun · Ondo · Osun · Oyo · Plateau · Rivers · Sokoto · Taraba · Yobe · Zamfara · FCT</p>
      </section>

      <section className="numbers"><div><b>01</b><span>Energy discovery</span></div><div><b>02</b><span>Technical assessment</span></div><div><b>03</b><span>System & financial design</span></div><div><b>04</b><span>Installation & operations</span></div></section>

      <section id="assessment" className="assessment"><div><p className="eyebrow">START HERE</p><h2>Let's understand your energy situation.</h2><p>Tell us where you operate and what you need. Our team can follow up with the right discovery conversation and assessment path.</p><div className="contactLine"><span>✉</span><a href="mailto:energy@xaasgrid.com">energy@xaasgrid.com</a></div></div><form action="mailto:energy@xaasgrid.com" method="post" encType="text/plain"><label>Name<input name="name" required placeholder="Your name" /></label><label>Organisation<input name="organisation" required placeholder="Company or organisation" /></label><label>State<select name="state" defaultValue=""><option value="" disabled>Select state / FCT</option>{[...states, "Abia", "Adamawa", "Akwa Ibom", "Anambra", "Bauchi", "Bayelsa", "Benue", "Borno", "Cross River", "Delta", "Ebonyi", "Edo", "Ekiti", "Enugu", "Gombe", "Imo", "Jigawa", "Kano", "Katsina", "Kebbi", "Kogi", "Nasarawa", "Niger", "Ondo", "Plateau", "Sokoto", "Taraba", "Yobe", "Zamfara"].filter((x, i, a) => a.indexOf(x) === i).sort().map(s => <option key={s}>{s}</option>)}</select></label><label>Phone<input name="phone" placeholder="+234 ..." /></label><label>What do you need?<textarea name="message" rows={4} placeholder="Solar, battery, backup, monitoring, EaaS or an assessment..." /></label><button className="button primary" type="submit">Request assessment →</button></form></section>

      <section id="resources" className="resource"><div className="resourcePhoto" role="img" aria-label="African technician inspecting an energy system" /><div><p className="eyebrow">DOCUMENTED FROM DAY ONE</p><h2>Built with a living BRD, UAT and operating record.</h2><p>The EaaS product will carry continuously updated business, functional, technical, energy, commercial, testing, UAT, deployment and rebuild documentation.</p><a className="button ghost" href="mailto:energy@xaasgrid.com?subject=EaaS%20Documentation%20Request">Request documentation →</a></div></section>

      <footer><div><a className="brand" href="#top"><span>✦</span> EaaSGrid</a><p>Energy-as-a-Service by XaaSGrid.</p></div><div><b>Contact</b><a href="mailto:energy@xaasgrid.com">energy@xaasgrid.com</a><a href="#assessment">Request assessment</a></div><div><b>Platform</b><a href="#solutions">Solutions</a><a href="#states">States & FCT</a><a href="#how">How it works</a></div></footer>
    </main>
  );
}
