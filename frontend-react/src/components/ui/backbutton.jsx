import { useNavigate } from 'react-router-dom';
import Button from './button';

export default function BackButton({
  label = 'Kembali',
  to = '/',
  className = '',
  onClick,
  ...props
}) {
  const navigate = useNavigate();
  const isHistoryNavigation = typeof to === 'number';

  const handleClick = (event) => {
    onClick?.(event);
    if (!event.defaultPrevented && isHistoryNavigation) navigate(to);
  };

  return (
    <Button
      variant="outline"
      to={isHistoryNavigation ? undefined : to}
      onClick={isHistoryNavigation || onClick ? handleClick : undefined}
      className={`w-full sm:w-auto ${className}`.trim()}
      startIcon={
        <span
          aria-hidden="true"
          className="transition-transform duration-300 group-hover:-translate-x-1">
          &larr;
        </span>
      }
      label={label}
      {...props}
    />
  );
}
