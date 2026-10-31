import { useEffect, useReducer, useRef } from 'react';

function typewriterReducer(state, action) {
  switch (action.type) {
    case 'reset':
      return { displayed: '', index: 0 };
    case 'tick':
      return {
        displayed: state.displayed + action.char,
        index: state.index + action.char.length,
      };
    default:
      return state;
  }
}

function renderFormattedInline(text) {
  if (!text) return null;
  const lines = text.split('\n');
  return lines.map((line, lIdx) => {
    const parts = line.split(/(\*\*.*?\*\*)/g);
    return (
      <span key={lIdx} style={{ display: 'block', minHeight: line ? 'auto' : '0.6em' }}>
        {parts.map((part, pIdx) => {
          if (part.startsWith('**') && part.endsWith('**') && part.length >= 4) {
            return (
              <strong key={pIdx} className="rere-text-bold" style={{ fontWeight: 700 }}>
                {part.slice(2, -2)}
              </strong>
            );
          }
          return <span key={pIdx}>{part}</span>;
        })}
      </span>
    );
  });
}

export default function TypewriterText({ text, speed = 12, onComplete }) {
  const [state, dispatch] = useReducer(typewriterReducer, {
    displayed: '',
    index: 0,
  });
  const completedRef = useRef(false);

  useEffect(() => {
    dispatch({ type: 'reset' });
    completedRef.current = false;
  }, [text]);

  useEffect(() => {
    if (state.index < text.length) {
      const step = text.length > 500 ? 3 : text.length > 250 ? 2 : 1;
      const nextSlice = text.slice(state.index, state.index + step);
      const timer = setTimeout(() => {
        dispatch({ type: 'tick', char: nextSlice });
      }, speed);
      return () => clearTimeout(timer);
    }

    if (!completedRef.current && onComplete) {
      completedRef.current = true;
      onComplete();
    }
  }, [state.index, text, speed, onComplete]);

  return <span style={{ whiteSpace: 'pre-wrap' }}>{renderFormattedInline(state.displayed)}</span>;
}
