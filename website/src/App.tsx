import { useEffect, useState, type ComponentType } from "react";
import {
  AndroidLogo,
  AppleLogo,
  ArrowDown,
  ArrowRight,
  CardsThree,
  CheckCircle,
  Desktop,
  FileArrowDown,
  Heart,
  LinkSimple,
  LinuxLogo,
  List,
  MoonStars,
  ShieldCheck,
  Sparkle,
  Sun,
  WifiSlash,
  WindowsLogo,
  X
} from "@phosphor-icons/react";
import { motion, useReducedMotion } from "motion/react";

type Theme = "light" | "dark";

const downloadOptions = [
  {
    label: "iPhone and iPad",
    note: "App Store build coming soon",
    status: "Coming soon",
    href: null,
    icon: AppleLogo
  },
  {
    label: "Android",
    note: "Development-signed beta APK",
    status: "Get beta",
    href: "https://github.com/isaaclins/MindDeck/releases/tag/v0.1.0-beta.1",
    icon: AndroidLogo
  },
  {
    label: "macOS",
    note: "Apple silicon and Intel",
    status: "Download",
    href: "https://github.com/isaaclins/MindDeck/releases/tag/v0.1.0-beta.1",
    icon: Desktop
  },
  {
    label: "Windows",
    note: "Windows 10 and newer",
    status: "Download",
    href: "https://github.com/isaaclins/MindDeck/releases/tag/v0.1.0-beta.1",
    icon: WindowsLogo
  },
  {
    label: "Linux",
    note: "Desktop package",
    status: "Download",
    href: "https://github.com/isaaclins/MindDeck/releases/tag/v0.1.0-beta.1",
    icon: LinuxLogo
  }
] as const;

const studySteps = [
  {
    title: "Write your deck",
    body: "A front, a back, and as many cards as the subject needs.",
    image: "images/deck-library.webp",
    alt: "MindDeck library with colorful handwritten deck covers",
    color: "violet"
  },
  {
    title: "Reveal and grade",
    body: "Think first, reveal the answer, then mark yourself right or wrong.",
    image: "images/study-front.webp",
    alt: "MindDeck study screen showing a large stacked flashcard",
    color: "rose"
  },
  {
    title: "Return at the right time",
    body: "Missed cards come back first. Progress stays with you across days.",
    image: "images/session-summary.webp",
    alt: "MindDeck session summary with correct and review cards",
    color: "green"
  }
] as const;

function getInitialTheme(): Theme {
  if (typeof window === "undefined") {
    return "light";
  }

  const savedTheme = window.localStorage?.getItem("minddeck-theme");
  if (savedTheme === "light" || savedTheme === "dark") {
    return savedTheme;
  }

  if (typeof window.matchMedia === "function") {
    return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
  }

  return "light";
}

function ThemeButton({
  theme,
  onToggle
}: {
  theme: Theme;
  onToggle: () => void;
}) {
  const Icon = theme === "dark" ? Sun : MoonStars;
  const nextTheme = theme === "dark" ? "light" : "dark";

  return (
    <button
      className="icon-button"
      type="button"
      onClick={onToggle}
      aria-label={`Use ${nextTheme} theme`}
      title={`Use ${nextTheme} theme`}
    >
      <Icon aria-hidden="true" size={21} weight="bold" />
    </button>
  );
}

function Header({
  theme,
  onToggleTheme
}: {
  theme: Theme;
  onToggleTheme: () => void;
}) {
  const [menuOpen, setMenuOpen] = useState(false);

  const closeMenu = () => setMenuOpen(false);

  return (
    <header className="site-header">
      <nav className="nav-shell" aria-label="Main navigation">
        <a className="brand" href="#top" onClick={closeMenu} aria-label="MindDeck home">
          <span className="brand-mark" aria-hidden="true">
            <CardsThree size={23} weight="fill" />
          </span>
          MindDeck
          <Sparkle className="brand-sparkle" size={16} weight="fill" aria-hidden="true" />
        </a>

        <div className={`nav-links ${menuOpen ? "is-open" : ""}`}>
          <a href="#how-it-works" onClick={closeMenu}>How it works</a>
          <a href="#learning" onClick={closeMenu}>Learning</a>
          <a href="#sharing" onClick={closeMenu}>Sharing</a>
          <a href="#privacy" onClick={closeMenu}>Privacy</a>
        </div>

        <div className="nav-actions">
          <ThemeButton theme={theme} onToggle={onToggleTheme} />
          <a className="button button-small nav-download" href="#download">
            Get MindDeck
            <ArrowDown size={16} weight="bold" aria-hidden="true" />
          </a>
          <button
            className="icon-button menu-button"
            type="button"
            onClick={() => setMenuOpen((open) => !open)}
            aria-label={menuOpen ? "Close navigation" : "Open navigation"}
            aria-expanded={menuOpen}
          >
            {menuOpen ? <X size={22} weight="bold" /> : <List size={22} weight="bold" />}
          </button>
        </div>
      </nav>
    </header>
  );
}

