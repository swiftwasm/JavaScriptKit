declare function benchmarkHelperNoop(): void;
declare function benchmarkHelperNoopWithNumber(n: number): void;
declare function benchmarkRunner(name: string, body: (n: number) => void): void;
