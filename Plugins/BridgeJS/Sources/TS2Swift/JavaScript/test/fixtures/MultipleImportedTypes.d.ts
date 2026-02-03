// Test case for multiple imported types with methods and properties
export interface DatabaseConnection {
    connect(url: string): void;
    execute(query: string): any;
    readonly isConnected: boolean;
    connectionTimeout: number;
}

export interface Logger {
    log(message: string): void;
    error(message: string, error: any): void;
    readonly level: string;
}

export interface ConfigManager {
    get(key: string): any;
    set(key: string, value: any): void;
    readonly configPath: string;
}

export function createDatabaseConnection(config: any): DatabaseConnection;
export function createLogger(level: string): Logger;
export function getConfigManager(): ConfigManager;