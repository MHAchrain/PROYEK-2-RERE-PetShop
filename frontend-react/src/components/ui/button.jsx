import { Link } from 'react-router-dom';

const variants = {
    primary: 'bg-primary text-white hover:bg-primary-600',
    secondary: 'bg-gray-100 text-gray-800 hover:bg-gray-200',
    outline: 'border-2 border-gray-200 bg-transparent text-gray-700 hover:border-primary hover:text-primary hover:shadow-lg',
    ghost: 'bg-transparent text-primary hover:bg-primary/10',
    danger: 'bg-red-600 text-white hover:bg-red-700',
};

const sizes = {
    sm: 'px-3 py-2 text-sm',
    md: 'px-5 py-3 text-sm',
    lg: 'px-8 py-4 text-base',
};

const baseClassName = 'inline-flex items-center justify-center gap-2 rounded-2xl font-medium transition-all duration-300 active:scale-95 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2 disabled:opacity-50';

const textSizePattern = /^text-(xs|sm|base|lg|xl|[2-9]xl)$/;
const fontWeightPattern = /^font-(thin|extralight|light|normal|medium|semibold|bold|extrabold|black)$/;

export default function Button({
  label,
  startIcon,
  endIcon,
    variant = 'primary',
    size = 'md',
    to,
    href,
    type = 'button',
    disabled = false,
    loading = false,
    className = '',
    ...props
}) {
    const selectedVariant = variants[variant] ?? variants.primary;
    const selectedSize = sizes[size] ?? sizes.md;
    const customClasses = className.split(/\s+/).filter(Boolean);
    const hasCustomTextSize = customClasses.some((name) => textSizePattern.test(name));
    const hasCustomFontWeight = customClasses.some((name) => fontWeightPattern.test(name));
    const baseClasses = hasCustomFontWeight
        ? baseClassName.replace('font-medium', '')
        : baseClassName;
    const sizeClasses = hasCustomTextSize
        ? selectedSize
            .split(/\s+/)
            .filter((name) => !textSizePattern.test(name))
            .join(' ')
        : selectedSize;
    const classes = `${baseClasses} ${selectedVariant} ${sizeClasses} ${className}`.trim();
    const isDisabled = disabled || loading;

    const content = (
        <>
        {loading && (
            <span
            aria-hidden="true"
            className="h-5 w-5 animate-spin rounded-full border-2 border-current/30 border-t-current"
            />
        )}
      {!loading && startIcon}
      {label}
      {!loading && endIcon}
        </>
    );

    if (to && !isDisabled) {
        return (
        <Link to={to} className={classes} aria-busy={loading || undefined} {...props}>
            {content}
        </Link>
        );
    }

    if (href && !isDisabled) {
        return (
        <a href={href} className={classes} aria-busy={loading || undefined} {...props}>
            {content}
        </a>
        );
    }

    return (
        <button
        type={type}
        className={classes}
        disabled={isDisabled}
        aria-busy={loading || undefined}
        {...props}>
        {content}
        </button>
    );
}
