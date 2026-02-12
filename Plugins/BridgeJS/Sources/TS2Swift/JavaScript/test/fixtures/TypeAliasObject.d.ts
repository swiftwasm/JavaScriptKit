/**
 * Console from the environment.
 */
export type Console = {
    /**
     * Log a message.
     */
    log(message: string): void;
};

export function console(): Console;
