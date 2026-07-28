import { defineConfig, loadEnv } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig(({ mode }) => {
  const environment = loadEnv(mode, process.cwd(), "");
  const configuredBase = environment.VITE_BASE_PATH?.trim();

  return {
    base: configuredBase || "./",
    plugins: [react()],
    test: {
      environment: "jsdom",
      setupFiles: "./src/test-setup.ts",
      css: true
    }
  };
});
