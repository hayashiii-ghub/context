"use client";

import Image from "next/image";
import { useEffect, useRef, useState } from "react";

import styles from "./context.module.css";

export default function ContextDemo() {
  const videoRef = useRef<HTMLVideoElement>(null);
  const [isPlaying, setIsPlaying] = useState(true);

  useEffect(() => {
    const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");

    const syncMotionPreference = () => {
      if (reducedMotion.matches) {
        videoRef.current?.pause();
      }
    };

    syncMotionPreference();
    reducedMotion.addEventListener("change", syncMotionPreference);
    return () => reducedMotion.removeEventListener("change", syncMotionPreference);
  }, []);

  const togglePlayback = () => {
    const video = videoRef.current;
    if (!video) return;

    if (video.paused) {
      void video.play();
    } else {
      video.pause();
    }
  };

  return (
    <figure className={styles.showcaseMedia}>
      <video
        ref={videoRef}
        className={styles.showcaseVideo}
        autoPlay
        muted
        loop
        playsInline
        preload="metadata"
        poster="/context/context-handoff-poster.webp"
        aria-describedby="context-demo-caption"
        onPlay={() => setIsPlaying(true)}
        onPause={() => setIsPlaying(false)}
      >
        <source src="/context/context-handoff.webm" type="video/webm" />
        <source src="/context/context-handoff.mp4" type="video/mp4" />
      </video>
      <Image
        className={styles.showcasePoster}
        src="/context/context-handoff-poster.webp"
        width={1600}
        height={900}
        unoptimized
        alt=""
        sizes="(max-width: 640px) calc(100vw - 28px), 1240px"
      />
      <button
        className={styles.demoControl}
        type="button"
        onClick={togglePlayback}
        aria-label={`${isPlaying ? "Pause" : "Play"} Context demo`}
      >
        {isPlaying ? "Pause" : "Play"}
      </button>
      <figcaption className={styles.srOnly} id="context-demo-caption">
        A Finder file is added to the Context menu bar shelf, then dragged into the next app.
      </figcaption>
    </figure>
  );
}
