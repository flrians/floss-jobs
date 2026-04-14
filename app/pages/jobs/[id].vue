<template>
  <div class="job-detail-page">
    <main class="container page-content">
      <div v-if="loading" class="loading-state">
        <div class="pulse-ring"></div>
        <p>Fetching full opportunity details...</p>
      </div>

      <div v-else-if="job" class="detail-grid animate-fade">
        <div class="detail-main">
          <!-- Header Section -->
          <header class="detail-header card">
            <div class="header-top">
              <div class="company-info">
                <div class="company-logo icon-box">
                  <Briefcase :size="32" />
                </div>
                <div>
                  <div class="job-salary-top">
                    ${{ (job.salary_min || 0) / 1000 }}k – ${{ (job.salary_max || job.salary_min || 0) / 1000 }}k <small>/ Year</small>
                  </div>
                  <h1 class="job-title">{{ job.title }}</h1>
                  <div class="company-row">
                    <p class="company-name">{{ job.company }}</p>
                  </div>
                </div>
              </div>
              <div class="job-actions-right">
                <span :class="['status-badge', { 'active': job.is_active, 'offline': !job.is_active }]">
                  {{ job.is_active ? 'Active' : 'Offline' }}
                </span>
              </div>
            </div>

            <div class="header-meta">
              <div class="meta-item"><MapPin :size="18" /> <span>{{ job.location }}</span></div>
              <div class="meta-item"><Clock :size="18" /> <span>{{ job.work_type }}</span></div>
              <div class="meta-item"><Calendar :size="18" /> <span>Posted 2 days ago</span></div>
              <div class="meta-item"><Users :size="18" /> <span>10-50 Employees</span></div>
            </div>
          </header>

          <!-- Content Section -->
          <section class="detail-content card">
            <!-- 1. What you'll do -->
            <div class="content-block">
              <h2>What you'll do</h2>
              <ul>
                <li>Drive technical excellence and establish best practices within the team.</li>
                <li>Collaborate with product managers and designers to define project scopes.</li>
                <li>Optimize application performance and ensure high availability.</li>
                <li>Mentor junior engineers and contribute to a healthy engineering culture.</li>
              </ul>
            </div>

            <!-- 2. What the company searches for -->
            <div class="content-block">
              <h2>What the company searches for</h2>
              <div class="tags-row" style="margin-bottom: 1.5rem;">
                <span v-for="tag in job.tags" :key="tag" class="tag-large">{{ tag }}</span>
              </div>
              <p>We are looking for individuals who are not only technically proficient but also possess a strong desire to solve complex problems and contribute to a collaborative environment.</p>
            </div>

            <!-- 3. About the company -->
            <div class="content-block">
              <h2>About {{ job.company }}</h2>
              <p>{{ job.description || 'A visionary company dedicated to pushing the boundaries of technology and innovation.' }}</p>
            </div>

            <!-- 4. Benefits -->
            <div class="content-block">
              <h2>Benefits</h2>
              <div class="benefits-grid">
                <div v-for="benefit in (job.benefits || ['Competitive Equity', 'Remote-First Culture', 'Learning Budget'])" :key="benefit" class="benefit-item">
                  ✅ {{ benefit }}
                </div>
              </div>
            </div>
          </section>
        </div>

        <aside class="detail-sidebar">
          <div class="sticky-sidebar">
            <div class="action-card card">
              <h3>Ready to apply?</h3>
              <p>Apply directly via email or our portal to start the calibration process.</p>
              
              <a :href="'mailto:careers@' + job.company.toLowerCase().replace(' ', '') + '.com?subject=Application: ' + job.title" class="btn btn-primary btn-full">
                Apply via Email <Mail :size="18" style="margin-left: 0.75rem;" />
              </a>
              
              <button class="btn btn-ghost btn-full" @click="toggleFavourite">
                {{ isFavourite ? 'Saved to Favourites' : 'Save opportunity' }}
                <Heart :size="18" :class="{ 'filled': isFavourite }" style="margin-left: 0.75rem;" />
              </button>

              <div class="contact-info">
                <p><strong>Contact:</strong> HR Team</p>
                <p><strong>Email:</strong> careers@{{ job.company.toLowerCase().replace(' ', '') }}.com</p>
              </div>
            </div>

            <NuxtLink to="/jobs" class="back-link">
              <ArrowLeft :size="16" /> Back to matches
            </NuxtLink>
          </div>
        </aside>
      </div>

      <div v-else class="error-state">
        <h2>Opportunity not found</h2>
        <NuxtLink to="/jobs" class="btn btn-primary">Back to Jobs</NuxtLink>
      </div>
    </main>
  </div>
</template>