function Reveal({
  children,
  className = "",
  delay = 0
}: {
  children: React.ReactNode;
  className?: string;
  delay?: number;
}) {
  const reduceMotion = useReducedMotion();

  return (
    <motion.div
      className={className}
      initial={reduceMotion ? false : { opacity: 0, y: 22 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, amount: 0.2 }}
      transition={{ duration: 0.62, delay, ease: [0.16, 1, 0.3, 1] }}
    >
      {children}
    </motion.div>
  );
}

function Hero() {
  const reduceMotion = useReducedMotion();

  return (
    <main id="top">
      <section className="hero" aria-labelledby="hero-title">
        <div className="hero-copy">
          <motion.p
            className="hero-note"
            initial={reduceMotion ? false : { opacity: 0, rotate: -4, y: 10 }}
            animate={{ opacity: 1, rotate: -2, y: 0 }}
            transition={{ duration: 0.48, ease: [0.16, 1, 0.3, 1] }}
          >
            A little deck with a long memory
          </motion.p>
          <motion.h1
            id="hero-title"
            initial={reduceMotion ? false : { opacity: 0, y: 22 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.58, delay: 0.08, ease: [0.16, 1, 0.3, 1] }}
          >
            Make it. Flip it. <span>Know it.</span>
          </motion.h1>
          <motion.p
            className="hero-subtitle"
            initial={reduceMotion ? false : { opacity: 0, y: 16 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.58, delay: 0.16, ease: [0.16, 1, 0.3, 1] }}
          >
            Build your own decks, study what needs attention, and keep every card private on your device.
          </motion.p>
          <motion.div
            className="hero-actions"
            initial={reduceMotion ? false : { opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.58, delay: 0.24, ease: [0.16, 1, 0.3, 1] }}
          >
            <a className="button" href="#download">
              Get MindDeck
              <ArrowDown size={18} weight="bold" aria-hidden="true" />
            </a>
            <a className="text-link" href="#how-it-works">
              See how it works
              <ArrowRight size={17} weight="bold" aria-hidden="true" />
            </a>
          </motion.div>
        </div>

        <motion.figure
          className="hero-visual"
          initial={reduceMotion ? false : { opacity: 0, x: 32, rotate: 1.5 }}
          animate={{ opacity: 1, x: 0, rotate: -1 }}
          transition={{ type: "spring", stiffness: 90, damping: 18, delay: 0.12 }}
        >
          <div className="tape tape-top" aria-hidden="true" />
          <div className="hero-image-window">
            <picture>
              <source srcSet="images/minddeck-screen-concepts-v1.webp" type="image/webp" />
              <img
                src="images/minddeck-screen-concepts-v1.png"
                alt="Eight MindDeck app screen concepts showing deck creation, studying, sharing, and importing"
                width="1672"
                height="941"
                fetchPriority="high"
              />
            </picture>
          </div>
          <figcaption>Every part feels like a deck you made by hand.</figcaption>
        </motion.figure>
      </section>

      <section className="platform-strip" aria-label="Supported platforms">
        <p>One deck. Every screen.</p>
        <div>
          {downloadOptions.map(({ label, icon: Icon }) => (
            <span key={label}>
              <Icon size={20} weight="fill" aria-hidden="true" />
              {label}
            </span>
          ))}
        </div>
      </section>
    </main>
  );
}

function HowItWorks() {
  return (
    <section className="steps-section" id="how-it-works" aria-labelledby="steps-title">
      <div className="section-heading">
        <h2 id="steps-title">Your cards, in your handwriting.</h2>
        <p>Build a deck once. MindDeck keeps the difficult cards close until they finally stick.</p>
      </div>

      <div className="steps-layout">
        {studySteps.map((step, index) => (
          <Reveal
            className={`step-card step-card-${index + 1} accent-${step.color}`}
            delay={index * 0.08}
            key={step.title}
          >
            <div className="step-image">
              <img src={step.image} alt={step.alt} width="400" height={index === 2 ? "440" : "458"} loading="lazy" />
            </div>
            <div className="step-copy">
              <span className="scribble-number" aria-hidden="true">{index + 1}</span>
              <h3>{step.title}</h3>
              <p>{step.body}</p>
            </div>
          </Reveal>
        ))}
      </div>
    </section>
  );
}

function LearningSection() {
  const learningPoints = [
    "Wrong answers return first",
    "Progress carries across days",
    "Both directions can learn separately",
    "Every answer stays on your device"
  ];

  return (
    <section className="learning-section" id="learning" aria-labelledby="learning-title">
      <Reveal className="learning-visual">
        <div className="card-stack" aria-hidden="true">
          <div className="memory-card card-shadow-two" />
          <div className="memory-card card-shadow-one" />
          <div className="memory-card card-face">
            <Sparkle size={28} weight="fill" />
            <span className="card-question">What needs work?</span>
            <strong>The card you missed.</strong>
            <span className="card-underline" />
          </div>
        </div>
      </Reveal>

      <Reveal className="learning-copy" delay={0.08}>
        <h2 id="learning-title">Random enough to stay fresh. Smart enough to help.</h2>
        <p>
          MindDeck starts with overdue and difficult cards, then brings in new ones. You grade yourself after every reveal.
        </p>
        <ul className="check-list">
          {learningPoints.map((point) => (
            <li key={point}>
              <CheckCircle size={22} weight="fill" aria-hidden="true" />
              {point}
            </li>
          ))}
        </ul>
      </Reveal>
    </section>
  );
}

