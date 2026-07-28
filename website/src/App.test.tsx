import { cleanup, render, screen } from "@testing-library/react";
import { afterEach, describe, expect, it } from "vitest";
import { App } from "./App";

afterEach(cleanup);

describe("MindDeck marketing page", () => {
  it("renders the core product promise and every supported platform", () => {
    render(<App />);

    expect(
      screen.getByRole("heading", { name: "Make it. Flip it. Know it." })
    ).toBeInTheDocument();
    expect(
      screen.getByRole("heading", { name: /No account. No cloud/i })
    ).toBeInTheDocument();

    for (const platform of [
      "iPhone and iPad",
      "Android",
      "macOS",
      "Windows",
      "Linux"
    ]) {
      expect(screen.getAllByText(platform).length).toBeGreaterThan(0);
    }
  });

  it("includes useful navigation landmarks", () => {
    render(<App />);

    expect(screen.getByRole("navigation", { name: "Main navigation" })).toBeInTheDocument();
    expect(screen.getByRole("contentinfo")).toBeInTheDocument();
  });
});
