export enum FeatureFlag {
    foo = "foo",
    bar = "bar",
}

export function takesFeatureFlag(flag: FeatureFlag): void

export function returnsFeatureFlag(): FeatureFlag
