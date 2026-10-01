import { useState, useEffect, useRef } from 'react';

export default function TypewriterText({ text, speed = 15, onComplete }) {
  const [displayed, setDisplayed] = useState('');
  const [index, setIndex] = useState(0);
  const completedRef = useRef(false);

  useEffect(() => {
    setDisplayed('');
    setIndex(0);
    completedRef.current = false;
  }, [text]);

  useEffect(() => {
    if (index < text.length) {
      const timer = setTimeout(() => {
        setDisplayed((prev) => prev + text[index]);
        setIndex((prev) => prev + 1);
      }, speed);
      return () => clearTimeout(timer);
    } else if (!completedRef.current && onComplete) {
      completedRef.current = true;
      onComplete();
    }
  }, [index, text, speed, onComplete]);

  return <span style={{ whiteSpace: 'pre-wrap' }}>{displayed}</span>;
}
