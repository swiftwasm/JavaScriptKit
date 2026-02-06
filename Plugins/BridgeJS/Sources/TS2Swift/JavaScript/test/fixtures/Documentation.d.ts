/**
 * Return a greeting for a user.
 * @param name The user's name.
 * @returns The greeting message.
 */
export function greet(name: string): string;

/**
 * Represents a 2D point.
 */
export interface Point {
    /**
     * The horizontal position.
     */
    x: number;

    /**
     * Translate the point.
     * @param dx Delta to apply on x.
     * @param dy Delta to apply on y.
     * @returns The moved point.
     */
    translate(dx: number, dy: number): Point;
}

export function origin(): Point;

/**
 * Move a point by the given delta.
 * @param point The point to move.
 * @param dx Delta to apply on x.
 * @param dy Delta to apply on y.
 */
export function translatePoint(point: Point, dx: number, dy: number): Point;

/**
 * A greeter that keeps the target name.
 */
export class Greeter {
    /**
     * Create a greeter.
     * @param name Name to greet.
     */
    constructor(name: string);

    /**
     * The configured name.
     */
    readonly targetName: string;

    /**
     * Say hello.
     * @returns Greeting message.
     */
    greet(): string;
}
