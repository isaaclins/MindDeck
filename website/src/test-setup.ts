import "@testing-library/jest-dom/vitest";

class IntersectionObserverStub implements IntersectionObserver {
  readonly root = null;
  readonly rootMargin = "0px";
  readonly thresholds = [0];

  disconnect() {}
  observe() {}
  takeRecords(): IntersectionObserverEntry[] {
    return [];
  }
  unobserve() {}
}

Object.defineProperty(globalThis, "IntersectionObserver", {
  configurable: true,
  value: IntersectionObserverStub
});

const memoryStorage = new Map<string, string>();
Object.defineProperty(window, "localStorage", {
  configurable: true,
  value: {
    clear: () => memoryStorage.clear(),
    getItem: (key: string) => memoryStorage.get(key) ?? null,
    key: (index: number) => [...memoryStorage.keys()][index] ?? null,
    get length() {
      return memoryStorage.size;
    },
    removeItem: (key: string) => memoryStorage.delete(key),
    setItem: (key: string, value: string) => memoryStorage.set(key, value)
  }
});
