import { readFileSync } from "node:fs";
import { describe, expect, it } from "vitest";

const bridgeSource = readFileSync(
  `${process.cwd()}/public/open/index.html`,
  "utf8"
);

describe("MindDeck share bridge", () => {
  it("automatically attempts the private custom-scheme handoff", () => {
    expect(bridgeSource).toContain("minddeck://import#");
    expect(bridgeSource).toContain("attemptOpen({ automatic: true })");
    expect(bridgeSource).toContain('document.addEventListener("visibilitychange"');
  });

  it("falls back to an install page without transmitting the deck", () => {
    expect(bridgeSource).toContain("fallbackUrl");
    expect(bridgeSource).toContain("v0.1.0-beta.1");
    expect(bridgeSource).not.toMatch(/\b(fetch|XMLHttpRequest|sendBeacon)\b/);
  });
});
