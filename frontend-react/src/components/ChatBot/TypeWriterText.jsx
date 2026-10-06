import { useEffect, useReducer, useRef } from 'react';

function typewriterReducer(state, action) {
  switch (action.type) {
    case 'reset':
      return { displayed: '', index: 0 };
    case 'tick':
      return {
        displayed: state.displayed + action.char,
        index: state.index + 1,
      };
    default:
      return state;
  }
}

export default function TypewriterText({ text, speed = 15, onComplete }) {
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
      const timer = setTimeout(() => {
        dispatch({ type: 'tick', char: text[state.index] });
      }, speed);
      return () => clearTimeout(timer);
    }

    if (!completedRef.current && onComplete) {
      completedRef.current = true;
      onComplete();
    }
  }, [state.index, text, speed, onComplete]);

  return <span style={{ whiteSpace: 'pre-wrap' }}>{state.displayed}</span>;
}
