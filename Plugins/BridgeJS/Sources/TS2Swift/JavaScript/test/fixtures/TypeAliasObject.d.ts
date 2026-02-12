export type Console = {
    log(message: string): void;
};

export function console(): Console;
