import React, { useRef, useEffect } from 'react';

interface AudioVisualizerProps {
  isConnected: boolean;
  volume: number;
}

export const AudioVisualizer: React.FC<AudioVisualizerProps> = ({ isConnected, volume }) => {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const animationRef = useRef<number>();

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    // Set canvas size to match display size
    const resize = () => {
        canvas.width = canvas.parentElement?.clientWidth || 300;
        canvas.height = canvas.parentElement?.clientHeight || 150;
    };
    resize();
    window.addEventListener('resize', resize);

    const bars = 40;
    
    const render = () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      if (!isConnected) {
         // Resting state
         ctx.fillStyle = '#475569'; // slate-600
         const centerY = canvas.height / 2;
         ctx.beginPath();
         for(let i=0; i<canvas.width; i+=10) {
            ctx.arc(i, centerY, 2, 0, Math.PI * 2);
         }
         ctx.fill();
         return;
      }

      const centerX = canvas.width / 2;
      const centerY = canvas.height / 2;
      const barWidth = canvas.width / bars;

      // Dynamic color based on volume
      const r = Math.min(255, 100 + volume * 1000);
      const g = Math.min(255, 200 + volume * 500);
      const b = 100;
      ctx.fillStyle = `rgb(${r},${g},${b})`;

      for (let i = 0; i < bars; i++) {
        // Create a wave effect
        const t = Date.now() / 300;
        const wave = Math.sin(i * 0.5 + t) * 20;
        
        // Volume modulation
        const height = Math.max(4, (volume * 500) * Math.random() + 10 + wave);
        
        const x = i * barWidth;
        const y = centerY - height / 2;

        // Draw rounded bars
        ctx.beginPath();
        ctx.roundRect(x, y, barWidth - 2, height, 4);
        ctx.fill();
      }

      animationRef.current = requestAnimationFrame(render);
    };

    render();

    return () => {
      if (animationRef.current) cancelAnimationFrame(animationRef.current);
      window.removeEventListener('resize', resize);
    };
  }, [isConnected, volume]);

  return <canvas ref={canvasRef} className="w-full h-full" />;
};
