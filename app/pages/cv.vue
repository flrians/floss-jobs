<template>
  <div class="cv-page">
    <main class="container page-content">
      <div class="coming-soon-card animate-fade">
        <div class="coming-soon-content">
          <h1 class="text-gradient">Coming Soon</h1>
          <p>We're engineering a high-precision AI CV optimizer. Stay tuned for the next evolution of job matching.</p>
        </div>
      </div>
    </main>
  </div>
</template>

<style scoped>
.page-content {
  height: calc(100vh - 72px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
}

.coming-soon-card {
  width: 100%;
  max-width: 500px;
  padding: 3rem;
  text-align: center;
  background: white;
  border-radius: var(--radius-lg);
  border: 1px solid var(--color-border);
  box-shadow: var(--shadow-sm);
}

.coming-soon-content h1 {
  font-size: 2.75rem;
  font-weight: 900;
  margin-bottom: 1rem;
  letter-spacing: -0.05em;
}

.coming-soon-content p {
  font-size: 1rem;
  color: var(--color-text-secondary);
  max-width: 350px;
  margin: 0 auto;
  line-height: 1.5;
}
</style>
