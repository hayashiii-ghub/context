"use client";

import Image from "next/image";
import { useEffect, useRef, useState } from "react";

import styles from "./context.module.css";

type FeatureDemoProps = {
  id: string;
  webm: string;
  mp4: string;
  poster: string;
  caption: string;
};

export default function FeatureDemo({ id, webm, mp4, poster, caption }: FeatureDemoProps) {
  const figureRef = useRef<HTMLElement>(null);
  const videoRef = useRef<HTMLVideoElement>(null);
  const [hasEntered, setHasEntered] = useState(false);
  const [isInView, setIsInView] = useState(false);
  const [prefersReducedMotion, setPrefersReducedMotion] = useState(true);
  const [isPlaying, setIsPlaying] = useState(false);
  const [isUserPaused, setIsUserPaused] = useState(false);

  useEffect(() => {
    const media = window.matchMedia("(prefers-reduced-motion: reduce)");
    const syncMotionPreference = () => setPrefersReducedMotion(media.matches);
    syncMotionPreference();
    media.addEventListener("change", syncMotionPreference);

    const figure = figureRef.current;
    if (!figure || !("IntersectionObserver" in window)) {
      setHasEntered(true);
      setIsInView(true);
      return () => media.removeEventListener("change", syncMotionPreference);
    }

    const lazyObserver = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) setHasEntered(true);
      },
      { rootMargin: "200px 0px", threshold: 0.1 },
    );
    const visibilityObserver = new IntersectionObserver(
      ([entry]) => setIsInView(entry.isIntersecting),
      { threshold: 0.1 },
    );

    lazyObserver.observe(figure);
    visibilityObserver.observe(figure);
    return () => {
      lazyObserver.disconnect();
      visibilityObserver.disconnect();
      media.removeEventListener("change", syncMotionPreference);
    };
  }, []);

  useEffect(() => {
    const video = videoRef.current;
    if (!video) return;

    if (isInView && !prefersReducedMotion && !isUserPaused) {
      void video.play().catch(() => setIsPlaying(false));
    } else {
      video.pause();
    }
  }, [hasEntered, isInView, prefersReducedMotion, isUserPaused]);

  const togglePlayback = () => {
    const video = videoRef.current;
    if (!video) return;

    if (video.paused) {
      setIsUserPaused(false);
      void video.play();
    } else {
      setIsUserPaused(true);
      video.pause();
    }
  };

  const showVideo = hasEntered && !prefersReducedMotion;
  const captionId = `${id}-caption`;

  return (
    <figure ref={figureRef} className={styles.featureMedia}>
      {showVideo ? (
        <video
          ref={videoRef}
          className={styles.featureVideo}
          autoPlay
          muted
          loop
          playsInline
          preload="none"
          poster={poster}
          aria-describedby={captionId}
          onPlay={() => setIsPlaying(true)}
          onPause={() => setIsPlaying(false)}
        >
          <source src={webm} type="video/webm" />
          <source src={mp4} type="video/mp4" />
        </video>
      ) : (
        <Image
          className={styles.featurePoster}
          src={poster}
          width={1600}
          height={900}
          unoptimized
          alt=""
          sizes="(max-width: 900px) calc(100vw - 48px), 542px"
        />
      )}
      {showVideo ? (
        <button
          className={styles.demoControl}
          type="button"
          onClick={togglePlayback}
          aria-label={`${isPlaying ? "Pause" : "Play"} ${id} demo`}
        >
          {isPlaying ? "Pause" : "Play"}
        </button>
      ) : null}
      <figcaption className={styles.srOnly} id={captionId}>
        {caption}
      </figcaption>
    </figure>
  );
}
