interface Animatable {
    animate(keyframes: any, options: any): any;
    getAnimations(options: any): any;
}

export function returnAnimatable(): Animatable;