function PrivacySection() {
  return (
    <section className="privacy-section" id="privacy" aria-labelledby="privacy-title">
      <Reveal className="privacy-copy">
        <div className="privacy-icon" aria-hidden="true">
          <WifiSlash size={44} weight="bold" />
          <ShieldCheck size={29} weight="fill" />
        </div>
        <h2 id="privacy-title">No account. No cloud. No audience.</h2>
        <p>
          Decks and learning progress live locally. Open MindDeck offline on a train, at school, or wherever focus finds you.
        </p>
      </Reveal>

      <div className="privacy-notes" aria-label="Local-first benefits">
        <Reveal className="paper-note note-green" delay={0.05}>
          <Heart size={23} weight="fill" aria-hidden="true" />
          <strong>Yours by default</strong>
          <span>No sign-in screen between you and studying.</span>
        </Reveal>
        <Reveal className="paper-note note-yellow" delay={0.12}>
          <ShieldCheck size={23} weight="fill" aria-hidden="true" />
          <strong>Private by design</strong>
          <span>Sharing never includes your learning history.</span>
        </Reveal>
      </div>
    </section>
  );
}

function SharingSection() {
  return (
    <section className="sharing-section" id="sharing" aria-labelledby="sharing-title">
      <div className="sharing-copy">
        <Reveal>
          <h2 id="sharing-title">Pass the deck, not your data.</h2>
          <p>
            A shared deck is an independent snapshot. Preview it first, import it once, then learn entirely offline.
          </p>
        </Reveal>

        <div className="share-choices">
          <Reveal className="share-choice" delay={0.05}>
            <LinkSimple size={31} weight="bold" aria-hidden="true" />
            <div>
              <h3>Send a link</h3>
              <p>Small decks fit into one self-contained link.</p>
            </div>
          </Reveal>
          <Reveal className="share-choice" delay={0.12}>
            <FileArrowDown size={31} weight="bold" aria-hidden="true" />
            <div>
              <h3>Send a .minddeck file</h3>
              <p>Large decks travel as one portable file.</p>
            </div>
          </Reveal>
        </div>
      </div>

      <Reveal className="share-visual" delay={0.1}>
        <img
          src="images/share-deck.webp"
          alt="MindDeck share screen with link and file choices"
          width="400"
          height="440"
          loading="lazy"
        />
      </Reveal>
    </section>
  );
}

function DownloadIcon({
  icon: Icon
}: {
  icon: ComponentType<{ size?: number; weight?: "fill"; "aria-hidden"?: "true" }>;
}) {
  return <Icon size={27} weight="fill" aria-hidden="true" />;
}

function DownloadSection() {
  return (
    <section className="download-section" id="download" aria-labelledby="download-title">
      <div className="download-heading">
        <Sparkle size={24} weight="fill" aria-hidden="true" />
        <h2 id="download-title">Take your deck anywhere.</h2>
        <p>Native apps for phones, tablets, laptops, and desktops.</p>
      </div>

      <div className="download-grid">
        {downloadOptions.map(({ label, note, status, href, icon }) => {
          const content = (
            <>
              <DownloadIcon icon={icon} />
              <div>
                <strong>{label}</strong>
                <span>{note}</span>
              </div>
              <span className="release-note">{status}</span>
            </>
          );

          return href ? (
            <a className="download-item" href={href} key={label}>
              {content}
            </a>
          ) : (
            <div className="download-item" key={label}>
              {content}
            </div>
          );
        })}
      </div>

      <p className="download-footnote">
        Android and desktop builds are published with every tagged release. Store builds follow after signing.
      </p>
    </section>
  );
}

function Footer() {
  return (
    <footer className="footer">
      <div className="footer-brand">
        <span className="brand-mark" aria-hidden="true">
          <CardsThree size={23} weight="fill" />
        </span>
        <div>
          <strong>MindDeck</strong>
          <span>Made for learning, not collecting accounts.</span>
        </div>
      </div>
      <div className="footer-links">
        <a href="#how-it-works">How it works</a>
        <a href="#privacy">Privacy</a>
        <a href="#download">Downloads</a>
      </div>
      <p>Keep the cards. Keep the progress.</p>
    </footer>
  );
}

export function App() {
  const [theme, setTheme] = useState<Theme>(getInitialTheme);

  useEffect(() => {
    document.documentElement.dataset.theme = theme;
    window.localStorage?.setItem("minddeck-theme", theme);
  }, [theme]);

  return (
    <>
      <a className="skip-link" href="#content">Skip to content</a>
      <Header theme={theme} onToggleTheme={() => setTheme((current) => current === "dark" ? "light" : "dark")} />
      <div id="content">
        <Hero />
        <HowItWorks />
        <LearningSection />
        <PrivacySection />
        <SharingSection />
        <DownloadSection />
      </div>
      <Footer />
    </>
  );
}
