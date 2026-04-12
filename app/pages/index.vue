<template>
  <div class="landing-page">
    <header class="navbar">
      <div class="container nav-container">
        <NuxtLink to="/" class="logo">
          <Briefcase :size="28" />
          <span>FlossJobs</span>
        </NuxtLink>
        <div class="nav-links">
          <NuxtLink to="/login" class="btn btn-ghost btn-sm" style="margin-right: 1rem;">Login</NuxtLink>
          <NuxtLink to="/login" class="btn btn-primary btn-sm">Join Platform</NuxtLink>
        </div>
      </div>
    </header>

    <main>
      <!-- Hero Section -->
      <section class="section hero-bg">
        <div class="container hero-grid">
          <div class="hero-content animate-fade">
            <div class="badge" style="margin-bottom: 1.5rem;">AI-Matched opportunities</div>
            <h1 class="hero-title">
              Find your next <br />
              <span class="text-gradient">Dream Career.</span>
            </h1>
            <p class="hero-text">
              We connect your unique professional profile with curated job opportunities from across the internet using advanced AI matching.
            </p>
            <div class="hero-btn-group">
              <NuxtLink to="/login" class="btn btn-primary btn-lg">
                Get Started Now <ArrowRight :size="20" style="margin-left: 0.75rem;" />
              </NuxtLink>
            </div>
          </div>
          <div class="hero-visual animate-fade" style="animation-delay: 0.2s;">
            <div class="visual-wrapper card">
              <img src="/hero.png" alt="Platform Preview" class="hero-img" />
            </div>
          </div>
        </div>
      </section>

      <!-- Features -->
      <section class="section">
        <div class="container">
          <h2 class="section-title">Why Professionals Trust Us</h2>
          <p class="section-subtitle">A platform designed for the modern job seeker, focused on precision and professional growth.</p>
          
          <div class="feature-grid">
            <div class="card card-hover feature-card">
              <div class="icon-box">
                <Zap :size="24" />
              </div>
              <h3>Precision Matching</h3>
              <p>Skip the noise. Our algorithms ensure you only see roles that match your specific skill set and salary requirements.</p>
            </div>
            
            <div class="card card-hover feature-card">
              <div class="icon-box">
                <Star :size="24" />
              </div>
              <h3>Premium Profiles</h3>
              <p>Build a "legit" professional presence with detailed preferences, profile pictures, and curated portfolios.</p>
            </div>
            
            <div class="card card-hover feature-card">
              <div class="icon-box">
                <Globe :size="24" />
              </div>
              <h3>Global Sources</h3>
              <p>We aggregate job listings from thousands of sources to bring you the best deals in one clean dashboard.</p>
            </div>
          </div>
        </div>
      </section>
    </main>

    <footer class="footer">
      <div class="container footer-content">
        <div class="logo">
          <Briefcase :size="24" />
          <span>FlossJobs</span>
        </div>
        <p>&copy; 2026 Floss Jobs Inc. Professional Recruitment Platform.</p>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { Briefcase, ArrowRight, Zap, Star, Globe } from 'lucide-vue-next';
</script>

<style scoped>
.landing-page {
  background: white;
}

.hero-bg {
  padding: 6rem 0;
  background: radial-gradient(circle at 90% 10%, #f0fdf4 0%, transparent 40%);
}

.hero-grid {
  display: grid;
  grid-template-columns: 1.2fr 1fr;
  gap: 4rem;
  align-items: center;
}

.hero-title {
  font-family: var(--font-display);
  font-size: 4rem;
  margin-bottom: 1.5rem;
  color: #1a1a1a;
}

.hero-text {
  font-size: 1.25rem;
  color: var(--color-text-secondary);
  margin-bottom: 2.5rem;
  max-width: 550px;
}

.hero-visual {
  position: relative;
}

.visual-wrapper {
  overflow: hidden;
  padding: 0;
  box-shadow: var(--shadow-lg);
  border-color: var(--color-primary-light);
}

.hero-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}

.visual-wrapper:hover .hero-img {
  transform: scale(1.02);
}

.feature-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 2rem;
}

.feature-card h3 {
  margin: 1.5rem 0 1rem;
  font-size: 1.25rem;
}

.feature-card p {
  color: var(--color-text-secondary);
  font-size: 0.95rem;
  line-height: 1.6;
}

.footer {
  padding: 5rem 0;
  background: #fdfdfd;
  border-top: 1px solid var(--color-border);
}

.footer-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.footer-content p {
  color: var(--color-text-muted);
  font-size: 0.9rem;
}

@media (max-width: 968px) {
  .hero-grid {
    grid-template-columns: 1fr;
    text-align: center;
  }
  
  .hero-text {
    margin-left: auto;
    margin-right: auto;
  }
  
  .feature-grid {
    grid-template-columns: 1fr;
  }
  
  .footer-content {
    flex-direction: column;
    gap: 2rem;
  }
}
</style>
