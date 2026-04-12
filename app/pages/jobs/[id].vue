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
                  <h1 class="job-title">{{ job.title }}</h1>
                  <p class="company-name">{{ job.company }}</p>
                </div>
              </div>
              <div class="job-salary-badge">
                ${{ job.salary / 1000 }}k <small>/ Year</small>
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
            <div class="content-block">
              <h2>About the Role</h2>
              <p>{{ job.description || 'We are looking for a passionate professional to join our fast-growing team. You will be responsible for building scalable solutions and collaborating with cross-functional teams to deliver high-quality products.' }}</p>
            </div>

            <div class="content-block">
              <h2>Technical Environment</h2>
              <div class="tags-row">
                <span v-for="tag in job.tags" :key="tag" class="tag-large">{{ tag }}</span>
              </div>
            </div>

            <div class="content-block">
              <h2>What you'll do</h2>
              <ul>
                <li>Drive technical excellence and establish best practices within the team.</li>
                <li>Collaborate with product managers and designers to define project scopes.</li>
                <li>Optimize application performance and ensure high availability.</li>
                <li>Mentor junior engineers and contribute to a healthy engineering culture.</li>
              </ul>
            </div>

            <div class="content-block">
              <h2>Benefits</h2>
              <div class="benefits-grid">
                <div class="benefit-item">✅ Competitive Equity</div>
                <div class="benefit-item">✅ Remote-First Culture</div>
                <div class="benefit-item">✅ Learning Budget ($2k/year)</div>
                <div class="benefit-item">✅ Private Healthcare</div>
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
  padding: 2.5rem;
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

.job-title {
  font-size: 2.25rem;
  margin-bottom: 0.25rem;
  color: var(--color-text);
}

.company-name {
  font-size: 1.25rem;
  color: var(--color-primary);
  font-weight: 700;
}

.job-salary-badge {
  background: var(--color-primary-light);
  color: var(--color-primary);
  padding: 0.75rem 1.5rem;
  border-radius: 12px;
  font-weight: 800;
  font-size: 1.25rem;
}

.job-salary-badge small {
  font-size: 0.8rem;
  opacity: 0.8;
}

.header-meta {
  display: flex;
  gap: 2rem;
  padding-top: 2rem;
  border-top: 1px solid var(--color-border);
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
