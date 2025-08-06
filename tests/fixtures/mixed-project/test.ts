// Mixed project test file - can be used with both Deno and Node.js

export function add(a: number, b: number): number {
  return a + b;
}

export function multiply(x: number, y: number): number {
  return x * y;
}

// Deno test
if (typeof Deno !== "undefined") {
  Deno.test("add function", () => {
    const result = add(2, 3);
    if (result !== 5) {
      throw new Error(`Expected 5, got ${result}`);
    }
  });
}

// Node.js compatible export
if (typeof module !== "undefined" && module.exports) {
  module.exports = { add, multiply };
}