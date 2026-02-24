// @ts-check

/**
 * Seeded PRNG using mulberry32 algorithm.
 * Deterministic: same seed always produces the same sequence.
 */
export class Random {
  /** @type {number} */
  #state;

  /**
   * @param {number} seed — integer seed
   */
  constructor(seed) {
    this.#state = seed | 0;
  }

  /**
   * Returns a float in [0, 1).
   * @returns {number}
   */
  next() {
    let t = (this.#state += 0x6d2b79f5);
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  }

  /**
   * Returns an integer in [min, max] inclusive.
   * @param {number} min
   * @param {number} max
   * @returns {number}
   */
  nextInt(min, max) {
    return min + Math.floor(this.next() * (max - min + 1));
  }

  /**
   * Pick a random element from an array.
   * @template T
   * @param {T[]} array
   * @returns {T}
   */
  pick(array) {
    return array[this.nextInt(0, array.length - 1)];
  }

  /**
   * Random boolean.
   * @returns {boolean}
   */
  bool() {
    return this.next() < 0.5;
  }

  /**
   * In-place Fisher-Yates shuffle. Returns the same array.
   * @template T
   * @param {T[]} array
   * @returns {T[]}
   */
  shuffle(array) {
    for (let i = array.length - 1; i > 0; i--) {
      const j = this.nextInt(0, i);
      const tmp = array[i];
      array[i] = array[j];
      array[j] = tmp;
    }
    return array;
  }
}