<script setup>
import { 
  Briefcase, MapPin, Clock, Calendar, Users, 
  Mail, Heart, ArrowLeft, Sparkles 
} from 'lucide-vue-next';

const supabase = useSupabaseClient();
const route = useRoute();
const id = route.params.id;
const loading = ref(true);
const job = ref(null);
const isFavourite = ref(false);

onMounted(async () => {
  try {
    const { data, error } = await supabase.from('jobs').select('*').eq('id', id).single();
    if (error) throw error;
    job.value = data;
  } catch (err) {
    console.error('Error fetching job:', err.message);
  } finally {
    loading.value = false;
  }
});

const toggleFavourite = () => {
  isFavourite.value = !isFavourite.value;
};
</script>

<style scoped>
.page-content { padding: 3rem 0; }

.detail-grid {
  display: grid;
  grid-template-columns: 1fr 350px;
  gap: 2rem;
  align-items: flex-start;
}

.detail-header {
  padding: 2rem 2.5rem;
  margin-bottom: 2rem;
}

.header-top {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 2rem;
}

.company-info {
  display: flex;
  gap: 1.5rem;
  align-items: center;
}

.job-salary-top {
  font-size: 1.1rem;
  color: var(--color-primary);
  font-weight: 700;
  margin-bottom: 0.25rem;
}

.job-salary-top small {
  font-size: 0.8rem;
  opacity: 0.8;
  font-weight: 600;
}

.job-title {
  font-size: 2.5rem;
  margin-bottom: 0.5rem;
  color: var(--color-text);
  letter-spacing: -0.02em;
  font-weight: 800;
}

.company-row {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.company-name {
  font-size: 1.1rem;
  color: var(--color-text-secondary);
  font-weight: 600;
}

.status-badge {
  padding: 0.3rem 0.8rem;
  border-radius: 4px;
  font-size: 0.7rem;
  font-weight: 800;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  white-space: nowrap;
}

.status-badge.active {
  background: #e6fffa;
  color: #38b2ac;
}

.status-badge.offline {
  background: #fff5f5;
  color: #e53e3e;
}

.job-actions-right {
  display: flex;
  align-items: center;
}

.header-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 2.5rem;
  padding-top: 1.5rem;
  border-top: 1px solid var(--color-border);
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--color-text-secondary);
  font-size: 0.9rem;
  font-weight: 500;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--color-text-secondary);
  font-size: 0.95rem;
}

.detail-content {
  padding: 3rem;
}

.content-block {
  margin-bottom: 3rem;
}

.content-block:last-child {
  margin-bottom: 0;
}

.content-block h2 {
  font-size: 1.5rem;
  margin-bottom: 1.25rem;
  color: var(--color-text);
}

.content-block p {
  font-size: 1.1rem;
  line-height: 1.8;
  color: var(--color-text-secondary);
}

.content-block ul {
  padding-left: 1.5rem;
}

.content-block li {
  margin-bottom: 0.75rem;
  color: var(--color-text-secondary);
  font-size: 1.1rem;
}

.tag-large {
  background: #f1f3f5;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  font-size: 0.9rem;
  font-weight: 600;
  color: var(--color-text-secondary);
  display: inline-block;
  margin-right: 0.5rem;
  margin-bottom: 0.5rem;
}

.benefits-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.benefit-item {
  padding: 1rem;
  background: #f8faf9;
  border-radius: 10px;
  font-weight: 600;
  font-size: 0.95rem;
}

/* Sidebar */
.sticky-sidebar {
  position: sticky;
  top: 100px;
}

.action-card {
  padding: 2rem;
  margin-bottom: 1.5rem;
}

.action-card h3 {
  margin-bottom: 0.75rem;
  font-size: 1.25rem;
}

.action-card p {
  font-size: 0.95rem;
  color: var(--color-text-secondary);
  margin-bottom: 1.5rem;
}

.btn-full {
  width: 100%;
  margin-bottom: 1rem;
}

.contact-info {
  margin-top: 2rem;
  padding-top: 1.5rem;
  border-top: 1px solid var(--color-border);
}

.contact-info p {
  font-size: 0.85rem;
  margin-bottom: 0.5rem;
}

.back-link {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--color-text-secondary);
  text-decoration: none;
  font-weight: 600;
  font-size: 0.95rem;
  padding: 0.5rem;
  transition: color 0.2s;
}

.back-link:hover {
  color: var(--color-primary);
}

.heart.filled {
  fill: #ff4757;
  color: #ff4757;
}

@media (max-width: 1024px) {
  .detail-grid {
    grid-template-columns: 1fr;
  }
  .sticky-sidebar {
    position: static;
  }
}
</style>
